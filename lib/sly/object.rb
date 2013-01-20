class Sly::Object
  def attr_from_hash!(attributes)
    raise "Attributes must be in a Hash" unless attributes.kind_of? Hash

    attributes.each do |key, val|
      attribute = "@#{key.to_s}".to_sym
      if(self.instance_variables.include? attribute)
        self.instance_variable_set(attribute, val)
      end
    end
  end

  def to_json
    json = Hash[self.instance_variables.map { |var| [var.to_s.sub(/^@/, ""), instance_variable_get(var)] }].to_json
  end
end