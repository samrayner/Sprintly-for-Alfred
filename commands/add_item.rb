require 'json'
require 'cgi'

QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"
sly = Sly::Interface.new

attributes = JSON(CGI.unescape(QUERY))

item = Sly::Item.new_typed(attributes)

sly.add_item(item)

item.status = "current" if(item.status == "in-progress")

puts "Added #{item.type} \"#{item.title}\" to #{item.status.capitalize}"