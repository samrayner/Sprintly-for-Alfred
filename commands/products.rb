QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"

sly = Sly::Interface.new

options = sly.products(QUERY)

if(options.empty?)
  options = [Sly::WorkflowUtils.empty_item]
end

puts Sly::WorkflowUtils.results_feed(options)