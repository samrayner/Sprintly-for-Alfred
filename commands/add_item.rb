require 'json'
require 'cgi'

QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"

begin
  sly = Sly::Interface.new
rescue Sly::ConfigFileMissingError => e
  puts Sly::WorkflowUtils.error_notification(e)
  exit
end

attributes = JSON(CGI.unescape(QUERY))

item = Sly::Item.new_typed(attributes)

if item.type == "story" && item.to_hash.values_at(:who, :what, :why).include?("__")
  puts "ERROR: Incomplete story title '#{item.title}'"
  exit
end

sly.add_item(item)

column = Sly::Interface.common_term(item.status).capitalize

puts "Added #{item.type} \"#{item.title}\" to #{column}"