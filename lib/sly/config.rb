class Sly::Config
  attr_accessor :email, :api_key, :product_id

  def initialize(autoload=true)
    @email = @api_key = @product_id = nil

    if(autoload)
      self.load
    end
  end

  def load
    #TODO: load from json config file
    load "sprintly_details.rb"
    self.update({email:ENV["sprintly_email"], api_key:ENV['sprintly_api_key'], product_id:ENV['sprintly_product_id']})
  end

  def save
    #TODO: save to json config file
  end

  def update(attributes)
    raise "Attributes must be in a Hash" unless attributes.kind_of? Hash
    attributes.each do |key, val|
      attribute = "@#{key.to_s}".to_sym
      if(self.instance_variables.include? attribute)
        self.instance_variable_set(attribute, val)
      end
    end
  end
end