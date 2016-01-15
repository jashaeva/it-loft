#!/bin/env ruby
# encoding: utf-8
require "pry"
require "rspec/expectations"

require_relative '../spec/spec_helper'

require_relative '../spec/commons/AdminAddEventPage'
require_relative '../spec/commons/AdminEditCreatorPage'
require_relative '../spec/commons/AdminEditEventPage'
require_relative '../spec/commons/AdminPanelRequests'
require_relative '../spec/commons/AdminPanelEvents'
require_relative '../spec/commons/LoginPage'


describe "Edit Creator Page" do
  hRef = nil
  hRefEv = nil

  before (:all) do
  
    page = LoginPage.new(browser, true)
    page.username_element.when_visible    
    page.login_with( "admin@itlft.omsk", "admin" )   
    Watir::Wait.until{ browser.url == 'http://itlft.7bits.it/admin/requests' }    
   # STDERR.puts "***1"
    page = AdminAddEventPage.new(browser, true)
    Watir::Wait.until{ browser.url == 'http://itlft.7bits.it/admin/event' }    

    page.default()   
  # STDERR.puts "***2 default"
    page = AdminPanelEvents.new(browser, true)     
    Watir::Wait.until{ browser.url == 'http://itlft.7bits.it/admin/events'}
  # STDERR.puts "***3 hRef"
    divEvents = browser.divs(class: "row bordered-bottom admin-event-padding")
    divEvents.each do |event|
      if event.div(class: "text-20 orange").text == "New Year celebration event"                        
        btnEdit = event.div(class: "col-xs-12 col-sm-3 admin-btn-margin-top").links[0]
        hRefEv = btnEdit.attribute_value("href")
        btnEdit = event.div(class: "col-xs-12 col-sm-3 admin-btn-margin-top").links[1]
        hRef = btnEdit.attribute_value("href")
        # STDERR.puts "*** hRef = " + hRef
        btnEdit.click
        browser.wait_until{browser.button(id: "js-submit-rq").exists?}
        # STDERR.puts "*** wait_until"
        break
      end
    end            
  end
  
  context "RequesterName?" do    
    before (:each) do      
      browser.goto hRef if (browser.url != hRef)
    end

    it "non-empty?" do        
      page = AdminEditCreatorPage.new(browser)    
      page.name_element.when_visible      
      page.name = ""
      page.sendRequest      
      expect(page.errorName !="").to be_truthy
    end
    it " str = 'Z' " do
      page = AdminEditCreatorPage.new(browser )      
      page.name = "Z"
      page.sendRequest
      expect(page.errorName !="").to be_falsey
    end
    it " str = 'Я' " do
      page = AdminEditCreatorPage.new(browser)      
      page.name = "Я"
      page.sendRequest
      expect(page.errorName !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = AdminEditCreatorPage.new(browser)      
      page.name = "Zфыпававав"
      page.sendRequest
      expect(page.errorName !="").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = AdminEditCreatorPage.new(browser)      
      page.name = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest      
      expect(page.errorName !="").to be_falsey
    end
    it "strlen = 256" do
      page = AdminEditCreatorPage.new(browser)
      browser.refresh      
      page.name_element.when_visible
      page.name_element.clear
      page.name = str(255)    
      page.sendRequest_element.when_visible
      page.sendRequest
      expect(page.errorName !="").to be_falsey
    end
    it "str(257)" do
      page = AdminEditCreatorPage.new(browser)
      page.name = str(256)
      page.sendRequest
      expect(page.errorName !="").to be_truthy
    end

    it 'restore old value' do
      page = AdminEditCreatorPage.new(browser)
      page.name_element.clear      
      page.name = "Mister Twister Administrator"
      page.sendRequest
      expect(page.errorName !="").to be_falsey
    end
  end  

  context "RequesterEmail? " do    
    before (:each) do     
      browser.goto hRef if (browser.url != hRef)
    end

    it 'Positive email examples' do   
      emails = File.readlines("test_data/good_emails.txt")      
      aggregate_failures("good_emails") do
        emails.each do |email|
          browser.goto hRef          
          page = AdminEditCreatorPage.new(browser)
          page.email_element.when_visible                
          page.email = email          
          page.sendRequest  
          page.errorEmail_element.when_visible          
          expect(page.errorEmail != "").to be_falsey
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
          page.errorEmail_element.when_visible 
          expect(page.errorEmail !="").to be_truthy 
        end
      end
    end

    it "restore old value" do
      page = AdminEditCreatorPage.new(browser)     
      page.email_element.when_visible
      page.email = 'admin@itlft.omsk'
      page.sendRequest                                  
      expect(page.errorEmail !="").to be_falsey
    end
  end


  context "Phone number?" do
    before (:each) do      
      browser.goto hRef if (browser.url != hRef)
    end
    it "strlen = 256" do
      page = AdminEditCreatorPage.new(browser)
      browser.refresh      
      page.phone_element.when_visible
      page.phone_element.clear
      page.phone = str(255)    
      page.sendRequest_element.when_visible
      page.sendRequest
      expect(page.errorPhone_element.text !="").to be_falsey
    end
    it "str(257)" do
      page = AdminEditCreatorPage.new(browser)
      page.phone = str(256)
      page.sendRequest
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