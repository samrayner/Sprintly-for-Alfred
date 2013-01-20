require 'JSON'

class Sly::Config < Sly::Object
  attr_accessor :email, :api_key, :product_id
  DEFAULT_CONFIG_file = File.join(File.dirname(__FILE__), '../../config.json')

  def initialize(autoload=true)
    @email = @api_key = @product_id = nil

    if(autoload)
      self.load
    end
  end

  def load(file_path=nil)
    if(!file_path)
      file_path = DEFAULT_CONFIG_file
    end

    begin
      File.open(file_path, 'r') do |f|  
        self.update(JSON(f.read))
      end
    rescue
      puts "ERROR: Config file missing! Run SLY SETUP <EMAIL> <API_KEY>"
    end
  end

  def save(file_path=nil)
    if(!file_path)
      file_path = DEFAULT_CONFIG_file
    end

    File.open(file_path, 'w') do |f|  
      f.puts self.to_json
    end
  end

  def update(attributes={})
    self.attr_from_hash!(attributes)
  end
end