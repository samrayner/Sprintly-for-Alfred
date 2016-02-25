require 'factory_girl'
FactoryGirl.find_definitions

require 'simplecov'
SimpleCov.start

load "sprintly_details.rb"
require_relative '../lib/sly'

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

def obj_attr_match(obj1, obj2)
  obj1.instance_variables.each do |var|
    return false unless obj2.instance_variable_get(var) == obj1.instance_variable_get(var)
  end

  true
end

def fixture(filename)
  IO.read(File.expand_path("../fixtures/#{filename}", __FILE__))
end

def json_fixture(name)
  JSON.parse(fixture("#{name}.json"))
end

def valid_config
  Sly::Config.new(email: ENV["sprintly_email"], api_key: ENV['sprintly_api_key'], product_id: ENV['sprintly_product_id'])
end

def invalid_config
  Sly::Config.new(email: "incorrect_email", api_key: "incorrect_password", product_id: "incorrect_id")
end

def valid_connector
  Sly::Connector.new(valid_config)
end

def invalid_connector
  Sly::Connector.new(invalid_config)
end
