QUERY = ARGV[0].to_s.downcase.strip
require_relative "../lib/sly"

begin
  sly = Sly::Interface.new
rescue Sly::ConfigFileMissingError => e
  puts Sly::WorkflowUtils.error_notification(e)
  exit
end

product_id = sly.connector.config.product_id
url = "https://sprint.ly/product/#{product_id}/#!/item/#{QUERY.sub(/^\#/, "")}"
`open #{url}`