class Sly::Item < Sly::Object
  attr_accessor :status, :product, :description, :tags, :last_modified
  attr_accessor :number, :archived, :title, :short_url, :created_at
  attr_accessor :created_by, :score, :assigned_to, :type, :progress

  def initialize(attributes={})
    super(attributes)

    @score = @score.upcase if(@score)
    @tags = [] if(!@tags)
  end

  def self.new_typed(attributes={})
    type = self.hash_value(attributes, :type)
    
    if(type)
      Sly::const_get("#{type.capitalize}Item").new(attributes)
    else
      self.new(attributes)
    end
  end

  def self.hash_value(hash, key)
    value = nil

    if(hash[key])
      value = hash[key]
    elsif(hash[key.to_s])
      value = hash[key.to_s]
    end

    value
  end

  def alfred_result
    subtitle = "Assigned to: #{@assigned_to.full_name}  "

    @tags.each { |tag| subtitle << " #"+tag }

    icon = "images/#{@type}-#{@score}.png".downcase
    Sly::WorkflowUtils.item(@number, "#"+@number.to_s, self.title, subtitle, icon)
  end
end