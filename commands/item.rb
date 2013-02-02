QUERY = ARGV[0].to_s.downcase.strip
require_relative "../lib/sly"
sly = Sly::Interface.new

item = sly.item(QUERY)

options = item ? [item] : [Sly::WorkflowUtils.empty_item]

puts Sly::WorkflowUtils.results_feed(options)