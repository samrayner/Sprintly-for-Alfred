require 'fileutils'

describe Sly::Interface, integration: true do
  before :all do
    good_config = Sly::Config.new({email:ENV["sprintly_email"], api_key:ENV['sprintly_api_key'], product_id:ENV['sprintly_product_id']})

    bad_config = Sly::Config.new({email:"incorrect email", api_key:"incorrect api key", product_id:"incorrect product id"})

    @api = Sly::Interface.new(Sly::Connector.new(good_config))
    @bad_api = Sly::Interface.new(Sly::Connector.new(bad_config))

    CACHE_DIR = File.join(File.dirname(__FILE__), '../../cache')
  end

  describe :cache do 
    it "creates a cache directory if one does not exist" do
      if(FileTest::directory?(CACHE_DIR))
        FileUtils.rm_rf(CACHE_DIR)
      end

      FileTest::directory?(CACHE_DIR).should be_false

      @api.cache("products")

      FileTest::directory?(CACHE_DIR).should be_true
    end

    it "creates a cache file if one does not exist" do
      cache_file = "#{CACHE_DIR}/products.json"

      if(File.exists?(cache_file))
        File.delete(cache_file)
      end

      File.exists?(cache_file).should be_false

      @api.cache("products")

      File.exists?(cache_file).should be_true
    end
  end

  describe :products do
    it "returns a list of products" do
      @api.products.should be_a_kind_of(Array)
      @api.products.first.should be_a_kind_of(Sly::Product)
    end

    it "returns an empty list with a bad config" do
      @bad_api.products.should be_a_kind_of(Array)
      @bad_api.products.should be_empty
    end

    it "filters products by name" do
      filter = "e"
      filtered = @api.products(filter)
      filtered.should be_a_kind_of(Array)

      filtered.each do |product|
        product.name.downcase.should include(filter)
      end

      @api.products("xxxxxx").should be_a_kind_of(Array)
      @api.products("xxxxxx").should be_empty
    end
  end

  describe :product do
    it "returns a product" do
      @api.product(ENV['sprintly_product_id']).should be_a_kind_of(Sly::Product)
    end

    it "returns nothing with a bad config" do
      @bad_api.product(ENV['sprintly_product_id']).should be_false
    end
  end
end