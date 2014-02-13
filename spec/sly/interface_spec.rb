require 'fileutils'

describe Sly::Interface do
  let(:api) { Sly::Interface.new(valid_connector) }
  let(:bad_api) { Sly::Interface.new(invalid_connector) }

  describe '#cache' do
    it "creates a cache directory if one does not exist" do
      FileUtils.rm_rf(Sly::CACHE_DIR) if FileTest::directory?(Sly::CACHE_DIR)
      FileTest::directory?(Sly::CACHE_DIR).should be_false

      api.cache("products.json") { api.connector.products }

      FileTest::directory?(Sly::CACHE_DIR).should be_true
    end

    it "creates a cache file if one does not exist" do
      cache_file = "#{Sly::CACHE_DIR}/products.json"
      File.delete(cache_file) if File.exists?(cache_file)

      api.cache("products.json") { api.connector.products }

      File.exists?(cache_file).should be_true
    end
  end

  describe '#products' do
    it "returns a list of products" do
      api.products.should be_a_kind_of(Array)
      api.products.first.should be_a_kind_of(Sly::Product)
    end

    it "returns an empty list with a bad config" do
      bad_api.products.should == []
    end
  end

  describe '#product' do
    it "returns a product" do
      api.product(ENV['sprintly_product_id']).should be_a_kind_of(Sly::Product)
    end

    it "returns nothing with a bad config" do
      bad_api.product(ENV['sprintly_product_id']).should be_nil
    end
  end
end
