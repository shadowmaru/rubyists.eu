require File.join(File.dirname(__FILE__), 'spec_helper')

share_examples_for 'A Model::Base class' do
  it "should include every abstract class methods into the heir class." do
    @class.should respond_to(:clear)
    @class.should respond_to(:empty?)
  end
end