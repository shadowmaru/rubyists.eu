require File.join(File.dirname(__FILE__), 'spec_helper')

describe Geocoder do
  before :all do
    @locations = [{:city => 'Paris', :country => 'France'}, {:city => 'St. Petersburg', :country => 'Russian Federation'}]
    @exceptions = [{:city => 'Parisebboicn eid', :country => 'France'}, {:city => 'Cje Petersburgdbuebdo', :country => 'Russian Federation'}]
  end
  
  it "should return the point on a map for an existing location." do
    @locations.each do |location|
      location[:city].should be_an_instance_of(String)
      location[:city].should_not be_empty
      location[:country].should be_an_instance_of(String)
      location[:country].should_not be_empty
      
      point = Geocoder.position(location[:city], location[:country])
      
      point.should be_an_instance_of(Array)
      point.size.should == 2
      point.each {|coordinate| coordinate.should be_an_instance_of(Float)}
    end
  end
  
  it "should return a NilClass instance for a non-existing location." do
    @exceptions.each do |location|
      location[:city].should be_an_instance_of(String)
      location[:city].should_not be_empty
      location[:country].should be_an_instance_of(String)
      location[:country].should_not be_empty
      
      Geocoder.position(location[:city], location[:country]).should be_nil
    end
  end
  
  it "should verify the existence of an existing location." do
    @locations.each do |location|
      location[:city].should be_an_instance_of(String)
      location[:city].should_not be_empty
      location[:country].should be_an_instance_of(String)
      location[:country].should_not be_empty
      
      Geocoder.location?(location[:city], location[:country]).should == true
    end
  end
  
  it "should not verify the existence of a non-existing location." do
    @exceptions.each do |location|
      location[:city].should be_an_instance_of(String)
      location[:city].should_not be_empty
      location[:country].should be_an_instance_of(String)
      location[:country].should_not be_empty
      
      Geocoder.location?(location[:city], location[:country]).should == false
    end
  end  
end