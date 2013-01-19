require 'net/http'
require 'json'

class Sly::Connector
  attr :api, :user_details

  def initialize(user_details = {}, api_url="https://sprint.ly/api")
    @api_url = api_url
    @user_details = user_details
  end

  def authenticated_request(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri.path)
    req.basic_auth(@user_details[:email], @user_details[:password])

    response = Net::HTTP.start(
                 uri.host,
                 uri.port, 
                 :use_ssl => (uri.scheme == 'https'), 
                 :verify_mode => OpenSSL::SSL::VERIFY_NONE
               ) do |https|
      https.request(req)
    end

    if response.class.body_permitted?
      JSON(response.body)
    else
      false
    end
  end

  def products
    authenticated_request(@api_url+"/products.json")
  end

  def product_overview(id)
    authenticated_request(@api_url+"/products/#{id}.json")
  end

  def items_for_product(id)
    authenticated_request(@api_url+"/products/#{id}/items.json")
  end

  def authorized?
    products != false
  end
end