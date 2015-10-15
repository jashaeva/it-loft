#!/bin/env ruby
# encoding: utf-8
require "pry"

require_relative '../spec/spec_helper'

require_relative '../spec/commons/LoginPage'
require_relative '../spec/commons/AdminAddSubscription'

describe "Admin Add Subscriber" do

  context 'Subscriber?' do
    before (:all) do
      page =  LoginPage.new(browser, true)
      page.login_with('admin@itlft.omsk', 'admin')      
      Watir::Wait.until { browser.url == 'http://itlft.7bits.it/admin/requests' }
    end
    
    # it 'Positive email examples' do 
    #   emails = File.readlines("test_data/good_emails.txt")            
    #   aggregate_failures("good_emails") do
    #     emails.each do |email|
    #       page = AdminAddSubscription.new(browser, true)
    #       page.subscriber_element.when_visible          
    #       page.subscriber = email
    #       page.subscribe          
    #       page.errorSubscriber_element.when_visible(10)          
    #       expect(page.success()).to  be_truthy
    #     end
    #   end
    # end  
    
    it 'Negative email examples' do  
      page = AdminAddSubscription.new(browser, true)            
      emails = File.readlines("test_data/bad_emails.txt")
      aggregate_failures("bad_emails") do
        emails.each do |email|      
          page.subscriber = email
          page.subscribe 
          page.errorSubscriber_element.when_visible(10)
          expect(page.fail()).to  be_truthy          
        end
      end
    end

    after (:all) do
      logout()
    end
  end
end