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
  puts "#{item.type.capitalize} ##{item.number} - #{item.title}"
end