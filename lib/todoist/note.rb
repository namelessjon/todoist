module Todoist
  ##
  # Todoist Task
  #
  # A todoist task.
  class Note

    ATTRIBUTES = [:is_deleted, :is_archived, :content, :posted_uid, 
                  :item_id, :uids_to_notify, :id, :posted, :task]

    attr_accessor *ATTRIBUTES

    def initialize(hash = {})
      ATTRIBUTES.each do |attribute|
        self.public_send("#{attribute}=", hash.fetch(attribute.to_s))
      end
    end

    def deleted?
      self.is_deleted == 0
    end

    def archived?
      self.is_archived == 0
    end

  end
end
