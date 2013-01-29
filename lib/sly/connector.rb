require 'net/http'
require 'json'

class Sly::Connector
  attr :api_url, :config

  def initialize(config=false, api_url="https://sprint.ly/api")
    @api_url = api_url
    @config = !config ? Sly::Config.new : config
  end

  def authenticated_request(url, params={}, post=false)
    #always return maximum results
    params[:limit] = 100

    if(!post && !params.empty?)
      url << "?"+URI.escape(params.collect{|k,v| "#{k}=#{v}"}.join("&"))
    end

    uri = URI.parse(url)

    if(post)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(params)
    else
      request = Net::HTTP::Get.new(uri.to_s)
    end

    request.basic_auth(@config.email, @config.api_key)

    response = Net::HTTP.start(
                 uri.host,
                 uri.port, 
                 :use_ssl => (uri.scheme == 'https'), 
                 :verify_mode => OpenSSL::SSL::VERIFY_NONE
               ) do |https|
      https.request(request)
    end

    if(response.class.body_permitted?)
      JSON(response.body)
    else
      false
    end
  end

  def people
    authenticated_request(@api_url+"/products/#{@config.product_id}/people.json")
  end

  def products
    authenticated_request(@api_url+"/products.json")
  end

  def product(id)
    authenticated_request(@api_url+"/products/#{id}.json")
  end

  def person(id)
    authenticated_request(@api_url+"/products/#{@config.product_id}/people/#{id}.json")
  end

  def items(filters={})
    authenticated_request(@api_url+"/products/#{@config.product_id}/items.json", filters)
  end

  def authorized?
    products.kind_of?(Array)
  end

  def add_item(attributes)
    authenticated_request(@api_url+"/products/#{@config.product_id}/items.json", attributes, true)
  end
end