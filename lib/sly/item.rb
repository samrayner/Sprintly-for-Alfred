class Sly::Item < Sly::Object
  attr_accessor :status, :product, :description, :tags, :last_modified
  attr_accessor :number, :archived, :title, :short_url, :created_at
  attr_accessor :created_by, :score, :assigned_to, :type, :progress

  def alfred_result
    subtitle = "Assigned to: #{@assigned_to.full_name}"
    icon = "images/#{@type}-#{@score}.png".downcase
    Sly::WorkflowUtils.item(@number, @number, @title, subtitle, icon)
  end
end