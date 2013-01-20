describe Sly::Interface, integration: true do
  before :all do
    good_config = Sly::Config.new({email:ENV["sprintly_email"], api_key:ENV['sprintly_api_key'], product_id:ENV['sprintly_product_id']})

    bad_config = Sly::Config.new({email:"incorrect email", api_key:"incorrect api key", product_id:"incorrect product id"})

    @api = Sly::Interface.new(Sly::Connector.new(good_config))
    @bad_api = Sly::Interface.new(Sly::Connector.new(bad_config))
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