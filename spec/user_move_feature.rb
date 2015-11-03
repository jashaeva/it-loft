#!/bin/env ruby
# encoding: utf-8
require "pry"

require_relative '../spec/spec_helper'
require_relative '../spec/commons/useful_func'
require_relative '../spec/commons/UserAddEvent'
require_relative '../spec/commons/AdminPanelRequests'
require_relative '../spec/commons/LoginPage'
require_relative '../spec/commons/MoveEventPage'

describe "Create and Move event. Delete after all." do
  ev_ID = ""
 
  before (:all) do    
    page = LoginPage.new(browser, true)     
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
        buttonAccept.click        
        break
      end
    end
    logout()   
  end

  describe "Move event" do

    context "dates" do
      before (:all) do
        page = LoginPage.new(browser, true)          
        page.login_with('funnicaplanit@yandex.ru', '12345')              
        Watir::Wait.until{ browser.url == TEST_URL }
        browser.goto "http://sevenbits:10ytuhbnzn@itlft.7bits.it/user-event/move/#{ev_ID}"
      end
      
      it 'Start date can not be empty ' do         
        page = MoveEventPage.new(browser)
        page.eventEndDate_element.when_visible
        page.eventEndDate_element.click
        page.next_month_e       
        page.next_day(2)
        page.choose_hour(20)
        page.choose_minute(3)
        page.sendRequest
        expect( page.errorDate !="").to be_truthy      
      end

      it 'End date can not be empty ' do
        page = MoveEventPage.new(browser)
        page.eventStartDate_element.when_visible
        page.eventStartDate_element.click
        page.next_month_s       
        page.next_day(2)
        page.choose_hour(20)
        page.choose_minute(3)
        page.sendRequest
        expect( page.errorDate !="").to be_truthy            
      end
    
      it 'If startDate===endDate' do
        page = MoveEventPage.new(browser)
        page.eventEndDate_element.when_visible
        page.eventEndDate_element.click
        page.next_month_e
        page.next_month_e
        page.next_day(2)
        page.choose_hour(20)
        page.choose_minute(3)
        page.eventStartDate_element.click
        page.next_month_s
        page.next_month_s
        page.next_day(2)
        page.choose_hour(20)
        page.choose_minute(3)
        page.sendRequest         
        expect( page.errorDate !="").to be_truthy  
      end

      it 'Start date should be less than end date' do
        page = MoveEventPage.new(browser)
        page.eventEndDate_element.when_visible
        page.eventEndDate_element.click
        page.next_month_e
        page.next_month_e
        page.next_day(2)
        page.choose_hour(20)
        page.choose_minute(3)        
        page.eventStartDate_element.click
        page.next_month_s
        page.next_month_s
        page.next_day(4)
        page.choose_hour(10)
        page.choose_minute(3)
        page.sendRequest      
        expect( page.errorDate !="").to be_truthy  
      end

      after (:all) do
        logout()
      end
    end
    
    context "transferComment" do
      before (:all) do
        page = LoginPage.new(browser, true)          
        page.login_with('funnicaplanit@yandex.ru', '12345')              
        Watir::Wait.until{ browser.url == TEST_URL }
        browser.goto "http://sevenbits:10ytuhbnzn@itlft.7bits.it/user-event/move/#{ev_ID}"
      end
      
      it "transferComment not empty" do
        page = MoveEventPage.new(browser)
        page.transferComment = ""
        page.sendRequest
        expect( page.errorComment !="").to be_truthy
      end
      it "transferComment short enough (512)" do
        page = MoveEventPage.new(browser)
        page.transferComment = str(511)
        page.sendRequest
        expect( page.errorComment !="").to be_falsey
      end
      it "transferComment can't be too long (513)" do
        page = MoveEventPage.new(browser)
        page.transferComment = str(512)
        page.sendRequest
        expect( page.errorComment !="").to be_truthy
      end
      it "move event" do
        page = MoveEventPage.new(browser)
        page.default()
        expect( page.errorComment !="").to be_falsey
        expect( page.errorDate !="").to be_falsey        
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