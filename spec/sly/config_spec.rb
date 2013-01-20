require 'spec_helper'

describe Sly::Config, integration: true do
  before :all do
    @config = Sly::Config.new({email:"me@example.com", api_key:"123", product_id:"456"})
    TEST_CONFIG_FILE = "test_config.json"
  end

  describe :update do
    it "sets attributes correctly" do
      attributes = {email:"me@example.com", api_key:"123", product_id:"456"}
      config = Sly::Config.new(attributes)
      config.email.should == attributes[:email]
      config.api_key.should == attributes[:api_key]
      config.product_id.should == attributes[:product_id]
    end
  end

  describe :save do
    it "creates a file if one does not exist" do
      if(File.exists?(TEST_CONFIG_FILE))
        File.delete(TEST_CONFIG_FILE)
      end

      @config.save(TEST_CONFIG_FILE)

      File.exists?(TEST_CONFIG_FILE).should be_true
    end
  end

  describe :load do
    it "loads in saved settings correctly" do
      config = Sly::Config.new({email:nil,api_key:nil,product_id:nil})
      config.load!(TEST_CONFIG_FILE)
      obj_attr_match(@config, config).should be_true
    end

    it "prints an error if a config file doesn't exist" do
      if(File.exists?(TEST_CONFIG_FILE))
        File.delete(TEST_CONFIG_FILE)
      end

      output = capture_stdout { @config.load!(TEST_CONFIG_FILE) }
      output.should include("ERROR")
    end
  end
end