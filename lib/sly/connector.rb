require 'net/http'
require 'json'
require 'openssl'

class Sly::Connector
  attr :api_url, :config

  def initialize(config=false, api_url="https://sprint.ly/api")
    @api_url = api_url
    @config = !config ? Sly::Config.new : config
  end

  def authenticated_request(url, params={}, post=false)
    #always return maximum results
    params[:limit] = 100

    append_query_string(url, params) unless post || params.empty?

    uri = URI.parse(url)

    if post
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(params)
    else
      request = Net::HTTP::Get.new(uri.to_s)
    end

    request.basic_auth(self.config.email, self.config.api_key)

    response = Net::HTTP.start(
                 uri.host,
                 uri.port,
                 use_ssl: (uri.scheme == 'https'),
                 verify_mode: OpenSSL::SSL::VERIFY_NONE
               ){ |https| https.request(request) }

    if response.class.body_permitted?
      JSON(response.body) rescue false
    else
      false
    end
  end

  def people
    authenticated_request(self.api_url+"/products/#{self.config.product_id}/people.json")
  end

  def products
    authenticated_request(self.api_url+"/products.json")
  end

  def authorized?
    products.kind_of?(Array)
  end

  def product(id)
    authenticated_request(self.api_url+"/products/#{id}.json")
  end

  def person(id)
    authenticated_request(self.api_url+"/products/#{self.config.product_id}/people/#{id}.json")
  end

  def items(filters={})
    filters[:children] = true
    authenticated_request(self.api_url+"/products/#{self.config.product_id}/items.json", filters)
  end

  def item(id)
    authenticated_request(self.api_url+"/products/#{self.config.product_id}/items/#{id}.json")
  end

  def add_item(attributes)
    authenticated_request(self.api_url+"/products/#{self.config.product_id}/items.json", attributes, true)
  end

  def update_item(id, attributes)
    authenticated_request(self.api_url+"/products/#{self.config.product_id}/items/#{id}.json", attributes, true)
  end

  private

  def append_query_string(url, params)
    url << "?"+URI.escape(params.collect{ |k,v| "#{k}=#{v}" }.join("&"))
  end
end
