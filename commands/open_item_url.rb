QUERY = ARGV[0].to_s.downcase.strip
require_relative "../lib/sly"

sly = Sly::Interface.new
product_id = sly.connector.config.product_id
url = "https://sprint.ly/product/#{product_id}/#!/item/#{QUERY.sub(/^\#/, "")}"
`open #{url}`