require 'date'

class Sly::Product < Sly::Object
  attr_accessor :id, :name, :created_at, :admin, :archived, :email

  def alfred_result
    subtitle = "Created "+DateTime.iso8601(@created_at).strftime("%B %d, %Y")
    Sly::WorkflowUtils.item(@id, @id, @name, subtitle)
  end
end