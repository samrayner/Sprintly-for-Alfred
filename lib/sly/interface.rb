require 'JSON'

class Sly::Interface
  attr :connector
  CACHE_DIR = File.join(File.dirname(__FILE__), '../../cache')

  def initialize(connector=false)
    @connector = !connector ? Sly::Connector.new : connector
  end

  def cache(method, query="")
    if(!FileTest::directory?(CACHE_DIR))
      Dir::mkdir(CACHE_DIR)
    end

    cache_file = "#{CACHE_DIR}/#{method}.json"
    items = []

    if(query.empty? || !File.exists?(cache_file))
      items = @connector.send(method.to_sym)
      File.open(cache_file, 'w') do |f|  
        f.puts items.to_json
      end
    else
      begin
        File.open(cache_file, 'r') do |f|  
          items = JSON(f.read)
        end
      rescue
        items = @connector.send(method.to_sym)
      end
    end

    items
  end

  def products(query="")
    products = self.cache("products", query)

    #JSON error message returned
    if(!products.kind_of? Array)
      return []
    end

    #filter by query
    products = products.select { |product| query.empty? || product["name"].downcase.include?(query.downcase) }

    products.map { |product| Sly::Product.new(product) }
  end

  def product(id)
    product = @connector.product(id)

    #JSON errors have an error code
    if(product.include? "code")
      return false
    end

    Sly::Product.new(@connector.product(id))
  end
end