require 'spec_helper'
require 'JSON'

describe Sly::Object do
  describe '#to_json' do
    let(:person) { Sly::Person.new(id: 3, first_name: "Sam") }

    it "returns valid json" do
      json = person.to_json
      JSON.parse(json)
    end

    it "returns a reversable JSON object" do
      person_from_json = Sly::Person.new
      person_from_json.attr_from_hash!(JSON.parse(person.to_json))

      expect(obj_attr_match(person, person_from_json)).to be true
    end
  end
end
