QUERY = ARGV[0].to_s.downcase.strip
require_relative "../lib/sly"
sly = Sly::Interface.new_if_config

valid_args = ["someday", "backlog", "current", "completed", "accepted"]
options = []

valid_args.each do |arg|
  #full argument typed - show results
  if QUERY.match(/^#{arg}/)
    filters = { status: Sly::Interface.api_term(arg) }
    options = sly.items(filters, QUERY.sub(/^#{arg}\s*/, ""))
    break
  #partial argument typed - filter options
  elsif arg.match(/^#{QUERY}/)
    options << Sly::WorkflowUtils.autocomplete_item(arg.capitalize, "List #{arg} items", arg+" ")
  end
end

options = [Sly::WorkflowUtils.empty_item] if options.empty?

puts Sly::WorkflowUtils.results_feed(options)
