require 'json'
require 'fileutils'

class Sly::Interface
  attr :connector

  def self.api_term(term)
    Sly::API_DICTIONARY.key(term) || term
  end

  def self.common_term(term)
    Sly::API_DICTIONARY.fetch(term, term)
  end

  def self.new_if_config
    begin
      Sly::Interface.new
    rescue Sly::ConfigFileMissingError => e
      puts Sly::WorkflowUtils.error_notification(e)
      exit
    end
  end

  def initialize(connector=nil)
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

  def add_item(item)
    attributes = item.to_flat_hash
    self.connector.add_item(attributes)
  end

  def update_item(id, attributes)
    item_hash = self.connector.item(id)
    item = Sly::Item.new_typed(item_hash)
    item.attr_from_hash!(attributes)

    item_hash = item.to_flat_hash

    #can't change type of item
    item_hash.delete(:type)

    self.connector.update_item(id, item_hash)
  end

  def people(query="")
    people = self.cache("people.json", query) { self.connector.people }
    return [] if error_object?(people)

    people.map! { |person| Sly::Person.new(person) }

    #filter by query
    people.select! do |person|
      query.empty? ||
      person.full_name.downcase.include?(query.downcase) ||
      (query.downcase == "me" && person.email == self.connector.config.email)
    end

    people.sort_by { |person| [person.last_name, person.first_name] }
  end

  def products(query="")
    products = self.cache("products.json", query) { self.connector.products }
    return [] if error_object?(products)

    products.map! { |product| Sly::Product.new(product) }

    #reject archived products
    products.reject! { |product| product.archived }

    #filter by query
    products.select! { |product| query.empty? || product.name.downcase.match(/^#{query.downcase}/) }

    products.sort_by(&:name)
  end

  def items(filters={}, query="")
    items = self.cache("items.json", query) { self.connector.items(filters) }
    return [] if error_object?(items)

    items.map! { |item| Sly::Item.new_typed(item) }

    #reject orphaned items
    items.reject! { |item| item.parent && !items.member?(item.parent) }

    person_filter = query.match(/\@([^\s]*)/)

    if person_filter
      query.sub!(person_filter[0], "").strip!
      person_filter = person_filter[1].downcase
    end

    #filter by person
    items.select! do |item|
      person_filter.to_s.empty? ||
      item.assigned_to.full_name.downcase.include?(person_filter) ||
      (person_filter == "me" && item.assigned_to.email == self.connector.config.email)
    end

    #filter by query
    items.select! { |item| query.empty? || item.title.downcase.include?(query.downcase) }

    items.sort_by(&:index)
  end

  def product(id)
    product = self.connector.product(id)
    return nil if error_object?(product)
    Sly::Product.new(product)
  end

  def person(id)
    person = self.connector.person(id)
    return nil if error_object?(person)
    Sly::Person.new(person)
  end

  def item(id)
    item = self.connector.item(id)
    return nil if error_object?(item)
    Sly::Item.new_typed(item)
  end

  private

  def error_object?(object)
    object.include?("code")
  end
end
