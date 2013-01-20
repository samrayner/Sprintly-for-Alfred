class Sly::Interface
  attr :connector

  def initialize(connector=false)
    @connector = !connector ? Sly::Connector.new : connector
  end

  def products(query="")
    products = @connector.products

    if(!products.kind_of? Array)
      return []
    end

    #filter by query
    products = products.select { |product| query.empty? or product["name"].downcase.include?(query.downcase) }

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