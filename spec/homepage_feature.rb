#!/bin/env ruby
# encoding: utf-8
require "pry"

require_relative '../spec/spec_helper'
# require_relative '../spec/commons/useful_func'
require_relative '../spec/commons/HomePage'

describe "RequestForEvent" do
 
  context "requesterName" do
    it "non-empty?" do
      page = HomePage.new(browser, true)
      # browser.refresh
      page.requesterName_element.when_visible            
      page.requesterName = ""
      page.sendRequest
      expect(page.errorName !="").to be_truthy
    end
    it " str = 'Z' " do
      page = HomePage.new(browser, true)      
      page.requesterName = "Z"
      page.sendRequest
      expect(page.errorName !="").to be_falsey
    end
    it " str = 'Я' " do
      page = HomePage.new(browser, true)      
      page.requesterName = "Я"
      page.sendRequest
      expect(page.errorName !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = HomePage.new(browser, true)      
      page.requesterName = "Zфыпававав"
      page.sendRequest
      expect(page.errorName !="").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = HomePage.new(browser, true)      
      page.requesterName = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      expect(page.errorName !="").to be_falsey
    end
    it "str(256)" do
      page = HomePage.new(browser, true)
      page.requesterName = str(255)
      page.sendRequest
      expect(page.errorName !="").to be_falsey
    end
    it "str(257)" do
      page = HomePage.new(browser, true)
      page.requesterName = str(256)
      page.sendRequest
      expect(page.errorName !="").to be_truthy
    end
  end  

  context "EventTitle?" do
    it "non-empty?" do
      page = HomePage.new(browser, true)
      page.eventTitle_element.when_visible
      page.eventTitle = ""
      page.sendRequest
      expect(page.errorTitle !="").to be_truthy
    end
    it " str = 'Z' " do
      page = HomePage.new(browser, true)      
      page.eventTitle = "Z"
      page.sendRequest
      expect(page.errorTitle !="").to be_falsey
    end
    it " str = 'Я' " do
      page = HomePage.new(browser, true)      
      page.eventTitle = "Я"
      page.sendRequest
      expect(page.errorTitle !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = HomePage.new(browser, true)      
      page.eventTitle = "Zфыпававав"
      page.sendRequest
      expect(page.errorTitle !="").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = HomePage.new(browser, true)      
      page.eventTitle = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      expect(page.errorTitle !="").to be_falsey
    end
    it "str(256)" do
      page = HomePage.new(browser, true)
      page.eventTitle = str(255)
      page.sendRequest
      expect(page.errorTitle !="").to be_falsey
    end
    it "str(257)" do
      page = HomePage.new(browser, true)
      page.eventTitle = str(256)
      page.sendRequest
      expect(page.errorTitle !="").to be_truthy
    end
  end  

  context "EventDescription?" do
    it "non-empty?" do
      page = HomePage.new(browser, true)
      browser.refresh
      page.wait_until(15, "Call not returned within 15 seconds" ) do
        page.eventDescription?
      end
      page.eventDescription = ""
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end
    it " str = 'Z' " do
      page = HomePage.new(browser, true)      
      page.eventDescription = "Z"
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end
    it " str = 'Я' " do
      page = HomePage.new(browser, true)      
      page.eventDescription = "Я"
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = HomePage.new(browser, true)      
      page.eventDescription = "Zфыпававав"
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = HomePage.new(browser, true)      
      page.eventDescription = "Анна-Мария Елизавета Д'Эстрэ"
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end
    it "str(512)" do
      page = HomePage.new(browser, true)
      page.eventDescription = str(511)
      page.sendRequest
      expect(page.errorDescription !="").to be_falsey
    end
    it "str(513)" do
      page = HomePage.new(browser, true)
      page.eventDescription = str(512)
      page.sendRequest      
      expect(page.errorDescription !="").to be_truthy
    end
  end  
  
  context "PhoneNumber?" do
    it "spaces" do
      page = HomePage.new(browser, true)
      browser.refresh
      page.wait_until(15, "Call not returned within 15 seconds" ) do
        page.requesterPhone?
      end
      page.requesterPhone = "          "
      page.sendRequest
      expect(page.errorPhone !="").to be_falsey
      browser.refresh
      browser.wait(10)
      expect(page.requesterPhone == "").to be_truthy      
    end
    it "str(256)" do
      page = HomePage.new(browser, true)
      page.requesterPhone = str(255)
      page.sendRequest
      expect(page.errorPhone !="").to be_falsey
    end
    it "str(257)" do
      page = HomePage.new(browser, true)
      page.requesterPhone = str(256)
      page.sendRequest
      expect(page.errorPhone !="").to be_truthy
    end
  end

  context 'URL?' do
    
    before (:all) do
      $stdout = File.open("test_data/url_output", "a")
      puts "Start testing **************" 

    end
    
    it 'Positive URL examples' do
      page = HomePage.new(browser, true)      
      browser.refresh 
      i=0
      urls = File.readlines("test_data/good_url.txt")      
      page.eventReference_element.when_visible
      aggregate_failures("good_url") do
        urls.each do |url|
          page.eventReference = url
          page.sendRequest                              
          if page.errorReference !=""
            browser.screenshot.save "test_data/screenshots/ref_neg#{i.to_s}.png"
            i = i + 1
          end
          expect(page.errorReference !="").to be_falsey
        end
      end          
    end  

    it 'Negative URL examples' do
      puts "Negatives ***************"
      urls = File.readlines("test_data/bad_url.txt")      
      page = HomePage.new(browser, true)
      browser.refresh      
      i=0     
      page.eventReference_element.when_visible

      aggregate_failures("bad_url") do
        urls.each do |url|
          page.eventReference = url
          page.sendRequest
          if page.errorReference ==""
            browser.screenshot.save "test_data/screenshots/ref_neg#{i.to_s}.png"
            i = i + 1
          end
          Watir::Wait.until{ page.errorReference !="" }                    
        end
      end      
    end
  end

  context 'Email?' do
    before (:all) do
      $stdout = File.open("test_data/output", "a")
      puts "Start testing email ***********"
    end
    
    it 'Positive email examples' do 
      page = HomePage.new(browser, true)
      browser.refresh
      page.wait_until(15, "Call not returned within 15 seconds" ) do
        page.requesterEmail?
      end
      scrncounter=0
      emails = File.readlines("test_data/good_emails.txt")
      aggregate_failures("good_emails") do
        emails.each do |email|
          puts email          
          page.requesterEmail = email
          page.sendRequest                              
          if page.errorEmail !=""  
            browser.screenshot.save "test_data/screenshots/email#{scrncounter.to_s}:pos.png"
            scrncounter = scrncounter + 1
            puts page.errorEmail_element.text
          else 
            puts "--- Ok"
          end
          expect(page.errorEmail !="").to be_falsey
        end
      end
    end
  
    it 'Negative email examples' do  
      puts 'Emails Negatives  *********'  
      page = HomePage.new(browser, true)
      scrncounter=0
      emails = File.readlines("test_data/bad_emails.txt")
      aggregate_failures("bad_emails") do
        emails.each do |email|
          puts email
          page.requesterEmail = email
          page.sendRequest
          Watir::Wait.until{ page.errorEmail !="" }          
        end
      end
    end
  end

 # Fast send to server 
  # context 'Subscriber?' do
  #   before (:all) do
  #     $stdout = File.open("test_data/output", "a")
  #     puts "Start testing subscriber emails  ********"
  #   end
    
  #   it 'Positive email examples' do 
  #     emails = File.readlines("test_data/good_emails.txt")
  #     page = HomePage.new(browser, true)      
  #     browser.refresh
  #     scrncounter=0
  #     page.subscriber_element.when_visible
  #     aggregate_failures("good_emails") do
  #       emails.each do |email|
  #         puts email                    
  #         page.subscriber = email
  #         # page.subscribe          
  #         page.errorSubscriberEmail_element.when_visible
  #         expect( HomePage::SuccessMessageArray ).to include (page.errorSubscriberEmail_element.text)             
  #         puts page.errorSubscriberEmail_element.text          
  #         scrncounter+=1          
  #       end
  #     end
  #   end  
  #   it 'Negative email examples' do  
  #     puts 'Negatives ********************'  
  #     page = HomePage.new(browser, true)      
  #     scrncounter=0
  #     emails = File.readlines("test_data/bad_emails.txt")
  #     aggregate_failures("bad_emails") do
  #       emails.each do |email|
  #         puts email
  #         page.subscriber = email
  #         page.subscribe 
  #         page.errorSubscriberEmail_element.when_visible(10)
  #         puts page.errorSubscriberEmail_element.text
  #         expect( HomePage::ErrorMessageArray ).to include (page.errorSubscriberEmail_element.text)                  
  #         browser.screenshot.save "test_data/screenshots/sub#{scrncounter.to_s}:neg.png"
  #         scrncounter+=1
  #       end
  #     end
  #   end
  # end

  context "Dates of event"  do
  
      it 'Start date can not be empty ' do
        page = HomePage.new(browser, true)
        browser.refresh
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
        page = HomePage.new(browser, true)
        browser.refresh      
        #binding.pry  
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
        page = HomePage.new(browser, true)
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
        page = HomePage.new(browser, true)
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

#Logo manually tested

end