#!/bin/env ruby
# encoding: utf-8
require "pry"
require "rspec/expectations"

require_relative '../spec/spec_helper'
# require_relative '../spec/commons/roots'
require_relative '../spec/commons/useful_func'


require_relative '../spec/commons/AdminAddEventPage'
require_relative '../spec/commons/AdminEditCreatorPage'
require_relative '../spec/commons/AdminEditEventPage'
require_relative '../spec/commons/AdminPanelRequests'
require_relative '../spec/commons/AdminPanelEvents'
require_relative '../spec/commons/LoginPage'


describe "Edit Creator Page" do
  hRef = nil
  hRefEv = nil
  page = nil

  before (:all) do  
    page = LoginPage.new(browser, true)    
    page.login_with( "admin@itlft.omsk", "admin" )   
    Watir::Wait.until{ browser.url == 'http://itlft.7bits.it/admin/requests' }    
   
    page = AdminAddEventPage.new(browser, true)
    page.sendRequest_element.when_visible
    page.default()     
    page = AdminPanelEvents.new(browser, true)     
    Watir::Wait.until{ browser.url == 'http://itlft.7bits.it/admin/events'}

    divEvents = browser.divs(class: "row bordered-bottom admin-event-padding")
    divEvents.each do |event|
      if event.div(class: "text-20 orange").text == "New Year celebration event"                        
        btnEdit = event.div(class: "col-xs-12 col-sm-3 admin-btn-margin-top").links[0]
        hRefEv = btnEdit.attribute_value("href")
        btnEdit = event.div(class: "col-xs-12 col-sm-3 admin-btn-margin-top").links[1]
        hRef = btnEdit.attribute_value("href")        
        break
      end
    end   
  end
  
  context "RequesterName?" do    
    before (:each) do      
      if (browser.url != hRef)
        browser.goto hRef
      else
        browser.refresh
      end
      page = AdminEditCreatorPage.new(browser)    
      page.name_element.when_present
      page.sendRequest_element.when_present            
    end

    it "non-empty?" do        
      page.name = ""
      page.sendRequest      
      expect(page.result == "").to be_truthy
      page.errorName_element.when_present
      expect(page.errorName !="").to be_truthy
    end
    it " str = 'Z' " do      
      page.name = "Z"
      page.sendRequest
      page.result_element.when_visible      
      expect(page.success && page.errorName =="").to be_truthy      
    end
    it " str = 'Я' " do
      page.name = "Я"
      page.sendRequest
      page.result_element.when_visible      
      expect(page.success && page.errorName =="").to be_truthy
    end
    it " str = 'Zфыпававав' " do
      page.name = "Zфыпававав"
      page.sendRequest
      page.result_element.when_visible      
      expect(page.success && page.errorName =="").to be_truthy
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page.name = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest      
      page.result_element.when_visible      
      expect(page.success && page.errorName =="").to be_truthy
    end
    it "strlen = 256" do
      page.name_element.clear
      page.name = str(255)    
      page.sendRequest
      page.result_element.when_visible      
      expect(page.success && page.errorName =="").to be_truthy
    end
    it "str(257)" do
      page.name = str(256)
      page.sendRequest
      expect(page.result == "").to be_truthy
      page.errorName_element.when_present
      expect(page.errorName !="").to be_truthy
    end
    it 'restore old value' do    
      page.name = "Mister Twister Administrator"
      page.sendRequest
      page.result_element.when_visible      
      expect(page.success && page.errorName =="").to be_truthy
    end
  end  

  context "RequesterEmail? " do    
    
    it 'Positive email examples' do   
      emails = File.readlines("test_data/good_emails.txt")      
      aggregate_failures("good_emails") do
        emails.each do |email|
          browser.goto hRef          
          page = AdminEditCreatorPage.new(browser)
          page.email_element.when_visible                
          page.email = email          
          page.sendRequest  
          page.result_element.when_visible          
          expect(page.success && page.errorEmail == "").to be_truthy
        end
      end
    end    

    it 'Negative email examples' do      
      emails = File.readlines("test_data/bad_emails.txt")      
      aggregate_failures("bad_emails") do        
        emails.each do |email|          
          browser.goto hRef         
          page = AdminEditCreatorPage.new(browser)        
          page.email_element.when_visible
          page.email = email          
          page.sendRequest
          expect(page.result == "").to be_truthy  
          page.errorEmail_element.when_present 
          expect(page.errorEmail !="").to be_truthy 
        end
      end
    end

    it "restore old value" do
      browser.goto hRef         
      page = AdminEditCreatorPage.new(browser)     
      page.email_element.when_visible
      page.email = 'admin@itlft.omsk'
      page.sendRequest                        
      page.result_element.when_visible
      expect(page.success && page.errorEmail =="").to be_truthy
    end
  end


  context "Phone number?" do
    before (:each) do     
      if (browser.url != hRef)
        browser.goto hRef
      else
        browser.refresh
      end
      page = AdminEditCreatorPage.new(browser)    
      page.phone_element.when_present
      page.sendRequest_element.when_present            
    end

    it "strlen = 256" do
      page.phone = str(255)    
      page.sendRequest      
      page.result_element.when_visible
      expect(page.success && page.errorPhone =="").to be_truthy
    end
    it "str(257)" do
      page.phone = str(256)
      page.sendRequest
      expect(page.result == "").to be_truthy  
      page.errorPhone_element.when_present
      expect(page.errorPhone_element.text !="").to be_truthy
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