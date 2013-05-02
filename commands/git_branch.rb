QUERY = ARGV[0].to_s.downcase.strip.sub(/^#/, "")
require_relative "../lib/sly"

begin
  sly = Sly::Interface.new
rescue Sly::ConfigFileMissingError => e
  puts Sly::WorkflowUtils.error_notification(e)
  exit
end

item = sly.item(QUERY)

if item
  type = (item.type == "story") ? "feature" : item.type
  slug = item.slug

  if(slug.length > 50)
    truncate_to = item.slug.index("-", 40)
    slug = item.slug[0,truncate_to]
  end

  command = "git checkout -b #{type}/#{item.number}-#{slug}"
  IO.popen('pbcopy', 'w') { |f| f << command }
end