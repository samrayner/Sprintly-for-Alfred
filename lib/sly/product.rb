require 'date'

class Sly::Product < Sly::Object
  attr_accessor :id, :name, :created_at, :admin, :archived, :email

  def initialize(attributes={})
    super(attributes)
    @archived = !@archived || @archived == 0 ? false : true
  end

  def alfred_result
    subtitle = self.created_at ? "Created #{self.created_at.strftime("%B %d, %Y")}" : ""
    Sly::WorkflowUtils.item("##{self.id}", self.name, subtitle)
  end
end
