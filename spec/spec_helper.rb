# Configuration for watir-rspec
require 'headless'
require "watir/rspec"
# require "watir-webdriver"

require_relative '../spec/commons/roots'
# require_relative '../spec/commons/useful_func'


RSpec.configure do |config|
  config.add_formatter(:progress) if config.formatters.empty?
  config.add_formatter(Watir::RSpec::HtmlFormatter) 

  # Open up the browser for each example.
  config.before :all do
    display = ENV['BUILD_NUMBER'] || "99"
    @headless = Headless.new(:display => display)     
    @headless.start
    
    @browser = Watir::Browser.new (ENV['browser'] || :ff) 
    Watir.default_timeout = 5  
    # prefs = {
    #  :download => {
    #    :prompt_for_download => false,
    #    :default_directory => "../chromedriver"
    #  }
    # }
    # @browser = Watir::Browser.new :chrome, :prefs => prefs
    # @browser.driver.manage.timeouts.implicit_wait = 5  
    @browser.driver.manage.timeouts.page_load = 30     
    @browser.window.maximize
  end
  
  # Close that browser after each example.
  config.after :all do
    @browser.close if @browser
    @headless.destroy_sync
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

  config.expect_with :rspec do |c|    
    # Disable the `should` syntax
    c.syntax = :expect

    # # Disable the `expect` sytax
    # c.syntax = :should
    # # ...or explicitly enable both
    # c.syntax = [:should, :expect]
  end
end

