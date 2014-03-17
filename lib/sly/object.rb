class Sly::Object
  def initialize(attributes={})
    self.attr_from_hash!(attributes)
  end

  def attr_from_hash!(attributes)
    attributes.each do |key, val|
      self.send(key.to_s+"=", val) if self.respond_to?(key.to_s+"=")
    end

    ["created_at", "last_login", "last_modified"].each do |attribute|
      parse_attr!(attribute) { |date| DateTime.iso8601(date) if date.kind_of?(String) }
    end

    ["assigned_to", "created_by"].each do |attribute|
      parse_attr!(attribute, {}) { |attributes| Sly::Person.new(attributes) }
    end

    parse_attr!("product", {}) { |attributes| Sly::Product.new(attributes) }
  end

  def to_hash(flatten=false)
    hash = {}
    self.instance_variables.each do |var|
      value = self.instance_variable_get(var)

      if value.kind_of?(Sly::Object)
        if flatten
          #store id if present, else ignore
          value.id ? value = value.id : break
        else
          value = value.to_hash
        end
      elsif value.kind_of?(DateTime)
        value = value.iso8601
      end

      hash[var[1..-1].to_sym] = value
    end
    hash
  end

  def to_json(flatten=false)
    self.to_hash(flatten).to_json
  end

  private

  def parse_attr!(attribute, nil_value=nil, &block)
    if self.respond_to?(attribute+"=")
      value = self.send(attribute)

      unless value.kind_of?(Sly::Object)
        value ||= nil_value
        parsed_value = block.call(value)
        self.send(attribute+"=", parsed_value) unless parsed_value.nil?
      end
    end
  end
end
