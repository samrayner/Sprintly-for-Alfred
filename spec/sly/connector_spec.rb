require 'spec_helper'
require_relative '../../lib/sly'

describe Sly::Connector, integration: true do
  describe :authorization do
    it "succeeds for a valid user" do
      sly = Sly::Connector.new({email: ENV["sprintly_email"], api_key: ENV['sprintly_api_key']})
      sly.authorized? == true
    end

    it "fails for an invalid user" do
      sly = Sly::Connector.new({email: "incorrect_user_email", api_key: "incorrect_key"})
      sly.authorized? == false
    end
  end

  describe :connector do 
    it "returns the request response as a hash" do
      sly = Sly::Connector.new({email: "incorrect_user_email", api_key: "incorrect_key"})
      sly.products.should == {"message" => "Invalid or unknown user.", "code" => 403}
    end
  end
end