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
        self.parse_attr(attribute) { |date| (date.kind_of?(String)) ? DateTime.iso8601(date) : DateTime.new }
    end

    ["assigned_to", "created_by"].map do |attribute|
        self.parse_attr(attribute, {}) { |attributes| Sly::Person.new(attributes) }
    end

    ["product"].map do |attribute|
        self.parse_attr(attribute, {}) { |attributes| Sly::Product.new(attributes) }
    end
  end

  def to_json
    json = Hash[self.instance_variables.map { |var| [var.to_s.sub(/^@/, ""), instance_variable_get(var)] }].to_json
  end

  def parse_attr(attribute, nil_value=nil, &block)
    if(self.respond_to?(attribute+"="))
      value = self.send(attribute)

      value = nil_value if value == nil

      self.send(attribute+"=", block.call(value))
    end
  end
end