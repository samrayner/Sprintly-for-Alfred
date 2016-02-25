require 'spec_helper'

describe Sly::Config do
  let(:config) { FactoryGirl.build(:config) }
  let(:test_config_file) { "test_config.json" }

  def delete_test_config
    File.delete(test_config_file) if File.exists?(test_config_file)
  end

  describe '#initialize' do
    context "no attributes passed" do
      after { Sly::Config.new }

      it "loads from the config file" do
        expect(File).to receive(:open).with(Sly::CONFIG_FILE, 'r')
      end
    end

    context "attributes passed" do
      after { Sly::Config.new(email: "test@example.com") }

      it "does not load from config file" do
        expect(File).not_to receive(:open)
      end
    end
  end

  describe '#update' do
    let(:attributes) do
      { email: "you@example.com", api_key: "abc", product_id: "xyz" }
    end

    it "sets attributes correctly" do
      config.update!(attributes)
      expect(config.email).to eq(attributes[:email])
      expect(config.api_key).to eq(attributes[:api_key])
      expect(config.product_id).to eq(attributes[:product_id])
    end
  end

  describe '#save' do
    before { delete_test_config }
    after  { delete_test_config }

    it "creates a file if one does not exist" do
      config.save(test_config_file)
      expect(File.exists?(test_config_file)).to be true
    end
  end

  describe '#load' do
    it "loads in saved settings correctly" do
      config.save(test_config_file)
      blank_config = Sly::Config.new(email: nil, api_key: nil, product_id: nil)
      blank_config.load!(test_config_file)
      expect(obj_attr_match(config, blank_config)).to be true
    end

    it "raises an error if a config file doesn't exist" do
      delete_test_config
      expect { config.load!(test_config_file) }.to raise_error(Sly::ConfigFileMissingError)
    end
  end
end
