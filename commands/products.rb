QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"

begin
  sly = Sly::Interface.new
rescue Sly::ConfigFileMissingError => e
  puts Sly::WorkflowUtils.results_feed([Sly::WorkflowUtils.error_item(e)])
  exit
end

options = sly.products(QUERY)

options = [Sly::WorkflowUtils.empty_item] if options.empty?

puts Sly::WorkflowUtils.results_feed(options)