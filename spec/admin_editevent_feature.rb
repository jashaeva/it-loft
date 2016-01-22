#!/bin/env ruby
# encoding: utf-8
require "pry"

require_relative '../spec/spec_helper'
require_relative '../spec/commons/useful_func'

require_relative '../spec/commons/AdminAddEventPage'
require_relative '../spec/commons/AdminEditEventPage'
require_relative '../spec/commons/AdminPanelRequests'
require_relative '../spec/commons/AdminPanelEvents'
require_relative '../spec/commons/LoginPage'


describe "Edit Event from AdminPanel" do
  hRef = nil
  page = nil

  before (:all) do          
    page = LoginPage.new(browser, true)
    page.login_with("admin@itlft.omsk", "admin" )    
    Watir::Wait.until { browser.url == 'http://itlft.7bits.it/admin/requests' }    

    page = AdminAddEventPage.new(browser, true)    
    page.default()     
    page = AdminPanelEvents.new(browser, true)     
    Watir::Wait.until{browser.url == 'http://itlft.7bits.it/admin/events'}

    divEvents = browser.divs(class: "row bordered-bottom admin-event-padding")
    divEvents.each do |event|
      if event.div(class: "text-20 orange").text == "New Year celebration event"                        
        btnEdit = event.div(class: "col-xs-12 col-sm-3 admin-btn-margin-top").links[0]
        hRef = btnEdit.attribute_value("href")               
        break
      end
    end        
  end
  
  context "EventTitle?" do
    before (:each) do 
      if (browser.url != hRef)
        browser.goto hRef
      else
        browser.refresh
      end
      page = AdminEditEventPage.new(browser)    
      page.eventTitle_element.when_present      
      page.sendRequest_element.when_present      
    end

    it "non-empty?" do                   
      page.eventTitle = ""
      page.sendRequest                  
      expect(page.result == "").to be_truthy
      page.errorTitle_element.when_present                  
      expect(page.errorTitle !="").to be_truthy
    end

    it " str = 'Z' " do
      page.eventTitle = "Z"
      page.sendRequest
      page.result_element.when_visible
      expect(page.success && page.errorTitle =="").to be_truthy
    end
    it " str = 'Я' " do
      page.eventTitle = "Я"
      page.sendRequest    
      page.result_element.when_visible
      expect(page.success && page.errorTitle =="").to be_truthy
    end
    it " str = 'Zфыпававав' " do
      page.eventTitle = "Zфыпававав"
      page.sendRequest   
      page.result_element.when_visible 
      expect(page.success && page.errorTitle =="").to be_truthy
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page.eventTitle = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      page.result_element.when_visible
      expect(page.success && page.errorTitle =="").to be_truthy
    end
    it "strlen = 256" do
      page.eventTitle = str(255)              
      page.sendRequest
      page.result_element.when_visible
      STDERR.puts  page.result + " / " + page.errorTitle
      expect(page.success && page.errorTitle =="").to be_truthy
    end
    it "str(257)" do
      page.eventTitle = str(256)
      page.sendRequest      
      # page.result_element.when_visible
      page.errorTitle_element.when_present      
      expect(page.result == "" && page.errorTitle !="").to be_truthy
    end
    it 'restore old value' do
      page.eventTitle = "New Year celebration event"
      page.sendRequest
      page.result_element.when_visible
      expect(page.success && page.errorTitle =="").to be_truthy
    end
   end  

  context "EventDescription?" do
    before (:each) do      
      if (browser.url != hRef)
        browser.goto hRef
      else
        browser.refresh
      end
      page = AdminEditEventPage.new(browser)    
      page.eventDescription_element.when_present      
      page.sendRequest_element.when_present      
    end

    it " str = 'Z' " do
      page.eventDescription = "Z"
      page.sendRequest
      page.result_element.when_visible
      expect(page.success && page.errorDescription =="").to be_truthy
    end
    it " str = 'Я' " do
      page.eventDescription = "Я"
      page.sendRequest
      page.result_element.when_visible
      expect(page.success && page.errorDescription =="").to be_truthy
    end
    it " str = 'Zфыпававав' " do      
      page.eventDescription = "Zфыпававав"
      page.sendRequest
      page.result_element.when_visible
      expect(page.success && page.errorDescription =="").to be_truthy
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page.eventDescription = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      page.result_element.when_visible
      expect(page.success && page.errorDescription =="").to be_truthy      
    end
    it "str(512)" do
      page.eventDescription = str(511)    
      page.sendRequest
      page.result_element.when_visible
      expect(page.success && page.errorDescription =="").to be_truthy      
    end
    it "str(513)" do      
      page.eventDescription = str(512)
      page.sendRequest
      expect(page.result == "").to be_truthy
      page.errorDescription_element.when_present                  
      expect(page.errorDescription !="").to be_truthy            
    end
    it 'restore old value' do
      page.eventDescription = "Just description of the event."
      page.sendRequest
      page.result_element.when_visible      
      expect(page.success && page.errorDescription =="").to be_truthy      
    end
  end  
  
  context 'URL?' do    
    
    it 'Positive URL examples' do   
      page = AdminEditEventPage.new(browser)                 
      urls = File.readlines("test_data/good_url.txt")      
      aggregate_failures("good_url") do
        urls.each do |url|                             
          browser.refresh   
          page.eventReference_element.when_visible
          page.eventReference = url
          page.sendRequest          
          page.errorReference_element.when_present
          Watir::Wait.until{ page.errorReference =="" }
        end
      end          
    end  

    it 'Negative URL examples' do   
      page = AdminEditEventPage.new(browser)
      urls = File.readlines("test_data/bad_url.txt")      
      aggregate_failures("bad_url") do
        urls.each do |url|
          browser.refresh          
          page.eventReference_element.when_visible
          page.eventReference = url
          page.sendRequest
          page.errorReference_element.when_present          
          Watir::Wait.until{ page.errorReference !="" }
        end
      end      
    end
  end

  context "Dates of event"  do  
    before (:each) do
      if (browser.url != hRef)
        browser.goto hRef
      else
        browser.refresh
      end
      page = AdminEditEventPage.new(browser)    
      page.sendRequest_element.when_present      
    end
        
    it 'If startDate===endDate' do      
      page.eventEndDate_element.when_visible.click      
      page.next_month_e
      page.next_month_e
      page.next_day(2)
      page.choose_hour(20)
      page.choose_minute(3)

      page.eventStartDate_element.when_visible.click
      page.next_month_s
      page.next_month_s
      page.next_day(2)
      page.choose_hour(20)
      page.choose_minute(3)
      page.sendRequest            
      expect(page.result == "").to be_truthy      
      page.errorDate_element.when_present
      expect( page.errorDate !="").to be_truthy  
    end

    it 'Start date should be less than end date' do      
      page.eventEndDate_element.when_visible.click      
      page.next_month_e
      page.next_month_e
      page.next_day(2)
      page.choose_hour(20)
      page.choose_minute(3)
      
      page.eventStartDate_element.when_visible.click
      page.next_month_s
      page.next_month_s
      page.next_day(4)
      page.choose_hour(10)
      page.choose_minute(3)
      page.sendRequest            
      expect(page.result == "").to be_truthy
      page.errorDate_element.when_present
      expect( page.errorDate !="").to be_truthy  
    end
  end

  context "CheckBox Enabled" do
    before (:each) do      
      if (browser.url != hRef)
        browser.goto hRef
      else
        browser.refresh
      end
      page = AdminEditEventPage.new(browser)    
      page.enabled_element.when_present
      page.sendRequest_element.when_present   
    end

    it "Check Enabled == true" do             
      page.check_enabled
      page.sendRequest 
      page = AdminPanelRequests.new(browser, true)
      Watir::Wait.until{ browser.url ==  'http://itlft.7bits.it/admin/requests' }
      expect( browser.text.include? "New Year celebration event").to be_falsey        
      
      page = AdminPanelEvents.new(browser, true)
      Watir::Wait.until{ browser.url == 'http://itlft.7bits.it/admin/events' }
      expect( browser.text.include? "New Year celebration event").to be_truthy      
    end

    it "Check Enabled == false" do 
      page.uncheck_enabled
      page.sendRequest      
      
      page = AdminPanelEvents.new(browser, true)            
      browser.link(href: "http://itlft.7bits.it/admin/events/1").when_present
      expect( browser.text.include? "New Year celebration event").to be_falsey

      page = AdminPanelRequests.new(browser, true)      
      browser.link(href: "http://itlft.7bits.it/admin/requests/1").when_present
      expect( browser.text.include? "New Year celebration event").to be_truthy                    
    end 
  end

  after (:all) do    
    page = AdminPanelEvents.new(browser, true)    
    divReq = browser.divs(class: "row bordered-bottom admin-event-padding")
      divReq.each do |event|
        if event.div(class: "text-20 orange").text == "New Year celebration event"          
          btnDel = event.button(class: "js-btn-ev btn btn-xs btn-blue admin-btn-margin")
          btnDel.click
          Watir::Wait.until { browser.alert.exists? }
          browser.alert.ok
          browser.element(text: "New Year celebration event").wait_while_present 
          break
        end
      end        
    page = AdminPanelRequests.new(browser, true)    
    divReq = browser.divs(class: "row requests-block")  
      divReq.each do |event|                    
        if event.div(class: "col-xs-12 col-sm-7 request-padding").div(class: "text-20 orange").text == "New Year celebration event"                    
          btnDel = event.div(class: "col-xs-12 col-sm-2 admin-btn-margin-top").button(class: "js-btn-ev btn btn-xs btn-blue admin-btn-margin")
          btnDel.click
          Watir::Wait.until { browser.alert.exists? }
          browser.alert.ok
          browser.element(text: "New Year celebration event").wait_while_present 
          break
        end
      end          
    logout() 
  end
end