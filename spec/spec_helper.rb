# Configuration for watir-rspec
require "watir/rspec"
# require "watir-webdriver"

require_relative '../spec/commons/roots'
require_relative '../spec/commons/useful_func'

RSpec.configure do |config|
  config.add_formatter(:progress) if config.formatters.empty?
  config.add_formatter(Watir::RSpec::HtmlFormatter) 

  # Open up the browser for each example.
  config.before :all do
    #@headless = Headless.new
    #@headless.start
     # @browser = Watir::Browser.new (ENV['browser'] || :ff) 
     # @browser = Watir::Browser.new :ff
     @browser = Watir::Browser.new :chrome
     @browser.driver.manage.timeouts.implicit_wait = 10          
     
  end

  # Close that browser after each example.
  config.after :all do
    @browser.close if @browser
  end

  # Include RSpec::Helper into each of your example group for making it possible to
  # write in your examples instead of:
  #   @browser.goto "localhost"
  #   @browser.text_field(:name => "first_name").set "Bob"
  #
  # like this:
  #   goto "localhost"
  #   text_field(:name => "first_name").set "Bob"
  #
  # This needs that you've used @browser as an instance variable name in
  # before :all block.
  config.include Watir::RSpec::Helper

  # Include RSpec::Matchers into each of your example group for making it possible to
  # use #within with some of RSpec matchers for easier asynchronous testing:
  #   @browser.text_field(:name => "first_name").should exist.within(2)
  #   @browser.text_field(:name => "first_name").should be_present.within(2)
  #   @browser.text_field(:name => "first_name").should be_visible.within(2)
  #
  # You can also use #during to test if something stays the same during the specified period:
  #   @browser.text_field(:name => "first_name").should exist.during(2)
  config.include Watir::RSpec::Matchers
end

