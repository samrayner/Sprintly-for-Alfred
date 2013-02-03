require 'spec_helper'
require 'JSON'

describe Sly::Object, integration: true do
  describe :to_json do
    it "returns valid json" do
      json = Sly::Person.new({id:3, first_name:"Sam"}).to_json
      JSON.parse(json)
    end

    it "returns a reversable JSON object" do
      obj = Sly::Person.new({id:3, first_name:"Sam"})

      obj_from_json = Sly::Person.new
      obj_from_json.attr_from_hash!(JSON(obj.to_json))

      obj_attr_match(obj, obj_from_json).should be_true
    end
  end
end