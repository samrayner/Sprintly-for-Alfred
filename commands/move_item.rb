QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"
sly = Sly::Interface.new

matches = QUERY.match(/^\#(?<id>\d+)\s+(?<status>someday|backlog|current|completed|accepted)/i)

if(matches)
  status = matches[:status] == "current" ? "in-progress" : matches[:status]
  sly.update_item(matches[:id], {"status" => status})
  puts "Moved item ##{matches[:id]} to #{matches[:status].to_s.capitalize}"
else
  puts "Invalid ID or status"
end