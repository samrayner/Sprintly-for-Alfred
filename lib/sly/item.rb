class Sly::Item < Sly::Object
  attr_accessor :status, :product, :description, :tags, :last_modified
  attr_accessor :number, :archived, :title, :short_url, :created_at
  attr_accessor :created_by, :score, :assigned_to, :type, :progress

  def initialize(attributes={})
    super(attributes)

    @tags = [] if(!@tags)
  end

  def self.new_typed(attributes={})
    type_key = :type

    type = false

    if(attributes[type_key])
      type = attributes[type_key]
    elsif(attributes[type_key.to_s])
      type = attributes[type_key.to_s]
    end
    
    if(type)
      Sly::const_get("#{type.capitalize}Item").new(attributes)
    else
      self.new(attributes)
    end
  end

  def alfred_result
    subtitle = "Assigned to: #{@assigned_to.full_name}  "

    @tags.each { |tag| subtitle << " #"+tag }

    icon = "images/#{@type}-#{@score}.png".downcase
    Sly::WorkflowUtils.item(@number, "#"+@number.to_s, @title, subtitle, icon)
  end
end