class Sly::Item < Sly::Object
  attr_accessor :status, :product, :description, :tags
  attr_accessor :number, :archived, :title
  attr_accessor :created_by, :score, :assigned_to, :type

  def initialize(attributes={})
    #defaults
    @title = @description = @status = @type = @score = ""
    @tags = []
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
    Sly::WorkflowUtils.item(@number, @number, @title, subtitle)
  end
end