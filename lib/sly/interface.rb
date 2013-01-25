require 'json'
require 'fileutils'

class Sly::Interface
  attr :connector
  CACHE_DIR = File.expand_path("~/Library/Caches/com.runningwithcrayons.Alfred-2/Workflow Data/"+Sly::BUNDLE_ID)

  def initialize(connector=false)
    @connector = !connector ? Sly::Connector.new : connector
  end

  def cache(filename, query="", &block)
    FileUtils.mkpath(CACHE_DIR)

    cache_file = CACHE_DIR+'/'+filename
    items = []

    if(query.empty? || !File.exists?(cache_file))
      items = block.call
      File.open(cache_file, 'w') do |f|  
        f.puts items.to_json
      end
    else
      begin
        File.open(cache_file, 'r') do |f|  
          items = JSON(f.read)
        end
      rescue
        items = block.call
      end
    end

    items
  end

  def products(query="")
    products = self.cache("products.json", query) { @connector.products }

    #JSON error message returned
    if(!products.kind_of? Array)
      return []
    end

    #filter by query
    products = products.find_all { |product| query.empty? || product["name"].downcase.match(/^#{query.downcase}/) }

    #convert to objects
    products.map! { |product| Sly::Product.new(product) }
  end

  def product(id)
    product = @connector.product(id)

    #JSON errors have an error code
    if(product.include? "code")
      return false
    end

    Sly::Product.new(@connector.product(id))
  end

  def items(filters={}, query="")
    items = self.cache("items.json", query) { @connector.items(filters) }

    #JSON error message returned
    if(!items.kind_of? Array)
      return []
    end

    #filter by query
    items = items.find_all { |item| query.empty? || item["title"].downcase.include?(query.downcase) }

    #convert to appropriate objects
    items.map! { |item| Sly::const_get("#{item["type"].capitalize}Item").new(item) }
  end
end