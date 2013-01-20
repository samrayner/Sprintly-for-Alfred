QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"

credentials = QUERY.split(" ")

if(credentials.count != 2)
  puts "ERROR: Please use format SLY SETUP <EMAIL> <API_KEY>"
  exit
end

config = Sly::Config.new({email:credentials[0], api_key:credentials[1], product_id:0000})
connector = Sly::Connector.new(config)

if(!connector.authorized?)
  puts "ERROR: Authentication failed for #{config.email}."
  exit
end

sly = Sly::Interface.new(connector)
product = sly.products.first
sly.connector.config.product_id = product.id
sly.connector.config.save

puts "Setup complete!\nActive product is #{product.name}."