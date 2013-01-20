require 'spec_helper'
require 'JSON'

describe Sly::Object, integration: true do
  before :all do
      @obj = Sly::Object.new()
      @obj.instance_variable_set(:@foo, 10)
      @obj.instance_variable_set(:@bar, false)
      @obj.instance_variable_set(:@baz, "abc")
  end

  describe :attr_from_hash! do
    it "overwrites object attributes that exist" do
      obj = @obj.dup

      obj.attr_from_hash!({foo:5,bar:true,zzz:99})

      obj.instance_variable_get(:@foo).should == 5
      obj.instance_variable_get(:@bar).should == true
      obj.instance_variable_get(:@baz).should == "abc" #unchanged
      obj.instance_variable_get(:@zzz).should == nil #shouldn't exist as not in original object
    end
  end

  describe :to_json do
    it "returns valid json" do
      @obj.to_json.should == '{"foo":10,"bar":false,"baz":"abc"}'
    end

    it "returns a reversable JSON object" do
      obj_from_json = Sly::Object.new()
      obj_from_json.instance_variable_set(:@foo, nil)
      obj_from_json.instance_variable_set(:@bar, nil)
      obj_from_json.instance_variable_set(:@baz, nil)

      obj_from_json.attr_from_hash!(JSON(@obj.to_json))

      obj_attr_match(@obj, obj_from_json).should be_true
    end
  end
end