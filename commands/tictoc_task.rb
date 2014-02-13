QUERY = ARGV[0].to_s.downcase.strip.sub(/^#/, "")
require_relative "../lib/sly"
sly = Sly::Interface.new_if_config

item = sly.item(QUERY)

if item
  puts "#{item.type.capitalize} ##{item.number} - #{item.title}"
end
