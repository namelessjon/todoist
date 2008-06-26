module Todoist

  ##
  #
  # Provides methods for dealing with projects from todoist.com, wrapping the
  # returned JSON in a class offering methods for ease of interacting with
  # projects and its associated tasks and subprojects.
  class Project
    attr_reader :name, :id, :user_id, :order, :task_count
    def initialize(name, id = nil, user_id = nil, order = nil, task_count = nil)
      @name = name
      @id = id
      @user_id = user_id
      @order = order
      @task_count = task_count
    end

    ##
    # Initializes a new Todoist::Project from a hash parsed from the JSON
    # response sent by todoist.com
    #
    # @params [Hash] hash The parsed JSON hash representing a project
    #
    # @returns [Project] The new project
    def self.new_from_hash(hash)
      raise(ArgumentError, "can't pass in a nil hash") if hash.nil?

      name = hash['name']
      id = hash['id']
      user_id = hash['user_id']
      order = hash['item_order']
      task_count = hash['cache_count']

      return Project.new(name, id, user_id, order, task_count)
    end

    def ==(obj)
      return false unless obj.is_a?(Project)
      unless @id.nil? or obj.id.nil?
        return @id == obj.id
      else
        return @name == obj.name
      end
    end

    ##
    #
    # Queries todoist.com via Todoist::Connection, returning an array of projects
    #
    # @returns [[Projects]] An array of projects
    def self.all
      projects = Connection.api_request('getProjects')
      return projects.map { |p| Project.new_from_hash(p) }
    end

    ##
    #
    # Queries todoist.com via Todoist::Connection, returning a single project of
    # the given id
    #
    # @params [Integer,String] id The id of the project to fetch
    #
    # @return [Project] the project of the given id.
    # @return [nil] if the project isn't found
    def self.get(id)
      begin
        project = Connection.api_request('getProject', 'id' => id)
        return Project.new_from_hash(project)
      rescue Todoist::BadResponse
        return nil
      end
    end

    ##
    #
    # Queries todoist.com via Todoist::Connection, returning a single project of
    # the given id
    #
    # @params [Integer,String] id The id of the project to fetch
    #
    # @return [Project] the project of the given id.
    # @raises [Exception, Todoist::BadResponse] if the API request raises
    def self.get!(id)
      project = Connection.api_request('getProject', 'id' => id)
      return Project.new_from_hash(project)
    end
  end
end
