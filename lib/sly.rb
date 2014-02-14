module Sly
  VERSION = "1.1"
  BUNDLE_ID = "com.samrayner.Sprintly"

  CONFIG_FILE = File.expand_path("~/Library/Application Support/Alfred 2/Workflow Data/#{BUNDLE_ID}/config.json")
  CACHE_DIR = File.expand_path("~/Library/Caches/com.runningwithcrayons.Alfred-2/Workflow Data/"+BUNDLE_ID)

  API_DICTIONARY = { "in-progress" => "current" }

  class ConfigFileMissingError < StandardError; end
end

require_relative 'sly/object'
require_relative 'sly/workflow_utils'
require_relative 'sly/config'
require_relative 'sly/product'
require_relative 'sly/person'
require_relative 'sly/item'
require_relative 'sly/story_item'
require_relative 'sly/task_item'
require_relative 'sly/test_item'
require_relative 'sly/defect_item'
require_relative 'sly/connector'
require_relative 'sly/interface'
