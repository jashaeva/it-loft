#!/bin/env ruby
# encoding: utf-8
require "pry"

require_relative '../spec/spec_helper'

require_relative '../spec/commons/UserAddEvent'
require_relative '../spec/commons/AdminPanelRequests'
require_relative '../spec/commons/LoginPage'
require_relative '../spec/commons/MoveEventPage'
require_relative '../spec/commons/CancelEventPage'


describe "Create and cancel event. " do
  ev_ID = ""
 
  before (:all) do 
   
    page = LoginPage.new(browser, true) 
    browser.refresh          
    page.login_with('funnicaplanit@yandex.ru', '12345')
    Watir::Wait.until{ browser.url == TEST_URL }
    page = UserAddEventPage.new(browser, true)
    page.default    
    logout()    
    
    page = LoginPage.new(browser, true)       
    page.login_with('admin@itlft.omsk', 'admin')    
    Watir::Wait.until{ browser.url == 'http://itlft.7bits.it/admin/requests' }  
    divRequests = browser.divs(class: "row requests-block")
    divRequests.each do |request|   
      if request.div(class: "text-20 orange").text == "Happy New Year celebrating -- test"          
        buttonAccept = request.div(class: "col-xs-12 col-sm-2 admin-btn-margin-top").button(class: "js-add-rq btn btn-xs btn-green admin-btn-margin")
        ev_ID = buttonAccept.attribute_value("ev_id")
        STDERR.puts "cancel ev_ID = "+ ev_ID
        buttonAccept.click        
        break
      end
    end
    logout()
   
  end
  
  describe "Cancel event" do    
    context "cancelComment" do
      before (:all) do  
        # binding.pry             
        page = LoginPage.new(browser, true)  
        page.login_with('funnicaplanit@yandex.ru', '12345')              
        Watir::Wait.until{ browser.url == TEST_URL }
      end  
      before (:each) do
        browser.goto "http://sevenbits:10ytuhbnzn@itlft.7bits.it/user-event/cancel/#{ev_ID}"
      end
      
      it "empty comment" do        
        page = CancelEventPage.new(browser)
        page.transferComment = ""
        page.sendRequest
        expect( page.errorComment !="").to be_truthy        
      end
      it "transferComment can't be too long (513)" do
        page = CancelEventPage.new(browser)
        page.transferComment = str(512)
        page.sendRequest
        expect( page.errorComment !="").to be_truthy
      end
      it "cancel event" do
        page = CancelEventPage.new(browser)
        page.transferComment = "Cancelled"
        page.sendRequest
        expect( page.errorComment !="").to be_falsey       
        expect( page.response !="").to be_truthy       
      end

      after (:all) do
        logout()
      end
    end    
  end
          
  
  after (:all) do       
    page = LoginPage.new(browser, true)   
    page.login_with('admin@itlft.omsk', 'admin')
    Watir::Wait.until{ browser.url == 'http://itlft.7bits.it/admin/requests' }
    page = AdminPanelRequests.new(browser, true)    
    buttEv = buttons(:xpath, './/*[@class="js-btn-ev btn btn-xs btn-blue admin-btn-margin"]')
    buttEv.each do |but| 
      if ( but.attribute_value("ev_id") == ev_ID.to_s )
        but.click
        Watir::Wait.until { browser.alert.exists? }
        browser.alert.ok
        break
      end
    end                
    logout()
  end
 
end