require 'JSON'

class Sly::Config < Sly::Object
  attr_accessor :email, :api_key, :product_id
  CONFIG_FILE = File.join(File.dirname(__FILE__), '../../config.json')

  def initialize(autoload=true)
    @email = @api_key = @product_id = nil

    if(autoload)
      self.load
    end
  end

  def load
    begin
      File.open(CONFIG_FILE, 'r') do |f|  
        self.update(JSON(f.read))
      end
    rescue
      puts "ERROR: Config file missing! Run SLY SETUP <EMAIL> <API_KEY>"
    end
  end

  def save
    File.open(CONFIG_FILE, 'w') do |f|  
      f.puts self.to_json
    end
  end

  def update(attributes={})
    self.attr_from_hash!(attributes)
  end
end