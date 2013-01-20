require 'spec_helper'

describe Sly::Config, integration: true do
  describe :update do
    it "sets attributes correctly" do
      config = Sly::Config.new(false)
      attributes = {email:"me@example.com", api_key:"123", product_id:"456"}
      config.update(attributes)
      config.email.should == attributes[:email]
      config.api_key.should == attributes[:api_key]
      config.product_id.should == attributes[:product_id]
    end
  end

  describe :save do
    it "creates a file if one does not exist" do
      raise "TODO"
    end

    it "writes correct json to the config file" do
      raise "TODO"
    end
  end

  describe :load do
    it "prints an error if a config file doesn't exist" do
      raise "TODO"
    end

    it "loads in config settings correctly" do
      raise "TODO"
    end
  end
end