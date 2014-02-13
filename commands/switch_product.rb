QUERY = ARGV[0]
require_relative "../lib/sly"
sly = Sly::Interface.new_if_config

product = sly.product(QUERY.sub(/^\#/, ""))
sly.connector.config.product_id = product.id
sly.connector.config.save

puts "Switched active product to #{product.name}"
