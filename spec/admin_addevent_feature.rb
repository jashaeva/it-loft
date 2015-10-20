#!/bin/env ruby
# encoding: utf-8
require "pry"

require_relative '../spec/spec_helper'

require_relative '../spec/commons/AdminAddEventPage'
require_relative '../spec/commons/AdminPanelRequests'
require_relative '../spec/commons/AdminPanelEvents'
require_relative '../spec/commons/LoginPage'

describe "AddEvent from AdminPanel" do
 
  before (:all) do       
    page = LoginPage.new(browser, true)
    browser.refresh
    page.login_with('admin@itlft.omsk', 'admin' )
    Watir::Wait.until { browser.url == 'http://itlft.7bits.it/admin/requests' }    
  end
  
  context "EventTitle?" do
    it "non-empty?" do        
      page = AdminAddEventPage.new(browser, true)
      browser.refresh
      page.eventTitle_element.when_visible      
      page.eventTitle = ""
      page.sendRequest
      expect(page.errorTitle_element.text !="").to be_truthy
    end
    it " str = 'Z' " do
      page = AdminAddEventPage.new(browser, true)      
      page.eventTitle = "Z"
      page.sendRequest
      expect(page.errorTitle_element.text !="").to be_falsey
    end
    it " str = 'Я' " do
      page = AdminAddEventPage.new(browser, true)      
      page.eventTitle = "Я"
      page.sendRequest
      expect(page.errorTitle_element.text !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = AdminAddEventPage.new(browser, true)      
      page.eventTitle = "Zфыпававав"
      page.sendRequest
      expect(page.errorTitle_element.text !="").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = AdminAddEventPage.new(browser, true)      
      page.eventTitle = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      expect(page.errorTitle_element.text !="").to be_falsey
    end
    it "str(256)" do
      page = AdminAddEventPage.new(browser, true)
      page.eventTitle = str(255)
      page.sendRequest
      expect(page.errorTitle_element.text !="").to be_falsey
    end
    it "str(257)" do
      page = AdminAddEventPage.new(browser, true)
      page.eventTitle = str(256)
      page.sendRequest
      expect(page.errorTitle_element.text !="").to be_truthy
    end
  end  

  context "EventDescription?" do
    it "non-empty?" do
      page = AdminAddEventPage.new(browser, true)
      browser.refresh
      page.eventDescription_element.when_visible      
      page.eventDescription = ""
      page.sendRequest
      expect(page.errorDescription_element.text !="").to be_falsey
    end
    it " str = 'Z' " do
      page = AdminAddEventPage.new(browser, true)      
      page.eventDescription = "Z"
      page.sendRequest
      expect(page.errorDescription_element.text !="").to be_falsey
    end
    it " str = 'Я' " do
      page = AdminAddEventPage.new(browser, true)      
      page.eventDescription = "Я"
      page.sendRequest
      expect(page.errorDescription_element.text !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = AdminAddEventPage.new(browser, true)      
      page.eventDescription = "Zфыпававав"
      page.sendRequest
      expect(page.errorDescription_element.text !="").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = AdminAddEventPage.new(browser, true)      
      page.eventDescription = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      expect(page.errorDescription_element.text !="").to be_falsey
    end
    it "str(512)" do
      page = AdminAddEventPage.new(browser, true)
      page.eventDescription = str(511)
      page.sendRequest
      expect(page.errorDescription_element.text !="").to be_falsey
    end
    it "str(513)" do
      page = AdminAddEventPage.new(browser, true)
      page.eventDescription = str(512)
      page.sendRequest
      expect(page.errorDescription_element.text !="").to be_truthy
    end
  end  
  
  context 'URL?' do
    
    it 'Positive URL examples' do
      page = AdminAddEventPage.new(browser, true)           
      urls = File.readlines("test_data/good_url.txt")      
      aggregate_failures("good_url") do
        urls.each do |url|
          page.eventReference = url
          page.sendRequest           
          expect(page.errorReference !="").to be_falsey
        end
      end          
    end  

    it 'Negative URL examples' do
      page = AdminAddEventPage.new(browser, true)           
      urls = File.readlines("test_data/bad_url.txt")      
      aggregate_failures("bad_url") do
        urls.each do |url|
          page.eventReference = url
          page.sendRequest          
          Watir::Wait.until{ page.errorReference != ""}
        end
      end      
    end
  end

  context "Dates of event"  do  
    it 'Start date can not be empty ' do
      page = AdminAddEventPage.new(browser, true)
      browser.refresh
      page.eventEndDate_element.when_visible
      page.eventEndDate_element.click
      page.next_month_e       
      page.next_day(2)
      page.choose_hour(20)
      page.choose_minute(3)
      page.sendRequest      
      expect( page.errorDate_element.text !="").to be_truthy            
    end

    it 'End date can not be empty ' do
      page = AdminAddEventPage.new(browser, true)
      browser.refresh              
      page.eventStartDate_element.when_visible
      page.eventStartDate_element.click
      page.next_month_s       
      page.next_day(2)
      page.choose_hour(20)
      page.choose_minute(3)
      page.sendRequest      
      expect( page.errorDate_element.text !="").to be_truthy            
    end
  
    it 'If startDate===endDate' do
      page = AdminAddEventPage.new(browser, true)
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
      expect( page.errorDate_element.text !="").to be_truthy  
    end

    it 'Start date should be less than end date' do
      page = AdminAddEventPage.new(browser, true)
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
      expect( page.errorDate_element.text !="").to be_truthy  
    end
  end

  context "CheckBox Enabled" do
    it "Check Enabled = true" do        
      page = AdminAddEventPage.new(browser, true)
      page.default()    
      page = AdminPanelRequests.new(browser,true)
      expect( browser.text.include? "New Year celebration event").to be_falsey        
      page = AdminPanelEvents.new(browser,true)
      expect( browser.text.include? "New Year celebration event").to be_truthy
      divRequests = browser.divs(class: "row bordered-bottom admin-event-padding")
      divRequests.each do |request|
        if request.div(class: "text-20 orange").text == "New Year celebration event"
          buttonDelete = request.button(class: "js-btn-ev btn btn-xs btn-blue admin-btn-margin")
          buttonDelete.click
          Watir::Wait.until { browser.alert.exists? }
          browser.alert.ok
          break
        end
      end        
    end

    it "Check Enabled = false" do
      browser.refresh
      page = AdminAddEventPage.new(browser, true)      
      page.default_no()
      page = AdminPanelEvents.new(browser,true)
      expect( browser.text.include? "New Year celebration event").to be_falsey
      page = AdminPanelRequests.new(browser,true)
      expect( browser.text.include? "New Year celebration event").to be_truthy              
      divRequests = browser.divs(class: "row requests-block")
      divRequests.each do |request|
        if request.div(class: "text-20 orange").text == "New Year celebration event"
          buttonDelete = request.button(class: "js-btn-ev btn btn-xs btn-blue admin-btn-margin")  
          buttonDelete.click
          Watir::Wait.until { browser.alert.exists? }
          browser.alert.ok
          break
        end
      end
    end 
  end

  after (:all) do
   logout() 
 end
end