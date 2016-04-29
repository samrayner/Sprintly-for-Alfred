require 'spec_helper'
require 'fileutils'

describe Sly::Interface do
  let!(:api) { Sly::Interface.new }

  describe '.api_term' do
    before do
      stub_const("Sly::API_DICTIONARY", { "foo" => "bar" })
    end

    context "value exists in dictionary" do
      it "returns the key" do
        expect(Sly::Interface.api_term("bar")).to eq("foo")
      end
    end

    context "value not in dictionary" do
      it "returns the search value" do
        expect(Sly::Interface.api_term("baz")).to eq("baz")
      end
    end
  end

  describe '.common_term' do
    before do
      stub_const("Sly::API_DICTIONARY", { "foo" => "bar" })
    end

    context "key exists in dictionary" do
      it "returns the key" do
        expect(Sly::Interface.common_term("foo")).to eq("bar")
      end
    end

    context "key not in dictionary" do
      it "returns the search value" do
        expect(Sly::Interface.common_term("baz")).to eq("baz")
      end
    end
  end

  describe '.new_if_config' do
    context "config file exists" do
      before { allow(Sly::Interface).to receive(:new) }

      it "returns a new interface" do
        expect(Sly::Interface.new_if_config).to eq(Sly::Interface.new)
      end
    end

    context "no config file" do
      before do
        allow(Sly::Interface).to receive(:new).and_raise(Sly::ConfigFileMissingError)
      end

      it "outputs the error" do
        expect(capture_stdout do
          begin
            Sly::Interface.new_if_config
          rescue SystemExit
          end
        end).to include("ERROR: Config File Missing")
      end

      it "exits" do
        expect { Sly::Interface.new_if_config }.to raise_error(SystemExit)
      end
    end
  end

  describe '#cache' do
    let!(:products) { fixture("products.json") }

    it "creates a cache directory if one does not exist" do
      FileUtils.rm_rf(Sly::CACHE_DIR) if FileTest::directory?(Sly::CACHE_DIR)
      expect(FileTest::directory?(Sly::CACHE_DIR)).to be false

      api.cache("products.json") { products }

      expect(FileTest::directory?(Sly::CACHE_DIR)).to be true
    end

    it "creates a cache file if one does not exist" do
      cache_file = "#{Sly::CACHE_DIR}/products.json"
      File.delete(cache_file) if File.exists?(cache_file)

      api.cache("products.json") { products }

      expect(File.exists?(cache_file)).to be true
    end
  end

  describe '#add_item' do
    let(:attributes) { { id: 1, title: "My Item" } }
    let(:item) { double(:item, to_flat_hash: attributes) }

    it "calls the api with the item attributes" do
      expect(api.connector).to receive(:add_item).with(attributes)
      api.add_item(item)
    end
  end

  describe '#update_item' do
    let(:id) { 1 }
    let(:item) do
      {
        type: "task",
        number: id,
        score: "S",
        tags: "tag1,tag2"
      }
    end

    before do
      allow(api.connector).to receive(:item).with(id).and_return(item)
    end

    it "only updates valid attributes" do
      expect(api.connector).to receive(:update_item).with(id, {
        number: id,
        score: "M",
        tags: "tag1,tag2"
      })
      api.update_item(id, {
        score: "M",
        not_item_attribute: true,
      })
    end

    it "does not try to update the type or product" do
      expect(api.connector).to receive(:update_item).with(id, {
        number: id,
        score: "S",
        tags: "tag1,tag2"
      })
      api.update_item(id, {
        type: "story",
        product: Sly::Product.new
      })
    end

    it "flattens tag updates" do
      expect(api.connector).to receive(:update_item).with(id, {
        number: id,
        score: "S",
        tags: "tagA,tagB"
      })
      api.update_item(id, {
        tags: ["tagA", "tagB"]
      })
    end
  end

  describe '#people' do
    context "api success" do
      before { allow(api).to receive_messages(cache: json_fixture("people")) }

      it "returns a list of people" do
        expect(api.people.first).to be_a_kind_of(Sly::Person)
      end

      it "sorts by name" do
        expect(api.people.map(&:last_name)).to eq(["Rayner", "White", "Wroblewski"])
      end

      context "filtering by assigned user" do
        it "returns people with names that contain the query" do
          expect(api.people("ray").map(&:last_name)).to eq(["Rayner"])
        end

        it "filters by 'me'" do
          api.connector.config.email = "test1@example.com"
          expect(api.people("me").map(&:last_name)).to eq(["Wroblewski"])
        end
      end
    end

    context "api error" do
      before do
        allow(api).to receive(:cache)
        allow(api).to receive_messages(error_object?: true)
      end

      it "returns an empty list" do
        expect(api.people).to eq([])
      end
    end
  end

  describe '#products' do
    context "api success" do
      before { allow(api).to receive_messages(cache: json_fixture("products")) }

      it "returns a list of products" do
        expect(api.products.first).to be_a_kind_of(Sly::Product)
      end

      it "returns products with names that start with the query" do
        expect(api.products("alice").map(&:name)).to eq(["Alice Product"])
      end
    end

    context "api error" do
      before do
        allow(api).to receive(:cache)
        allow(api).to receive_messages(error_object?: true)
      end

      it "returns an empty list" do
        expect(api.products).to eq([])
      end
    end
  end

  describe '#items' do
    context "api success" do
      before { allow(api).to receive_messages(cache: json_fixture("items")) }

      it "returns a list of items" do
        expect(api.items.first).to be_a_kind_of(Sly::Item)
      end

      it "rejects orphaned items" do
        expect(api.items.map(&:number)).not_to include(666)
      end

      context "filtering by assigned user" do
        it "returns items whose assignee name contains the query" do
          expect(api.items({}, "@dom").map(&:number)).to eq([111,444])
        end

        it "returns items whose assignee is 'me'" do
          api.connector.config.email = "test1@example.com"
          expect(api.items({}, "@me").map(&:number)).to eq([111,444])
        end
      end

      it "filters by title" do
        expect(api.items({}, "item 1").map(&:number)).to eq([111])
      end
    end

    context "api error" do
      before do
        allow(api).to receive(:cache)
        allow(api).to receive_messages(error_object?: true)
      end

      it "returns an empty list" do
        expect(api.products).to eq([])
      end
    end
  end

  describe '#product' do
    let(:id) { 1111 }
    let(:product) { Hash.new }

    before do
      allow(api.connector).to receive(:product).with(id).and_return(product)
    end

    it "converts response to a typed object" do
      expect(Sly::Product).to receive(:new).with(product)
      api.product(id)
    end

    it "returns the typed object" do
      expect(api.product(id)).to be_a_kind_of(Sly::Product)
    end

    context "api error" do
      before { allow(api).to receive_messages(error_object?: true) }

      it "returns nil" do
        expect(api.product(id)).to eq(nil)
      end
    end
  end

  describe '#person' do
    let(:id) { 1111 }
    let(:person) { Hash.new }

    before do
      allow(api.connector).to receive(:person).with(id).and_return(person)
    end

    it "converts response to a typed object" do
      expect(Sly::Person).to receive(:new).with(person)
      api.person(id)
    end

    it "returns the typed object" do
      expect(api.person(id)).to be_a_kind_of(Sly::Person)
    end

    context "api error" do
      before { allow(api).to receive_messages(error_object?: true) }

      it "returns nil" do
        expect(api.person(id)).to eq(nil)
      end
    end
  end

  describe '#item' do
    let(:id) { 1111 }
    let(:item) { Hash.new }

    before do
      allow(api.connector).to receive(:item).with(id).and_return(item)
    end

    it "converts response to a typed object" do
      expect(Sly::Item).to receive(:new_typed).with(item)
      api.item(id)
    end

    it "returns the typed object" do
      expect(api.item(id)).to be_a_kind_of(Sly::Item)
    end

    context "api error" do
      before { allow(api).to receive_messages(error_object?: true) }

      it "returns nil" do
        expect(api.item(id)).to eq(nil)
      end
    end
  end

  describe '#error_object?' do
    it "returns false for a list response" do
      expect(api.send(:error_object?, json_fixture("products"))).to be false
    end

    it "returns false for a single response" do
      expect(api.send(:error_object?, json_fixture("item"))).to be false
    end

    it "returns true for an error response" do
      expect(api.send(:error_object?, json_fixture("403"))).to be true
    end
  end
end
