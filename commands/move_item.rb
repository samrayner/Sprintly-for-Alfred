QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"
sly = Sly::Interface.new

matches = QUERY.match(/^\#(?<id>\d+)\s+(?<status>someday|backlog|current|completed|accepted)/i)

if matches
  sly.update_item(matches[:id], {"status" => Sly::Interface.api_term(matches[:status])})
  puts "Moved item ##{matches[:id]} to #{matches[:status].capitalize}"
else
  puts "Invalid ID or status"
end