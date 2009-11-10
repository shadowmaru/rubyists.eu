require 'dm-core'
require 'dm-validations'
require 'dm-serializer/to_json'
require 'dm-timestamps'
require 'dm-pager'

PATTERN_CODE = /^[A-Z]{2}$/
PATTERN_NAME = /^[A-Z][a-zA-Z '&-.]*$/
PATTERN_EMAIL = /^(?:[a-z]+)(\.[\w\-]+)*@([\w\-]+)(\.[\w\-\.]+)*(\.[a-z]{2,4})$/i
PATTERN_URL = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/\.*)?([a-z0-9\-]*\/?)*$/ix

module Model
  class Base
    class << self
      def clear
        all.destroy!
      end
    
      def empty?
        all.empty?
      end
    end
  end
end

class Country < Model::Base
  include DataMapper::Resource
  
  has 1, :location
  
  property :code, String, :length => 2, :format => PATTERN_CODE, :key => true
  property :name, String, :nullable => false, :format => PATTERN_NAME

  class << self
    def populate
      File.open("#{Dir.pwd}/data/countries.csv", File::RDONLY).each_line do |row|
        country = Country.new

        country.name = ""
        name, code = row.split(';')
        name.downcase!.split(' ').each{|fraction| country.name << "#{fraction.capitalize} "}
        country.name.chop!
        country.code = code[0, 2]

        country.save if Country.get(country.code).nil?
      end
    end
  end
end

class Location < Model::Base
  include DataMapper::Resource
  
  has 1, :group
  belongs_to :country
  
  property :id, Serial
  property :city, String, :nullable => false, :format => PATTERN_NAME
  property :country_code, String, :nullable => false
  property :latitude, Float
  property :longitude, Float
  
  before :save do
    throw :halt unless Geocoder.location?(city, country.name)
    
    self.longitude, self.latitude = Geocoder.position(city, country.name)
  end
end

class Group < Model::Base
  include DataMapper::Resource
  
  belongs_to :location

  property :id, Serial
  property :name, String, :nullable => false, :format => PATTERN_NAME
  property :website, String, :nullable => true
  property :created_at, DateTime
  property :updated_at, DateTime
  
  validates_format :website, :as => PATTERN_URL, :unless => Proc.new {|group| group.website.nil?}
end

DataMapper.setup(:default, (ENV['DATABASE_URL'] || "postgres://akitaonrails17:rubistas666@postgresql04.akitaonrails.com/akitaonrails17"))
production? ? DataMapper.auto_upgrade! : DataMapper.auto_migrate! 
Country.populate