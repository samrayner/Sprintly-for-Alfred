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

  def people(query="")
    people = self.cache("people.json", query) { @connector.people }

    #JSON error message returned
    if(!people.kind_of? Array)
      return []
    end

    #convert to objects
    people.map! { |person| Sly::Person.new(person) }

    #filter by query
    people.find_all { |person| query.empty? || person.full_name.downcase.include?(query.downcase) }
  end

  def products(query="")
    products = self.cache("products.json", query) { @connector.products }

    #JSON error message returned
    return [] if(!products.kind_of? Array)

    #convert to objects
    products.map! { |product| Sly::Product.new(product) }

    #filter by query
    products.find_all { |product| query.empty? || product.name.downcase.match(/^#{query.downcase}/) }
  end

  def items(filters={}, query="")
    items = self.cache("items.json", query) { @connector.items(filters) }

    #JSON error message returned
    return [] if(!items.kind_of? Array)

    #convert to appropriate objects
    items.map! { |item| Sly::Item.new_typed(item) }

    #filter by query
    items.find_all { |item| query.empty? || item.title.downcase.include?(query.downcase) }
  end

  def product(id)
    product = @connector.product(id)

    #JSON errors have an error code
    return nil if(product.include? "code")

    Sly::Product.new(product)
  end

  def person(id)
    person = @connector.person(id)

    #JSON errors have an error code
    return nil if(person.include? "code")

    Sly::Person.new(person)
  end

  def add_item(item)
    item.assigned_to = item.assigned_to.id if(item.assigned_to.id)

    attributes = item.to_hash

    attributes.each_key do |key|
      if(attributes[key].kind_of? Hash)
        attributes.delete(key)
      end
    end

    @connector.add_item(attributes)
  end
end