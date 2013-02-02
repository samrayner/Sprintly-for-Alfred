QUERY = ARGV[0].to_s.downcase.strip
require_relative "../lib/sly"

begin
  sly = Sly::Interface.new
rescue Sly::ConfigFileMissingError => e
  puts Sly::WorkflowUtils.results_feed([Sly::WorkflowUtils.error_item(e)])
  exit
end

item = sly.item(QUERY)
options = item ? [item] : [Sly::WorkflowUtils.empty_item]

puts Sly::WorkflowUtils.results_feed(options)