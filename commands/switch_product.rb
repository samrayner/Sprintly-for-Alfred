QUERY = ARGV[0]
require_relative "../lib/sly"

sly = Sly::Interface.new
product = sly.product(QUERY)
sly.connector.config.product_id = product.id
sly.connector.config.save

puts "Switched active product to #{product.name}"