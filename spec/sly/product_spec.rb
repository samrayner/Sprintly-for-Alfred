require 'spec_helper'
require 'JSON'

describe Sly::Product, integration: true do
  before :all do
    @product = Sly::Product.new({id:123,name:"Test Product",created_at:"now"})
  end

  describe :alfred_result do
    it "returns valid alfred search result for product" do
      alfred_result = @product.alfred_result
      alfred_result[:uid].should == @product.id
      alfred_result[:arg].should == @product.to_json
    end
  end

  describe :to_json do
    it "returns valid json with only set properties" do
      @product.to_json.should == '{"id":123,"name":"Test Product","created_at":"now"}'
    end

    it "returns a reversable JSON object" do
      Sly::Product.new(JSON(@product.to_json)).instance_variables.should == @product.instance_variables
    end
  end
end