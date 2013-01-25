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

    ["created_at", "last_login", "last_modified"].map do |attribute|
      if(self.send(attribute).kind_of? String)
        self.parse_attr(attribute) { |date| DateTime.iso8601(date) }
      end
    end

    ["assigned_to", "created_by"].map do |attribute|
      if(self.send(attribute).kind_of? Hash)
        self.parse_attr(attribute) { |attributes| Sly::Person.new(attributes) }
      end
    end

    ["product"].map do |attribute|
      if(self.send(attribute).kind_of? Hash)
        self.parse_attr(attribute) { |attributes| Sly::Product.new(attributes) }
      end
    end
  end

  def to_json
    json = Hash[self.instance_variables.map { |var| [var.to_s.sub(/^@/, ""), instance_variable_get(var)] }].to_json
  end

  def parse_attr(attribute, &block)
    if(self.respond_to?(attribute+"="))
      self.send(attribute+"=", block.call(self.send(attribute)))
    end
  end
end