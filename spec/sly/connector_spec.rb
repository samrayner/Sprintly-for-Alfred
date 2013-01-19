require 'spec_helper'

describe Sly::Connector, integration: true do

  before :all do
    config = Sly::Config.new(false)
    config.update({email:ENV["sprintly_email"], api_key:ENV['sprintly_api_key'], product_id:ENV['sprintly_product_id']})
    @con = Sly::Connector.new(config)

    bad_config = Sly::Config.new(false)
    bad_config.update({email:"incorrect_email", api_key:"incorrect_password", product_id:"incorrect_id"})
    @bad_con = Sly::Connector.new(bad_config)
  end

  describe :authorization do
    it "passes for a valid user" do
      @con.authorized? == true
    end

    it "fails for an invalid user" do
      @bad_con.authorized? == false
    end
  end

  describe :products do 
    it "returns 403 error with invalid credentials" do
      @bad_con.products.should == {"message" => "Invalid or unknown user.", "code" => 403}
    end

    it "returns the request response as an array" do
      @con.products.should be_a_kind_of(Array)
    end
  end

  describe :product do 
    it "returns 403 error with invalid credentials" do
      @bad_con.product(ENV["sprintly_product_id"]).should == {"message" => "Invalid or unknown user.", "code" => 403}
    end

    it "returns 402 error without access" do
      @con.product(1234).should == {"message" => "Account is not active.", "code" => 402}
    end

    it "returns the request response as a hash" do
      @con.product(ENV["sprintly_product_id"]).should be_a_kind_of(Hash)
    end
  end
end