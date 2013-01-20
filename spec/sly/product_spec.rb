require 'spec_helper'

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
end