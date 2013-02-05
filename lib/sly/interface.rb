require 'json'
require 'fileutils'

class Sly::Interface
  attr :connector

  def self.api_term(term)
    key = Sly::API_DICTIONARY.key(term)
    key ? key : term
  end

  def self.common_term(term)
    Sly::API_DICTIONARY.fetch(term, term)
  end

  def initialize(connector=false)
    @connector = !connector ? Sly::Connector.new : connector
  end

  def cache(filename, query="", &block)
    FileUtils.mkpath(Sly::CACHE_DIR)

    cache_file = Sly::CACHE_DIR+'/'+filename
    items = []

    if query.empty? || !File.exists?(cache_file)
      items = block.call
      File.open(cache_file, 'w') { |f| f.puts items.to_json }
    else
      begin
        File.open(cache_file, 'r') { |f| items = JSON(f.read) }
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
    people.find_all do |person| 
      query.empty? || 
      person.full_name.downcase.include?(query.downcase) ||
      (query.downcase == "me" && person.email == @connector.config.email)
    end
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

  def item(id)
    item = @connector.item(id)

    #JSON errors have an error code
    return nil if(item.include? "code")

    Sly::Item.new_typed(item)
  end

  def add_item(item)
    attributes = item.to_hash(true)
    attributes[:tags] = attributes[:tags].join(",")

    @connector.add_item(attributes)
  end

  def update_item(id, attributes)
    raise "Attributes must be in a Hash" unless attributes.kind_of? Hash

    item_hash = @connector.item(id)

    item = Sly::Item.new_typed(item_hash)

    item.attr_from_hash!(attributes)

    #updated attributes, flattened
    item_hash = item.to_hash(true)
    item_hash[:tags] = item_hash[:tags].join(",")

    #can't change type of item
    item_hash.delete(:type)

    @connector.update_item(id, item_hash)
  end
end