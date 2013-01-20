QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"

sly = Sly::Interface.new
puts Sly::WorkflowUtils.results_feed(sly.products(QUERY))