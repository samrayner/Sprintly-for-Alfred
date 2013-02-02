require 'json'
require 'cgi'

QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"
sly = Sly::Interface.new

attributes = JSON(CGI.unescape(QUERY))

item = Sly::Item.new_typed(attributes)

sly.add_item(item)

column = Sly::Interface.common_term(item.status).capitalize

puts "Added #{item.type} \"#{item.title}\" to #{column}"