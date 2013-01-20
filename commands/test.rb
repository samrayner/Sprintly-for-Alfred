QUERY = ARGV[0]
require_relative "../lib/sly"

prod = Sly::Product.new({id:123,name:"Test Product",created_at:"now"})
puts prod.inspect