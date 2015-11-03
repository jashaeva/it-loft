#!/bin/env ruby
# encoding: utf-8
require "pry"

require_relative '../spec/spec_helper'
require_relative '../spec/commons/UserAddEvent'
require_relative '../spec/commons/LoginPage'

describe "RequestForEvent (user-request), short form" do
 
  before (:all) do       
    page = LoginPage.new(browser, true)
    browser.refresh
    page.username_element.when_visible
    page.username = 'funnicaplanit@yandex.ru'
    page.password = '12345'
    page.submit
    Watir::Wait.until { browser.url == TEST_URL }
  end
  
  context "EventTitle?" do
    it "non-empty?" do      
      page = UserAddEventPage.new(browser, true)
      browser.refresh
      page.eventTitle_element.when_visible      
      page.eventTitle = ""
      page.sendRequest
      expect(page.errorTitle != "").to be_truthy
    end
    it " str = 'Z' " do
      page = UserAddEventPage.new(browser, true)      
      page.eventTitle = "Z"
      page.sendRequest
      expect(page.errorTitle != "").to be_falsey
    end
    it " str = 'Я' " do
      page = UserAddEventPage.new(browser, true)      
      page.eventTitle = "Я"
      page.sendRequest
      expect(page.errorTitle != "").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = UserAddEventPage.new(browser, true)      
      page.eventTitle = "Zфыпававав"
      page.sendRequest
      expect(page.errorTitle != "").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = UserAddEventPage.new(browser, true)      
      page.eventTitle = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      expect(page.errorTitle != "").to be_falsey
    end
    it "str(256)" do
      page = UserAddEventPage.new(browser, true)
      page.eventTitle = str(255)
      page.sendRequest
      expect(page.errorTitle != "").to be_falsey
    end
    it "str(257)" do
      page = UserAddEventPage.new(browser, true)
      page.eventTitle = str(256)
      page.sendRequest
      expect(page.errorTitle != "").to be_truthy
    end
  end  

  context "EventDescription?" do
    it "non-empty?" do
      page = UserAddEventPage.new(browser, true)
      browser.refresh
      page.wait_until(15, "Call not returned within 15 seconds" ) do
        page.eventDescription?
      end
      page.eventDescription = ""
      page.sendRequest
      expect(page.errorDescription != "").to be_falsey
    end
    it " str = 'Z' " do
      page = UserAddEventPage.new(browser, true)      
      page.eventDescription = "Z"
      page.sendRequest
      expect(page.errorDescription != "").to be_falsey
    end
    it " str = 'Я' " do
      page = UserAddEventPage.new(browser, true)      
      page.eventDescription = "Я"
      page.sendRequest
      expect(page.errorDescription != "").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = UserAddEventPage.new(browser, true)      
      page.eventDescription = "Zфыпававав"
      page.sendRequest
      expect(page.errorDescription != "").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = UserAddEventPage.new(browser, true)      
      page.eventDescription = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      expect(page.errorDescription != "").to be_falsey
    end
    it "str(512)" do
      page = UserAddEventPage.new(browser, true)
      page.eventDescription = str(511)
      page.sendRequest
      expect(page.errorDescription != "").to be_falsey
    end
    it "str(513)" do
      page = UserAddEventPage.new(browser, true)
      page.eventDescription = str(512)
      page.sendRequest
      expect(page.errorDescription != "").to be_truthy
    end
  end  
  
  context 'URL?' do
    
    it 'Positive URL examples' do
      page = UserAddEventPage.new(browser, true)             
      urls = File.readlines("test_data/good_url.txt")      
      aggregate_failures("good_url") do
        urls.each do |url|   
          browser.refresh       
          page.eventReference = url
          page.sendRequest          
          Watir::Wait.until{ page.errorReference =="" }
          expect(page.errorReference =="").to be_truthy
        end
      end
    end  

    it 'Negative URL examples' do
      page = UserAddEventPage.new(browser, true)      
      urls = File.readlines("test_data/bad_url.txt")      
      aggregate_failures("bad_url") do
        urls.each do |url|
          browser.refresh
          page.eventReference = url
          page.sendRequest      
          Watir::Wait.until{ page.errorReference !="" }
        end
      end      
    end
  end

context "Dates of event"  do
  
      it 'Start date can not be empty ' do
        page = UserAddEventPage.new(browser, true)
        browser.refresh
          page.eventEndDate_element.when_visible
          page.eventEndDate_element.click
          page.next_month_e       
          page.next_day(2)
          page.choose_hour(20)
          page.choose_minute(3)
          page.sendRequest
          page.save_screenshot "test_data/screenshots/endDate.png"
          expect( page.errorDate != "").to be_truthy            
      end

      it 'End date can not be empty ' do
        page = UserAddEventPage.new(browser, true)
        browser.refresh      
        #binding.pry  
          page.eventStartDate_element.when_visible
          page.eventStartDate_element.click
          page.next_month_s       
          page.next_day(2)
          page.choose_hour(20)
          page.choose_minute(3)
          page.sendRequest
          page.save_screenshot "test_data/screenshots/startDate.png"
          expect( page.errorDate !="").to be_truthy            
      end
    
      it 'If startDate===endDate' do
        page = UserAddEventPage.new(browser, true)
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
        page.save_screenshot "test_data/screenshots/endDate1.png"
        expect( page.errorDate !="").to be_truthy  
      end

      it 'Start date should be less than end date' do
        page = UserAddEventPage.new(browser, true)
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
        page.save_screenshot "test_data/screenshots/endDate2.png"
        expect( page.errorDate !="").to be_truthy  

      end
    end
#Logo manually tested
end