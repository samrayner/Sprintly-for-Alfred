QUERY = ARGV[0].to_s.downcase.strip.sub(/^\#/, "")
`open https://sprint.ly/product/#{QUERY}/`