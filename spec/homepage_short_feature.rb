#!/bin/env ruby
# encoding: utf-8
require 'rspec/expectations'
require 'pry'
require_relative '../spec/spec_helper'
require_relative '../spec/commons/useful_func'
require_relative '../spec/commons/HomePageShort'
require_relative '../spec/commons/LoginPage'


describe "HomePage: RequestForEvent when logged in, short form" do
  page = nil
  before (:all) do      
    page = LoginPage.new(browser, true)
    page.login_with( 'funnicaplanit@yandex.ru','12345')
    Watir::Wait.until {browser.url == "http://itlft.7bits.it/"}
  end

  context "EventTitle?" do
    before (:each) do
      page = HomePageShort.new(browser, true)      
      page.eventTitle_element.when_visible     
      page.sendRequest_element.when_present
    end

    it "non-empty?" do      
      page.eventTitle = "" 
      page.sendRequest
      page.errorTitle_element.when_present
      expect(page.errorTitle !="").to be_truthy
    end
    it " str = 'Z' " do      
      page.eventTitle = "Z"
      page.sendRequest
      page.errorTitle_element.when_present
      expect(page.errorTitle =="").to be_truthy
    end
    it " str = 'Я' " do          
      page.eventTitle = "Я"
      page.sendRequest
      page.errorTitle_element.when_present
      expect(page.errorTitle =="").to be_truthy
    end
    it " str = 'Zфыпававав' " do      
      page.eventTitle = "Zфыпававав"
      page.sendRequest
      page.errorTitle_element.when_present
      expect(page.errorTitle =="").to be_truthy
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do      
      page.eventTitle = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      page.errorTitle_element.when_present
      expect(page.errorTitle =="").to be_truthy
    end
    it "str(256)" do      
      page.eventTitle = str(255)
      page.sendRequest
      page.errorTitle_element.when_present
      expect(page.errorTitle =="").to be_truthy
    end
    it "str(257)" do
      page.eventTitle = str(256)
      page.sendRequest
      page.errorTitle_element.when_present
      expect(page.errorTitle !="").to be_truthy
    end
  end  

  context "EventDescription?" do
    before (:each) do
      page = HomePageShort.new(browser, true)      
      page.eventDescription_element.when_present            
      page.sendRequest_element.when_present
    end

    it " str = 'Z' " do    
      page.eventDescription = "Z"
      page.sendRequest
      page.errorDescription_element.when_present            
      expect(page.errorDescription =="").to be_truthy
    end
    it " str = 'Я' " do      
      page.eventDescription = "Я"
      page.sendRequest
      page.errorDescription_element.when_present            
      expect(page.errorDescription =="").to be_truthy
    end
    it " str = 'Zфыпававав' " do      
      page.eventDescription = "Zфыпававав"
      page.sendRequest
      page.errorDescription_element.when_present            
      expect(page.errorDescription =="").to be_truthy
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page.eventDescription = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      page.errorDescription_element.when_present            
      expect(page.errorDescription =="").to be_truthy
    end
    it "str(512)" do    
      page.eventDescription = str(511)
      page.sendRequest
      page.errorDescription_element.when_present            
      expect(page.errorDescription =="").to be_truthy
    end
    it "str(513)" do      
      page.eventDescription = str(512)
      page.sendRequest
      page.errorDescription_element.when_present            
      expect(page.errorDescription !="").to be_truthy
    end
  end  
  
  context 'URL?' do
    it 'Positive URL examples' do      
      urls = File.readlines("test_data/good_url.txt")      
      aggregate_failures("good_url") do
        urls.each do |url|
          page = HomePageShort.new(browser, true)       
          page.eventReference_element.when_visible
          page.eventReference = url.chomp
          page.sendRequest          
          Watir::Wait.until{ page.errorReference_element.exists? }
          expect(page.errorReference =="").to be_truthy
        end
      end          
    end  

    it 'Negative URL examples' do      
      urls = File.readlines("test_data/bad_url.txt")      
      aggregate_failures("bad_url") do
        urls.each do |url|
          page = HomePageShort.new(browser, true)       
          page.eventReference_element.when_visible
          page.eventReference = url.chomp
          page.sendRequest 
          page.wait_until do
            page.errorReference !=""
          end
        end
      end      
    end   
  end

  context "Dates of event"  do
    before (:each) do
      page = HomePageShort.new(browser, true)
      page.eventEndDate_element.when_visible
      page.eventStartDate_element.when_visible
      page.sendRequest_element.when_present
    end

    it 'Start date can not be empty ' do
      page.eventEndDate_element.click
      page.next_month_e       
      page.next_day(2)
      page.choose_hour(20)
      page.choose_minute(3)
      page.sendRequest
      page.errorDate_element.when_present
      expect( page.errorDate !="").to be_truthy            
    end

    it 'End date can not be empty ' do
      page.eventStartDate_element.click
      page.next_month_s       
      page.next_day(2)
      page.choose_hour(20)
      page.choose_minute(3)
      page.sendRequest        
      page.errorDate_element.when_present
      expect( page.errorDate !="").to be_truthy            
    end

    it 'If startDate===endDate' do
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
      page.errorDate_element.when_present
      expect( page.errorDate !="").to be_truthy  
    end

    it 'Start date should be less than end date' do
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
      page.errorDate_element.when_present
      expect( page.errorDate !="").to be_truthy  
    end    
  end
  
  after (:all) do
    logout()
  end
end