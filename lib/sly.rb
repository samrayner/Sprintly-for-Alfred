module Sly
  VERSION = "1.0"
  BUNDLE_ID = "com.samrayner.Sprintly"
  
  CONFIG_FILE = File.expand_path("~/Library/Application Support/Alfred 2/Workflow Data/#{BUNDLE_ID}/config.json")
  CACHE_DIR = File.expand_path("~/Library/Caches/com.runningwithcrayons.Alfred-2/Workflow Data/"+BUNDLE_ID)

  API_DICTIONARY = { "in-progress" => "current" }

  class ConfigFileMissingError < StandardError; end
end

require_relative 'sly/object.rb'
require_relative 'sly/workflow_utils.rb'
require_relative 'sly/config.rb'
require_relative 'sly/product.rb'
require_relative 'sly/product.rb'
require_relative 'sly/person.rb'
require_relative 'sly/item.rb'
require_relative 'sly/story_item.rb'
require_relative 'sly/task_item.rb'
require_relative 'sly/test_item.rb'
require_relative 'sly/defect_item.rb'
require_relative 'sly/connector.rb'
require_relative 'sly/interface.rb'