module Sly
  BUNDLE_ID = "com.samrayner.Sprintly"
  VERSION = "0.0.1"
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