require File.join(File.dirname(__FILE__), 'spec_helper')

describe Location do
  context 'as a class' do
    before :all do
      @class = Location
    end
    
    it_should_behave_like 'A Model::Base class'
  end
  
  context 'when the data model have been just defined' do
    before :all do
      Country.new(:name => 'France', :code => 'FR').save
    end
    
    before :each do
      Location.clear unless Location.empty?
    end
    
    it 'should have no data.' do
      Location.should be_empty
    end
    
    it 'should allow to create a new location with a defined 2-letter uppercased country code and a city name.' do
      location = Location.new(:city => 'Paris', :country_code => 'FR')
      
      location.should be_an_instance_of(Location)
      location.city.should be_an_instance_of(String)
      location.city.should =~ PATTERN_NAME
      location.country_code.should be_an_instance_of(String)
      location.country_code.should =~ PATTERN_CODE
      location.country.should_not be_nil
      location.country.should be_an_instance_of(Country)
      location.latitude.should be_nil
      location.longitude.should be_nil
      
      location.save
      
      saved_location = Location.first(:city => location.city, :country_code => location.country_code)

      saved_location.should be_an_instance_of(Location)
      saved_location.city.should == location.city
      saved_location.country_code.should == location.country_code
      saved_location.country.should_not be_nil
      saved_location.country.should be_an_instance_of(Country)
      saved_location.latitude.should_not be_nil
      saved_location.latitude.should be_an_instance_of(Float)
      saved_location.longitude.should_not be_nil
      saved_location.longitude.should be_an_instance_of(Float)
    end
    
    after :all do
      Country.clear unless Country.empty?
    end
  end
end