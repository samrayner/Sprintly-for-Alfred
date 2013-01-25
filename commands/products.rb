QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"

begin
  sly = Sly::Interface.new
rescue Sly::ConfigFileMissingError => e
  error = [Sly::WorkflowUtils.error_item(e)]
  puts Sly::WorkflowUtils.results_feed(error)
  exit
end

options = sly.products(QUERY)

if(options.empty?)
  options = [Sly::WorkflowUtils.empty_item]
end

puts Sly::WorkflowUtils.results_feed(options)