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
    return [] unless people.kind_of?(Array)

    people.map! { |person| Sly::Person.new(person) }

    #filter by query
    people.select! do |person|
      query.empty? ||
      person.full_name.downcase.include?(query.downcase) ||
      (query.downcase == "me" && person.email == @connector.config.email)
    end

    people.sort_by { |person| [person.last_name, person.first_name] }
  end

  def products(query="")
    products = self.cache("products.json", query) { @connector.products }

    #JSON error message returned
    return [] unless products.kind_of?(Array)

    products.map! { |product| Sly::Product.new(product) }

    #filter by query
    products.select! { |product| query.empty? || product.name.downcase.match(/^#{query.downcase}/) }

    products.sort_by { |product| product.name }
  end

  def items(filters={}, query="")
    items = self.cache("items.json", query) { @connector.items(filters) }

    #JSON error message returned
    return [] unless items.kind_of?(Array)

    items.map! { |item| Sly::Item.new_typed(item) }

    person_filter = query.match(/\@([^\s]*)/)

    if person_filter
      query.sub!(person_filter[0], "").strip!
      person_filter = person_filter[1].downcase
    end

    #filter by person
    items.select! do |item|
      person_filter.to_s.empty? ||
      item.assigned_to.full_name.downcase.include?(person_filter) ||
      (person_filter == "me" && item.assigned_to.email == @connector.config.email)
    end

    #filter by query
    items.select! { |item| query.empty? || item.title.downcase.include?(query.downcase) }

    #add arrow to title of sub-items
    items.map! do |item|
      if items.member?(item.parent)
        item.title = [0x21B3].pack("U")+" "+item.title
      end
      item
    end

    items.sort_by { |item| item.index }
  end

  def product(id)
    product = @connector.product(id)

    #JSON errors have an error code
    return nil if product.include?("code")

    Sly::Product.new(product)
  end

  def person(id)
    person = @connector.person(id)

    #JSON errors have an error code
    return nil if person.include?("code")

    Sly::Person.new(person)
  end

  def item(id)
    item = @connector.item(id)

    #JSON errors have an error code
    return nil if item.include?("code")

    Sly::Item.new_typed(item)
  end

  def add_item(item)
    attributes = item.to_hash(true)
    attributes[:tags] = attributes[:tags].join(",")

    @connector.add_item(attributes)
  end

  def update_item(id, attributes)
    raise "Attributes must be in a Hash" unless attributes.kind_of?(Hash)

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
