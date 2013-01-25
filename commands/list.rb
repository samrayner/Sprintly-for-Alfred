QUERY = ARGV[0].to_s.downcase.strip
require_relative "../lib/sly"

valid_args = ["backlog", "current", "completed", "accepted"]
options = []

valid_args.each do |arg|
  #full argument typed - show results
  if(QUERY.match(/^#{arg}/))
    filters = {}

    status = (arg == "current") ? "in-progress" : arg

    filters = {status:status}

    begin
      sly = Sly::Interface.new
    rescue Sly::ConfigFileMissingError => e
      error = [Sly::WorkflowUtils.error_item(e)]
      puts Sly::WorkflowUtils.results_feed(error)
      exit
    end

    options = sly.items(filters, QUERY.sub(/^#{arg}\s*/, ""))
    break
  #partial argument typed - filter options
  elsif(arg.match(/^#{QUERY}/))
    options << Sly::WorkflowUtils.autocomplete_item(arg.capitalize, "List #{arg} items", arg+" ")
  end
end

if(options.empty?)
  options = [Sly::WorkflowUtils.empty_item]
end

puts Sly::WorkflowUtils.results_feed(options)