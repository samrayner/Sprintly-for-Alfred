QUERY = ARGV[0]
require_relative "../lib/sly"

begin
  sly = Sly::Interface.new
rescue Sly::ConfigFileMissingError => e
  puts Sly::WorkflowUtils.error_notification(e)
  exit
end

product = sly.product(QUERY.sub(/^\#/, ""))
sly.connector.config.product_id = product.id
sly.connector.config.save

puts "Switched active product to #{product.name}"