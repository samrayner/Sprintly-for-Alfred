require 'spec_helper'

describe Sly::WorkflowUtils, integration: true do
  describe :array_to_xml do
    it "returns valid xml for an array of hashes" do
      items = [{uid:"012",arg:"345",name:"test"},{uid:"678",arg:"910",foo:"bar"}]
      xml = "<items><item arg='345' uid='012'><name>test</name></item><item arg='910' uid='678'><foo>bar</foo></item></items>"
      Sly::WorkflowUtils.array_to_xml(items).should == xml
    end
  end
end