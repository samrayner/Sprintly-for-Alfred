class Sly::Object
  def initialize(attributes={})
    self.attr_from_hash!(attributes)
  end

  def attr_from_hash!(attributes)
    raise "Attributes must be in a Hash" unless attributes.kind_of? Hash

    attributes.each do |key, val|
      if(self.respond_to?(key.to_s+"="))
        self.send(key.to_s+"=", val)
      end
    end

    self.objectify_attr(["created_at", "last_login", "last_modified"]) { |date| DateTime.iso8601(date) if date != nil }
    self.objectify_attr(["assigned_to", "created_by"], {}) { |attributes| Sly::Person.new(attributes) }
    self.objectify_attr("product", {}) { |attributes| Sly::Product.new(attributes) }
  end

  def to_json
    json = Hash[self.instance_variables.map { |var| [var.to_s.sub(/^@/, ""), instance_variable_get(var)] }].to_json
  end

  def objectify_attr(attributes, nil_value=nil, &block)
    if(!attributes.kind_of? Array)
      attributes = [attributes.to_s]
    end

    attributes.each do |attribute|
      if(self.respond_to?(attribute+"="))
        value = self.send(attribute)
        value = (value == nil) ? nil_value : value

        if(value != nil)
          self.send(attribute+"=", block.call(value))
        end
      end
    end
  end
end