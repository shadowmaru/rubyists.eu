require 'open-uri'
require 'json'

module GoogleMaps
  def self.valid_location?(city, country)
    result = true
    
    open("http://maps.google.com/maps/geo?q=#{city.gsub(' ', '+')},+#{country.gsub(' ', '+')}") do |file|
      response = JSON.parse(file.read)
      result = false if response['Status']['code'] == 602
    end
    
    result
  end
end