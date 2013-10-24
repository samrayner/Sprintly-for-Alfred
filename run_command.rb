parent_dir = File.expand_path(File.dirname(__FILE__))
output = `ruby "#{parent_dir}/commands/#{COMMAND}.rb" "#{QUERY}"`
puts output unless output.empty?
