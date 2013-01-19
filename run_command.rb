#run via current RVM ruby not old system ruby
rubies = `~/.rvm/bin/rvm list`
current_ruby = /=[\*>]\s*(\S+)/.match(rubies)[1]
puts `~/.rvm/rubies/#{current_ruby}/bin/ruby "commands/#{COMMAND}.rb" "#{QUERY}"`