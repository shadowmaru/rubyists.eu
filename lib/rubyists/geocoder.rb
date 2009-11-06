require 'open-uri'
require 'json'

module Geocoder
  class << self
    
    SUCCESS = 200
    SERVER_ERROR = 500
    MISSING_QUERY = 601
    UNKNOWN_ADDRESS = 602
    UNAVAILABLE_ADDRESS = 603
    BAD_KEY = 610
    TOO_MANY_QUERIES = 620
    
    def position(city, country)
      point = nil
      
      open(query(city, country)) do |file|
        response = JSON.parse(file.read)
        point = response['Placemark'].first['Point']['coordinates'].values_at(0, 1) \
          if response['Status']['code'] == SUCCESS
      end
      
      point
    end
    
    def location?(city, country)
      result = true
    
      open(query(city, country)) do |file|
        response = JSON.parse(file.read)
        result = false if response['Status']['code'] == UNKNOWN_ADDRESS
      end
    
      result
    end
    
    private
    
    def query(city, country)
      location = "#{city.gsub(' ', '+')},+#{country.gsub(' ', '+')}"
      
      "http://maps.google.com/maps/geo?q=#{location}&output=json&oe=utf8&sensor=false"
    end
  end
end