class Sly::Product
  attr_accessor :id, :name, :created_at, :admin, :archived, :email

  def initialize(attributes={})
    raise "Attributes must be in a Hash" unless attributes.kind_of? Hash

    #defaults
    @id = @name = @created_at = @admin = @archived = @email = nil

    attributes.each do |key, val|
      attribute = "@#{key.to_s}".to_sym
      if(self.instance_variables.include? attribute)
        self.instance_variable_set(attribute, val)
      end
    end
  end

  def to_json
    vars = instance_variables.select { |var| instance_variable_get(var) }
    json = Hash[vars.map { |var| [var.to_s.sub(/^@/, ""), instance_variable_get(var)] } ].to_json
  end

  def alfred_result
    Sly::WorkflowUtils.item(@id, self.to_json, @name, @created_at)
  end
end