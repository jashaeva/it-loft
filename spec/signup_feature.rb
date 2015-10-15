#!/bin/env ruby
# encoding: utf-8
require "pry"

require_relative '../spec/spec_helper'
require_relative '../spec/commons/roots'
require_relative '../spec/commons/useful_func'
require_relative '../spec/commons/SignUp'

describe "SignUp Page" do
  before (:all) do
    browser.driver.manage.timeouts.implicit_wait = 10
  end

  context "firstName" do
    it "firstName non-empty"   do
      page = SignUpPage.new(browser, true)
      browser.refresh
      page.firstName_element.when_present
      page.firstName = ""
      page.submit      
      expect(page.errorFirstName !="").to be_truthy
    end
    it "firstName can be 1char" do
      page = SignUpPage.new(browser, true)      
      page.firstName = "Я"
      page.submit           
      expect(page.errorFirstName !="").to be_falsey
    end
    it "firstName can contain cirillic chars" do
      page = SignUpPage.new(browser, true)      
      page.firstName = "Янина Ядвига-Мирабелла"
      page.submit
      expect(page.errorFirstName !="").to be_falsey
    end
    it "firstName can contain both latin and cirillic chars" do
      page = SignUpPage.new(browser, true)
      page.firstName = "Янина Ядвига-Maria"
      page.submit           
      expect(page.errorFirstName !="").to be_falsey
    end
    it "firstName can be  256 char" do
      page = SignUpPage.new(browser, true)
      page.firstName = str(255)
      page.submit           
      expect(page.errorFirstName !="").to be_falsey
    end
    it "firstName cann't be 257 char" do
      page = SignUpPage.new(browser, true)
      page.firstName = str(256)
      page.submit           
      expect(page.errorFirstName !="").to be_truthy
    end       
  end  

  context "lastName" do
    it "lastName non-empty"   do
      page = SignUpPage.new(browser, true)
      browser.refresh
      page.lastName_element.when_present
      page.lastName = ""
      page.submit      
      expect(page.errorLastName !="").to be_truthy
    end
    it "lastName can be 1char" do
      page = SignUpPage.new(browser, true)
      page.lastName = "Я"
      page.submit      
      expect(page.errorLastName !="").to be_falsey
    end
    it "lastName can contain cirillic chars" do
      page = SignUpPage.new(browser, true)
      page.lastName = "Янина Ядвига-Мирабелла"
      page.submit      
      expect(page.errorLastName !="").to be_falsey
    end
    it "lastName can contain both latin and cirillic chars" do
      page = SignUpPage.new(browser, true)
      page.lastName = "Янина Ядвига-Maria"
      page.submit      
      expect(page.errorLastName !="").to be_falsey
    end
    it "lastName can be  256 char" do
      page = SignUpPage.new(browser, true)
      page.lastName = str(255)
      page.submit      
      expect(page.errorLastName !="").to be_falsey
    end
    it "lastName cann't be 257 char" do
      page = SignUpPage.new(browser, true)
      page.lastName = str(256)
      page.submit      
      expect(page.errorLastName !="").to be_truthy
    end       
  end  

  context 'Email?' do
    before (:all) do
      $stdout = File.open("test_data/output", "a")
      puts "Start testing SignUpPage"
    end
    
    it 'Positive email examples' do 
      scrncounter=0
      emails = File.readlines("test_data/good_emails.txt")
      page = SignUpPage.new(browser, true)
      browser.refresh
      page.email_element.when_present(15)         
      aggregate_failures("good_emails") do
        emails.each do |email|
          puts email          
          page.email = email
          page.submit                              
          if page.errorEmail !=""  
            browser.screenshot.save "test_data/screenshots/signup#{scrncounter.to_s}:pos.png"
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
      puts 'Negatives ******'  
      page = SignUpPage.new(browser, true)
      scrncounter=0
      emails = File.readlines("test_data/bad_emails.txt")
      aggregate_failures("bad_emails") do
        emails.each do |email|
          puts email
          page.email = email
          page.submit
          if page.errorEmail =="" 
            browser.screenshot.save "test_data/screenshots/signup#{scrncounter.to_s}:neg.png"
            scrncounter = scrncounter + 1  
            puts "see screenshot"
            else
            puts page.errorEmail_element.text        
          end
          expect(page.errorEmail !="").to be_truthy
        end
      end
    end
  end
  
  context "Password?" do
    it "password can not be empty" do
      page = SignUpPage.new(browser, true)
      browser.refresh
      page.password_element.when_present
      page.password = ""
      page.submit

      expect(page.errorPassword !="").to be_truthy
    end   
    it "short password" do
      page = SignUpPage.new(browser, true)      
      page.password ="1234"
      page.submit
      expect(page.errorPassword !="").to be_truthy      
    end
    it "5-char long password" do
      page = SignUpPage.new(browser, true)      
      page.password ="12345"
      page.submit
      expect(page.errorPassword !="").to be_falsey
    end
    it "long password" do
      page = SignUpPage.new(browser, true)    
      page.password = str(257)
      page.submit
      expect(page.errorPassword !="").to be_truthy      
    end    
    it "long(256) password" do
      page = SignUpPage.new(browser, true)    
      page.password = str(255)
      page.submit
      expect(page.errorPassword !="").to be_falsey
    end    
  end

  context "Others" do
    it "such email already exists" do
      page = SignUpPage.new(browser, true)
      browser.refresh
      page.email_element.when_present
      page.email = "funnycaplanit@yandex.ru"
      page.password = "123451234512345"
      page.submit      
      expect(page.errorEmail !="").to be_truthy
    end
  end
end