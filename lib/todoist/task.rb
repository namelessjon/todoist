require 'time'
module Todoist
  ##
  # Todoist Task
  #
  # A todoist task.
  class Task
    attr_accessor :content, :priority, :task_details, :project_id
    attr_reader   :date, :id
    ##
    # Get tasks for a project
    #
    # Retrieves all uncompleted tasks from the todoist service for the project id.
    #
    # @param [Integer,Todoist::Project] project The project to get tasks for
    #
    # @return [Array] An array of todoist tasks.
    def self.uncompleted(project)
      make_tasks(Base.get('/getUncompletedItems', :query => { :project_id => project.to_i }))
    end

    ##
    # Get completed tasks for project
    #
    # Retrieves completed tasks from the todoist service for the project id.
    #
    # @param [Integer,Todoist::Project] project The project to get tasks for
    #
    # @return [Array] An array of todoist tasks.
    def self.completed(project)
      make_tasks(Base.get('/getCompletedItems', :query => { :project_id => project.to_i }))
    end

    ##
    # Complete tasks
    #
    # Completes a list of tasks
    #
    # @param [Array,Integer,Todist::Task] ids A list of tasks to complete.
    def self.complete(*ids)
      make_tasks(Base.get('/completeItems', :query => {:ids => id_array(ids)}))
    end

    ##
    # Get Tasks by ID
    #
    # Retrives a list of tasks from the todoist service.
    #
    # @param [Array,Integer,Todist::Task] ids A list of tasks to retrieve
    #
    # @return [Array] An array of Todist::Tasks
    def self.get(*ids)
      make_tasks(Base.get('/getItemsById', :query => {:ids => id_array(ids)}))
    end

    ##
    # Get all tasks
    #
    # Retrieves all the uncompleted tasks
    #
    # @return [Array] An array of Todist::Tasks
    def self.all
      query('viewall')['viewall']
    end

    ##
    # Get overdue tasks
    #
    # Retrieves all the overdue tasks
    #
    # @return [Array] An array of overdue Todist::Tasks
    def self.overdue
      query('overdue')['overdue']
    end


    ##
    # Query
    #
    # Use the task query API to get back several arrays of tasks.
    #
    # @param [String,Array] query A query or a list of queries to perform
    #
    # @return [Hash] a hash keyed on query, containing arrays of tasks.
    #
    # Allowed queries
    #   viewall:: All tasks
    #   overdue:: All overdue tasks
    #   p[123]::      All tasks of priority 1, 2 ,3
    def self.query(*queries)
      query = '["' + queries.flatten.map { |q| q.to_s }.join('","') + '"]'
      results = {}
      response = Base.get('/query', :query => { :queries => query })

      response.each do |q|
        if q['type'] == 'viewall'
          tasks = []
          q['data'].each do |stuff|
            tasks << make_tasks(stuff['uncompleted'])
          end
          results[q['type']] = tasks.flatten
        else
          results[q['type']] = make_tasks(q['data'])
        end
      end
      results
    end

    ##
    # Create a new task
    #
    # @param [String] content The content of the new task.
    #
    # @param [Integer,Todoist::Project] project The project to create the new task in
    #
    # @param [Hash] opts Optional priority and due date for creation.
    def self.create(content, project, opts={})
      query = {:project_id => project.to_i, :content => content.to_s }
      query['priority'] = opts.delete('priority') if opts.has_key?('priority')
      query['date_string'] = opts.delete('date_string') if opts.has_key?('date_string')

      new_from_api(Base.get('/addItem', :query => query))
    end

    ##
    # Updates a task
    #
    # @param [String] content The new content of the task.
    #
    # @param [Integer,Todoist::Task] id The task to update
    #
    # @param [Hash] opts Optional priority and due date for creation.
    def self.update(content, id, opts={})
      query = {:id => project.to_i, :content => content.to_s }
      query['priority'] = opts.delete('priority') if opts.has_key?('priority')
      query['date_string'] = opts.delete('date_string') if opts.has_key?('date_string')

      new_from_api(Base.get('/updateItem', :query => query))
    end



    def initialize(content, project_id, d={})
      @content    = content
      @project_id = project_id.to_i
      @date       = d.delete('date') || d.delete('date_string')
      @priority   = d.delete('priority')
      @id         = d.delete('id')
      @task_details = d
    end

    ##
    # Is the task complete
    def complete?
      (@task_details['in_history'] == 1) ? true : false
    end


    ##
    # Complete
    #
    # Completes the todoist task
    def complete
      self.class.complete(self) unless complete?
      @task_details['in_history'] = 1
    end

    ##
    # Is the task overdue?
    def overdue?
      return false unless due_date
      Time.now > Time.parse(due_date)
    end

    ##
    # Project
    #
    # Retreives the project for the task
    def project
      Project.get(project_id)
    end

    ##
    # Saves the task
    #
    # Save the task, either creating a new task on the todoist service, or
    # updating a previously retrieved task with new content, priority etc.
    def save
      opts = {}
      opts['priority'] = priority if priority
      opts['date_string'] = date if date
      # if we don't have an id, then we can assume this is a new task.
      unless (task_details.has_key?('id'))
        result = self.class.create(self.content, self.project_id, opts)
      else
        result = self.class.update(self.content, self.id, opts)
      end

      self.content      = result.content
      self.project_id   = result.project_id
      self.task_details = result.task_details
      self
    end

    def add_note(content)
      query = {item_id: id, content: content}
      Todoist::Base.post('/addNote', :query => query)
    end

    def notes
      response = Base.get('/getNotes', :query => {item_id: id})
      response.map { |n| Todoist::Note.new(n.merge!('task' => self)) }
    end

    def to_s
      @content
    end

    def to_i
      id
    end

    def inspect
      "<Todoist::Task:#{content}:#{id}:#{project_id}:#{task_details.inspect}>"
    end

    def method_missing(*args, &block)
      # the method name
      m = args.shift
      if @task_details.has_key?(m.to_s)
        return @task_details[m.to_s]
      else
        raise NoMethodError, "undefined method `#{m}' for #{self.inspect}"
      end
    end

    private

    def self.new_from_api(task)
      content = task.delete('content')
      project_id = task.delete('project_id')
      new(content, project_id, task)
    end

    def self.make_tasks(tasks)
      new_tasks = []
      tasks.each do |task|
        new_tasks << new_from_api(task)
      end
      new_tasks
    end

    def self.id_array(*ids)
      "[" + ids.flatten.map { |q| q.to_i }.join(",") + "]"
    end


# {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 0, "has_notifications": 0, "checked": 0, "indent": 1, "children": null, "content": "Finish this gem", "user_id": 34615, "mm_offset": 0, "in_history": 0, "id": 4152190, "priority": 4, "item_order": 1, "project_id": 528294, "chains": null, "date_string": ""}
  end
end
