require 'spec_helper'

describe Sly::Product, integration: true do
  before :all do
    @product = Sly::Product.new({id:123,name:"Test Product",created_at:"2012-06-26T20:45:20+00:00"})
  end

  describe :alfred_result do
    it "returns valid alfred search result for product" do
      alfred_result = @product.alfred_result
      alfred_result[:arg].should == "#"+@product.id.to_s
      alfred_result[:title].should == @product.name
    end
  end
end
