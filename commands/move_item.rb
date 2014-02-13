QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"
sly = Sly::Interface.new_if_config

matches = QUERY.match(/^\#(?<id>\d+)\s+(?<status>someday|backlog|current|completed|accepted)/i)

if matches
  attributes = { status: Sly::Interface.api_term(matches[:status]) }
  sly.update_item(matches[:id], attributes)
  puts "Moved item ##{matches[:id]} to #{matches[:status].capitalize}"
else
  puts "Invalid ID or status"
end
