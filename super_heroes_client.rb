require 'uri'
require 'net/http'
require 'json'
require_relative 'utils'

class SuperHeroesClient
  include Utils

  def initialize(access_token)
    @url = 'https://superheroapi.com/api.php'
    @access_token = access_token
  end

  def get_random_heroes
    random_ids = rand_array(10, 731)

    get_heroes(random_ids)
  end

  private

  def get_heroes(ids)
    heroes = []    
    ids.each do |id|
      data = get_data(id)
      data = JSON.parse(data, symbolize_names: true)
      hero = filter_response(data)
      heroes.push(hero)
    end

    heroes
  end

  def filter_response(data)
    {
      :id => data[:id],
      :name => data[:name],
      :power_stats => data[:powerstats],
      :alignment => data[:biography][:alignment]
    }
  end

  def get_data(path='')
    uri = URI("#{@url}/#{@access_token}/#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["accept"] = 'application/json'
    request["access-control-allow-origin"] = '*'

    response = http.request(request)
    response.read_body
  end
end
