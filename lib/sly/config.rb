require 'json'
require 'fileutils'

class Sly::Config < Sly::Object
  attr_accessor :email, :api_key, :product_id
  DEFAULT_CONFIG_FILE = File.expand_path("~/Library/Application Support/Alfred 2/Workflow Data/#{Sly::BUNDLE_ID}/config.json")

  def initialize(attributes={})
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
    rescue IOError
      raise Sly::ConfigFileMissingError, "Run SLY SETUP <EMAIL> <API_KEY>"
    end
  end

  def save(file_path="")
    if(file_path.empty?)
      file_path = DEFAULT_CONFIG_FILE
    end

    FileUtils.mkpath(File.dirname(file_path))

    File.open(file_path, 'w') do |f|  
      f.puts self.to_json
    end
  end

  def update!(attributes={})
    self.attr_from_hash!(attributes)
  end
end