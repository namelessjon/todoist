module Todoist
  ##
  # Project
  #
  # A todoist project.
  class Project
    attr_reader :name, :id, :user_id, :color, :collapsed, :order, :indent

    ##
    # Get all projects
    #
    # Fetches all the user's todist projects.
    #
    # @return [Array] An Array of todoist project instances.
    def self.all
      projects = []
      Base.get('/getProjects').each do |project|
        projects << new_from_api_request(project)
      end
      projects
    end

    ##
    # Get a project
    #
    # Fetches a todoist project
    #
    # @param [Integer,Todoist::Project] id The id, or project, to fetch
    #
    # @return [Todoist::Project] The fetched project.
    def self.get(id)
      new_from_api_request(get_project(id))
    end

    ##
    # Create a new project
    #
    # Creates a new Todoist project.
    #
    # @param [String] name The name of the project
    #
    # @param [Hash]   parameters The other parameters which make up the project.
    #
    # @return [Todoist::Project] The new todoist project.
    def initialize(name, parameters={})
      @name       = name
      @id         = parameters['id']
      @user_id    = parameters['user_id']
      @color      = parameters['color']
      @collapsed  = parameters['collapsed']
      @order      = parameters['item_order']
      @indent     = parameters['indent']
    end


    def to_s
      "#{name}"
    end

    def to_i
      id
    end

    def inspect
      "<Project:#{name}:#{id}:#{task_count}:user_id=#{user_id} color='#{color}' collapsed=#{collapsed?} order=#{order} indent=#{indent}>"
    end

    def collapsed?
      (collapsed == 1) ? true : false
    end


    ##
    # The task count
    #
    # The number of tasks a project has
    #
    # @return [Integer] The number of tasks this project has
    def task_count
      @all_tasks ||= Task.all(self)
      @all_tasks.size
    end

    ##
    # Get uncompleted tasks for the project
    #
    # @return [Array] An Array of Todoist::Tasks
    def tasks
      @uncompleted_tasks ||= Task.uncompleted(self)
    end

    ##
    # Get completed tasks for the project
    #
    # @return [Array] An Array of completed Todoist::Tasks
    def completed_tasks
      @completed_tasks ||= Task.completed(self)
    end

    ##
    # Add task
    #
    # Adds a task to the project.
    #
    # @param [String] content The content of the new task
    #
    # @param [Hash] opts The options for the new task
    #
    # @return [Todoist::Task] The new task.
    def add_task(content, opts={})
      Task.new(content, self, opts).save
    end

    private

    def self.new_from_api_request(project)
      name = project.delete('name')
      new(name, project)
    end

    def self.get_project(id)
      Base.get('/getProject', :query => {:project_id => id.to_i })
    end

  end
end
