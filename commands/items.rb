QUERY = ARGV[0].to_s.downcase.strip
require_relative "../lib/sly"

valid_args = ["all", "someday", "backlog", "current", "completed", "accepted"]
options = []

valid_args.each do |arg|
  #full argument typed - show results
  if(QUERY.match(/^#{arg}/))
    filters = {}

    if(arg != "all")
      if(arg == "current")
        arg = "in-progress" #old terminology for API
      end
      filters = {status:arg}
    end

    options = Sly::Interface.new.items(filters)
    break

  #partial argument typed - filter options
  elsif(arg.match(/^#{QUERY}/))
    options << Sly::WorkflowUtils.autocomplete_item(arg.capitalize, "List #{arg} items", arg)
  end
end

puts Sly::WorkflowUtils.results_feed(options)