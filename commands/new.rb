require 'cgi'

QUERY = ARGV[0].to_s.strip
require_relative "../lib/sly"
sly = Sly::Interface.new_if_config

matches = Sly::Item.creation_regex.match(QUERY)
options = []

if matches
  #fall back to defaults
  item = Sly::Item.defaults.dup
  item.each_key do |key|
    if matches.names.include?(key.to_s) && matches[key]
      item[key] = matches[key].strip
    end
  end

  #autocomplete score
  if QUERY.match(/^#{item[:type]} ?$/i)
    options = []
    Sly::Item.scores.each do |code, name|
      options << Sly::WorkflowUtils.autocomplete_item(name.capitalize, "", "#{item[:type]} #{code} ", "images/#{item[:type]}-#{code}.png")
    end
    puts Sly::WorkflowUtils.results_feed(options)
    exit
  end

  #autocomplete person
  person_match = QUERY.match(/\@([a-z]*)$/i)
  if person_match
    people = sly.people(person_match[1])
    people.map! { |person| Sly::WorkflowUtils.autocomplete_item(person.full_name, person.email, QUERY.sub(/#{person_match[1]}$/, person.id.to_s)) }
    puts Sly::WorkflowUtils.array_to_xml(people)
    exit
  end

  unless item[:tags].empty?
    #convert "#tag1 #tag2" to [tag1, tag2]
    item[:tags] = item[:tags].strip.split(" #").map { |tag| tag.strip.sub(/^#/, "") }
  end

  #convert "@id" to Person
  item[:assigned_to] = item[:assigned_to].empty? ? nil : sly.connector.person(item[:assigned_to])

  preview_item = Sly::Item.new_typed(item)
  result = preview_item.alfred_result

  if item[:title] == Sly::Item.defaults[:title]
    result[:autocomplete] = QUERY
    result[:valid] = "no"
  else
    result[:arg] = CGI.escape(preview_item.to_json)
  end

  options = [result]

#autocomplete type
else
  Sly::Item.types.each do |type|
    if QUERY.empty? || type.match(/^#{QUERY.downcase}/)
      options << Sly::WorkflowUtils.autocomplete_item(type.capitalize, "", type+" ", "images/#{type}-~.png")
    end
  end
end

options = [Sly::WorkflowUtils.empty_item] if options.empty?

puts Sly::WorkflowUtils.results_feed(options)
