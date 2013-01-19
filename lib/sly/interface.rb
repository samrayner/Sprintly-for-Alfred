class Sly::Interface
  attr :connector

  def initialize(connector=false)
    @connector = !connector ? Sly::Connector.new : connector
  end

  def products
    @connector.products.map { |product| Sly::Product.new(product) }
  end

  def product(id)
    Sly::Product.new(@connector.product(id))
  end
end