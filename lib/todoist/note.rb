module Todoist
  ##
  # Todoist Task
  #
  # A todoist task.
  class Note
    attr_accessor :is_deleted, :is_archived, :content, :posted_uid, 
                  :item_id, :uids_to_notify, :id, :posted
    
    def initialize(hash)
      hash.each_pair do |key, value|
        self.send :"#{key}=", value
      end
    end

    def deleted?
      self.is_deleted == 0
    end

    def archived?
      self.is_archived == 0
    end

    def task
      Todoist::Task.get(self.item_id).first
    end

  end
end