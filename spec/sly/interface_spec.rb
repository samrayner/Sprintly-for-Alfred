describe Sly::Interface, integration: true do
  before :all do
    config = Sly::Config.new(false)
    config.update({email:ENV["sprintly_email"], api_key:ENV['sprintly_api_key'], product_id:ENV['sprintly_product_id']})
    @api = Sly::Interface.new(Sly::Connector.new(config))
  end

  describe :products do
    it "returns a list of products" do
      @api.products.should be_a_kind_of(Array)
      @api.products.first.should be_a_kind_of(Sly::Product)
    end
  end

  describe :product do
    it "returns a product" do
      @api.products.first.should be_a_kind_of(Sly::Product)
    end
  end
end