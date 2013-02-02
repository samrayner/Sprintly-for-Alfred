require 'json'
require 'fileutils'

class Sly::Config < Sly::Object
  attr_accessor :email, :api_key, :product_id
  DEFAULT_CONFIG_FILE = File.expand_path("~/Library/Application Support/Alfred 2/Workflow Data/#{Sly::BUNDLE_ID}/config.json")

  def initialize(attributes={})
    attributes.empty? ? self.load! : self.update!(attributes)
  end

  def load!(file_path="")
    file_path = DEFAULT_CONFIG_FILE if file_path.empty?

    begin
      File.open(file_path, 'r') { |f| self.update!(JSON(f.read)) }
    rescue IOError
      raise Sly::ConfigFileMissingError, "Run SLY SETUP <EMAIL> <API_KEY>"
    end
  end

  def save(file_path="")
    file_path = DEFAULT_CONFIG_FILE if file_path.empty?

    FileUtils.mkpath(File.dirname(file_path))
    
    File.open(file_path, 'w') { |f| f.puts self.to_json }
  end

  def update!(attributes={})
    self.attr_from_hash!(attributes)
  end
end