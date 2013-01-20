require 'JSON'

class Sly::Config < Sly::Object
  attr_accessor :email, :api_key, :product_id
  DEFAULT_CONFIG_FILE = File.join(File.dirname(__FILE__), '../../config.json')

  def initialize(attributes={})
    @email = @api_key = @product_id = nil

    if(attributes.empty?)
      self.load!
    else
      self.update!(attributes)
    end
  end

  def load!(file_path="")
    if(file_path.empty?)
      file_path = DEFAULT_CONFIG_FILE
    end

    begin
      File.open(file_path, 'r') do |f|  
        self.update!(JSON(f.read))
      end
    rescue
      puts "ERROR: Config file missing! Run SLY SETUP <EMAIL> <API_KEY>"
    end
  end

  def save(file_path="")
    if(file_path.empty?)
      file_path = DEFAULT_CONFIG_FILE
    end

    File.open(file_path, 'w') do |f|  
      f.puts self.to_json
    end
  end

  def update!(attributes={})
    self.attr_from_hash!(attributes)
  end
end