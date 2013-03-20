QUERY = ARGV[0].to_s.downcase.strip.sub(/^#/, "")
require_relative "../lib/sly"

begin
  sly = Sly::Interface.new
rescue Sly::ConfigFileMissingError => e
  puts Sly::WorkflowUtils.error_notification(e)
  exit
end

item = sly.item(QUERY)

if item
  type = (item.type == "story") ? "feature" : item.type
  puts "git checkout -b #{type}/#{item.number}-#{item.slug}"
end