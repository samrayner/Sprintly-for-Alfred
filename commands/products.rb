QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"
sly = Sly::Interface.new_if_config

options = sly.products(QUERY)
options = [Sly::WorkflowUtils.empty_item] if options.empty?

puts Sly::WorkflowUtils.results_feed(options)
