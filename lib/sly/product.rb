class Sly::Product < Sly::Object
  attr_accessor :id, :name, :created_at, :admin, :archived, :email

  def initialize(attributes={})
    #defaults
    @id = @name = @created_at = @admin = @archived = @email = nil
    self.attr_from_hash!(attributes)
  end

  def alfred_result
    Sly::WorkflowUtils.item(@id, @id, @name, @created_at)
  end
end