#!/bin/env ruby
# encoding: utf-8

require_relative '../spec/spec_helper'
require_relative '../spec/commons/HomePageShort'
require_relative '../spec/commons/LoginPage'


describe "RequestForEvent, short form" do
 
  before (:all) do   
    
    page = LoginPage.new(browser, true)    
    page.username_element.when_visible
    page.username = 'funnicaplanit@yandex.ru'
    page.password = '12345'
    page.submit

    # Watir::Wait.until { browser.url == 'http://itlft.7bits.it/' }
    # STDERR.puts "URL = " + browser.url    
  end
  
  context "EventTitle?" do
    it "non-empty?" do      
      page = HomePageShort.new(browser, true)      
      page.eventTitle_element.when_visible      
      page.eventTitle = ""
      page.sendRequest
      expect(page.errorTitle !="").to be_truthy
    end
    it " str = 'Z' " do
      page = HomePageShort.new(browser, true)      
      page.eventTitle = "Z"
      page.sendRequest
      expect(page.errorTitle !="").to be_falsey
    end
    it " str = 'Я' " do
      page = HomePageShort.new(browser, true)      
      page.eventTitle = "Я"
      page.sendRequest
      expect(page.errorTitle !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = HomePageShort.new(browser, true)      
      page.eventTitle = "Zфыпававав"
      page.sendRequest
      expect(page.errorTitle !="").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = HomePageShort.new(browser, true)      
      page.eventTitle = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      expect(page.errorTitle !="").to be_falsey
    end
    it "str(256)" do
      page = HomePageShort.new(browser, true)
      page.eventTitle = str(255)
      page.sendRequest
      expect(page.errorTitle !="").to be_falsey
    end
    it "str(257)" do
      page = HomePageShort.new(browser, true)
      page.eventTitle = str(256)
      page.sendRequest
      expect(page.errorTitle !="").to be_truthy
    end
  end  

  context "EventDescription?" do
    it "non-empty?" do
      page = HomePageShort.new(browser, true)
      browser.refresh
      page.wait_until(15, "Call not returned within 15 seconds" ) do
        page.eventDescription?
      end
      page.eventDescription = ""
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end
    it " str = 'Z' " do
      page = HomePageShort.new(browser, true)      
      page.eventDescription = "Z"
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end
    it " str = 'Я' " do
      page = HomePageShort.new(browser, true)      
      page.eventDescription = "Я"
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = HomePageShort.new(browser, true)      
      page.eventDescription = "Zфыпававав"
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = HomePageShort.new(browser, true)      
      page.eventDescription = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end
    it "str(512)" do
      page = HomePageShort.new(browser, true)
      page.eventDescription = str(511)
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end
    it "str(513)" do
      page = HomePageShort.new(browser, true)
      page.eventDescription = str(512)
      page.sendRequest
      expect(page.errorDescription !="").to be_truthy
    end
  end  
  
  context 'URL?' do
    # before (:all)  do
    #   $stdout = File.open("test_data/url_output", "a")
    #   puts "Start testing urls **********"
    # end

    it 'Positive URL examples' do
      page = HomePageShort.new(browser, true)       
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
      urls = File.readlines("test_data/bad_url.txt")      
      aggregate_failures("bad_url") do
        urls.each do |url|
          page = HomePageShort.new(browser, true)
          page.eventReference = url
          page.sendRequest       
          Watir::Wait.until{ page.errorReference != ""}            
        end
      end      
    end   
  end

  context "Dates of event"  do
    
    it 'Start date can not be empty ' do
      page = HomePageShort.new(browser, true)
     
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
      page = HomePageShort.new(browser, true)
   
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
      page = HomePageShort.new(browser, true)
 
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
      page = HomePageShort.new(browser, true)
      
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
  end
  
  after (:all) do
    logout()
  end
end