ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'nokogiri'

%w{spec/support lib}.each do |dir|
  Dir[Rails.root.join("#{dir}/**/*.rb")].each {|f| require f}
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include FactoryGirl::Syntax::Methods
end

RSpec::Matchers.define :have_same_attributes_as do |expected|
  match do |actual|
    if actual.class != Array
      actual = [actual]
      expected = [expected]
    end
    ignored = [:_id]
    actual.each_with_index {|c, i| c.attributes.except(*ignored) == expected[i].attributes.except(*ignored) }
  end
end

def xml_fixture file_name
  f = File.open("#{Rails.root}/spec/fixtures/import/#{file_name}.xml")
  Nokogiri::XML(f)
end