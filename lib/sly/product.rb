require 'date'

class Sly::Product < Sly::Object
  attr_accessor :id, :name, :created_at, :admin, :archived, :email

  def initialize(attributes={})
    #defaults
    @id = 0
    @name = @created_at = @admin = @archived = @email = ""

    self.attr_from_hash!(attributes)
  end

  def alfred_result
    subtitle = "Created "+DateTime.iso8601(@created_at).strftime("%B %d, %Y")
    Sly::WorkflowUtils.item(@id, @id, @name, subtitle)
  end
end