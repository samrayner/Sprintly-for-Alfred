require_relative '../lib/sly'

FactoryGirl.define do
  factory :config, class: Sly::Config do
    email       "me@example.com"
    api_key     "123"
    product_id  "456"
  end
end
