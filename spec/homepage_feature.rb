#!/bin/env ruby
# encoding: utf-8
require "pry"

require_relative '../spec/spec_helper'
require_relative '../spec/commons/useful_func'
require_relative '../spec/commons/HomePage'

describe "HomePage: RequestForEvent" do
  page = nil

  context "requesterName" do
    before (:each) do
      page = HomePage.new(browser, true)      
      page.requesterName_element.when_present            
      page.sendRequest_element.when_present
    end

    it "non-empty?" do     
      page.requesterName = ""
      page.sendRequest
      page.errorName_element.when_present      
      expect(page.errorName !="").to be_truthy
    end
    it " str = 'Z' " do      
      page.requesterName = "Z"
      page.sendRequest
      page.errorName_element.when_present      
      expect(page.errorName =="").to be_truthy
    end
    it " str = 'Я' " do
      page.requesterName = "Я"
      page.sendRequest
      page.errorName_element.when_present      
      expect(page.errorName =="").to be_truthy
    end
    it " str = 'Zфыпававав' " do      
      page.requesterName = "Zфыпававав"
      page.sendRequest
      page.errorName_element.when_present      
      expect(page.errorName =="").to be_truthy
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page.requesterName = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      page.errorName_element.when_present      
      expect(page.errorName =="").to be_truthy
    end
    it "str(256)" do
      page.requesterName = str(255)
      page.sendRequest
      page.errorName_element.when_present      
      expect(page.errorName =="").to be_truthy
    end
    it "str(257)" do      
      page.requesterName = str(256)
      page.sendRequest
      page.errorName_element.when_present      
      expect(page.errorName !="").to be_truthy
    end
  end  

  context "EventTitle?" do
    before (:each) do
      page = HomePage.new(browser, true)      
      page.eventTitle_element.when_present            
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
      page = HomePage.new(browser, true)      
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
  
  context "PhoneNumber?" do
    before (:each) do
      page = HomePage.new(browser, true)      
      page.requesterPhone_element.when_present            
      page.sendRequest_element.when_present
    end
    it "spaces" do
      page.requesterPhone = "          "
      page.sendRequest
      page.errorPhone_element.when_present
      expect(page.errorPhone =="").to be_truthy
      browser.refresh
      page.requesterPhone_element.when_visible
      expect(page.requesterPhone == "").to be_truthy      
    end
    it "str(256)" do
      page.requesterPhone = str(255)
      page.sendRequest
      page.errorPhone_element.when_present
      expect(page.errorPhone =="").to be_truthy
    end
    it "str(257)" do
      page.requesterPhone = str(256)
      page.sendRequest
      page.errorPhone_element.when_present
      expect(page.errorPhone !="").to be_truthy
    end
  end

  context 'URL?' do
    
    it 'Positive URL examples' do      
      urls = File.readlines("test_data/good_url.txt")      
      aggregate_failures("good_url") do
        urls.each do |url|
          page = HomePage.new(browser, true)
          page.eventReference_element.when_visible
          page.eventReference = url
          page.sendRequest
          page.errorReference_element.when_present
          expect(page.errorReference =="").to be_truthy
        end
      end          
    end  

    it 'Negative URL examples' do
      urls = File.readlines("test_data/bad_url.txt")      
      aggregate_failures("bad_url") do
        urls.each do |url|
          page = HomePage.new(browser, true)
          page.eventReference_element.when_visible
          page.eventReference = url
          page.sendRequest
          page.wait_until do
            page.errorReference != ""
          end          
        end
      end      
    end
  end

  context 'Email?' do
    
    it 'Positive email examples' do 
      emails = File.readlines("test_data/good_emails.txt")
      aggregate_failures("good_emails") do
        emails.each do |email|
          page = HomePage.new(browser, true)
          page.requesterEmail_element.when_present            
          page.requesterEmail = email
          page.sendRequest
          page.errorEmail_element.when_present
          expect(page.errorEmail =="").to be_truthy
        end
      end
    end
  
    it 'Negative email examples' do
      emails = File.readlines("test_data/bad_emails.txt")
      aggregate_failures("bad_emails") do
        emails.each do |email|
          page = HomePage.new(browser, true)
          page.requesterEmail_element.when_present            
          page.requesterEmail = email
          page.sendRequest
          page.wait_until do
            page.errorEmail != ""
          end          
        end
      end
    end
  end

  context 'Subscriber?' do
    
    it 'Positive email examples' do 
      emails = File.readlines("test_data/good_emails.txt")
      aggregate_failures("good_emails") do
        emails.each do |email|      
          page = HomePage.new(browser, true)
          page.subscriber_element.when_visible
          page.subscribe_element.when_visible
          page.subscriber = email.chomp
          page.subscribe          
          page.wait_until do
            HomePage::SuccessMessageSubArray.include?(page.errorSubscriberEmail)
          end
        end
      end
    end  
    it 'Negative email examples' do        
      emails = File.readlines("test_data/bad_emails.txt")
      aggregate_failures("bad_emails") do
        emails.each do |email|
          page = HomePage.new(browser, true)
          page.subscriber_element.when_visible
          page.subscribe_element.when_visible
          page.subscriber = email.chomp
          page.subscribe 
          page.wait_until do
            HomePage::ErrorMessageSubArray.include?(page.errorSubscriberEmail)
          end
        end
      end
    end

  end

  context "Dates of event"  do
    before (:each) do
      page = HomePage.new(browser, true)
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
end