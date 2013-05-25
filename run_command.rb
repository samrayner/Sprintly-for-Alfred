def ruby_exec_path(manager)
  begin
    ruby_path = `~/.#{manager}/bin/#{manager} which ruby`
    if $?.exitstatus == 127
      raise Errno::ENOENT
    end
  rescue Errno::ENOENT
    ruby_path = ""
  end
  return ruby_path.strip
end

ruby_path = ruby_exec_path("rvm")
ruby_path = ruby_exec_path("rbenv") unless ruby_path.length
ruby_path = "ruby" unless ruby_path.length

parent_dir = File.expand_path(File.dirname(__FILE__))
output = `#{ruby_path} "#{parent_dir}/commands/#{COMMAND}.rb" "#{QUERY}"`
puts output unless output.empty?