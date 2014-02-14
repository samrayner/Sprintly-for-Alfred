require 'spec_helper'

describe Sly::Connector do
  let(:config) { FactoryGirl.build(:config, product_id: "123") }
  let(:connector) { Sly::Connector.new(config) }
  let(:api_url) { "https://sprint.ly/api" }
  let(:id) { 99 }
  let(:url) { "http://example.com" }

  describe '#authenticated_request' do
    let(:params) do
      { this: :that }
    end

    it "sets the limit param" do
      connector.authenticated_request(url, params)
      params[:limit].should == 100
    end
  end

  describe '#authorized?' do
    it "passes for a valid user" do
      valid_connector.authorized?.should be_true
    end

    it "fails for an invalid user" do
      invalid_connector.authorized?.should be_false
    end
  end

  describe '#people' do
    after do
      connector.people
    end

    it "makes an authenticated API request" do
      connector.should_receive(:authenticated_request).with(api_url+"/products/#{config.product_id}/people.json")
    end
  end

  describe '#products' do
    after do
      connector.products
    end

    it "makes an authenticated API request" do
      connector.should_receive(:authenticated_request).with(api_url+"/products.json")
    end
  end

  describe '#product' do
    after do
      connector.product(id)
    end

    it "makes an authenticated API request" do
      connector.should_receive(:authenticated_request).with(api_url+"/products/#{id}.json")
    end
  end

  describe '#person' do
    after do
      connector.person(id)
    end

    it "makes an authenticated API request" do
      connector.should_receive(:authenticated_request).with(api_url+"/products/#{config.product_id}/people/#{id}.json")
    end
  end

  describe '#items' do
    let(:filters) do
      { this: :that }
    end

    it "sets children parameter" do
      connector.items(filters)
      filters[:children].should be_true
    end

    it "makes an authenticated API request" do
      connector.should_receive(:authenticated_request).with(api_url+"/products/#{config.product_id}/items.json", filters)
      connector.items(filters)
    end
  end

  describe '#item' do
    after do
      connector.item(id)
    end

    it "makes an authenticated API request" do
      connector.should_receive(:authenticated_request).with(api_url+"/products/#{config.product_id}/items/#{id}.json")
    end
  end

  describe '#add_item' do
    let(:attributes) do
      { this: :that }
    end

    after do
      connector.add_item(attributes)
    end

    it "makes an authenticated API request" do
      connector.should_receive(:authenticated_request).with(api_url+"/products/#{config.product_id}/items.json", attributes, true)
    end
  end

  describe '#update_item' do
    let(:attributes) do
      { this: :that }
    end

    after do
      connector.update_item(id, attributes)
    end

    it "makes an authenticated API request" do
      connector.should_receive(:authenticated_request).with(api_url+"/products/#{config.product_id}/items/#{id}.json", attributes, true)
    end
  end

  describe '#append_query_string' do
    it "concats a hash into an encoded string and appends to the URL" do
      url = "http://example.com"
      params = { a: "b", "c" => :d }
      connector.send(:append_query_string, url, params).should == "http://example.com?a=b&c=d"
    end
  end
end
