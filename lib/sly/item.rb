class Sly::Item < Sly::Object
  attr_accessor :status, :product, :description, :tags, :last_modified
  attr_accessor :number, :archived, :title, :short_url, :created_at
  attr_accessor :created_by, :score, :assigned_to, :type, :progress

  def initialize(attributes={})
    #defaults
    @title = @description = @status = @type = @score = @short_url = ""
    @last_modified = @created_at = ""
    @tags = []
    @progress = {}
    @number = 0
    @archived = false
    @created_by = @assigned_to = [] #changed to Person
    @product = [] #changed to Product

    self.attr_from_hash!(attributes)

    [:@created_by, :@assigned_to, :@product].each do |attribute|
      if(!self.instance_variable_get(attribute).kind_of? Hash)
        self.instance_variable_set(attribute, {})
      end
    end

    @created_by = Sly::Person.new(@created_by)
    @assigned_to = Sly::Person.new(@assigned_to)
    @product = Sly::Product.new(@product)
  end

  def alfred_result
    subtitle = "Assigned to: #{@assigned_to.full_name}"
    icon = "images/#{@type}-#{@score}.png".downcase
    Sly::WorkflowUtils.item(@number, @number, @title, subtitle, icon)
  end
end