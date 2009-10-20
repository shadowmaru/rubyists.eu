$LOAD_PATH << File.join(File.dirname(__FILE__), 'data_model')

require 'dm-core'
require 'dm-validations'
require 'dm-serializer/to_json'

PATTERN_CODE = /^[A-Z]{2}$/
PATTERN_NAME = /^([A-Z][a-z\.\-]*\s?)+$/
PATTERN_EMAIL = /^(?:[a-z]+)(\.[\w\-]+)*@([\w\-]+)(\.[\w\-\.]+)*(\.[a-z]{2,4})$/i
PATTERN_URL = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/\.*)?([a-z0-9\-]*\/?)*$/ix

class Country
  include DataMapper::Resource
  
  has 1, :user
  has 1, :group
  
  property :code, String, :length => 2, :format => PATTERN_CODE, :key => true
  property :name, String, :nullable => false

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

class Group
  include DataMapper::Resource
  
  belongs_to :country

  property :id, Serial
  property :name, String, :nullable => false, :format => PATTERN_NAME
  property :city, String, :nullable => false, :format => PATTERN_NAME
  property :website, String, :nullable => true
  property :created_at, DateTime, :nullable => false
  
  validates_format :website, :as => PATTERN_URL, :unless => Proc.new {|group| group.website.empty? }
  
  before :save do
    throw :halt if Country.get(country_code).nil?
  end
end

class User
  include DataMapper::Resource
  
  belongs_to :country
  
  property :id, Serial
  property :openid, String, :nullable => false
  property :name, String, :nullable => false, :format => PATTERN_NAME
  property :email, String, :nullable => false, :format => PATTERN_EMAIL
  property :city, String, :nullable => false, :format => PATTERN_NAME

  before :save do
    throw :halt if Country.get(country_code).nil?
  end
end

DataMapper.setup(:default, (ENV['DATABASE_URL'] || "postgres://postgres:postgres@localhost/rubyists"))
production? ? DataMapper.auto_upgrade! : DataMapper.auto_migrate! 
Country.populate