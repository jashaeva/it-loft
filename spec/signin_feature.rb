#!/bin/env ruby
# encoding: utf-8
require "pry"

require_relative '../spec/spec_helper'
require_relative '../spec/commons/LoginPage'

# FAIL_URL = "http://sevenbits:10ytuhbnzn@itlft.7bits.it/login-fail"
# TEST_URL = "http://sevenbits:10ytuhbnzn@itlft.7bits.it/"

describe "Login Page" do
  before (:all) do
    browser.driver.manage.timeouts.implicit_wait = 10
  end

  context 'Email?' do
    before (:all) do
      $stdout = File.open("test_data/output", "a")
      puts "Start testing LoginPage"
    end
    
    it 'Positive email examples' do       
      emails = File.readlines("test_data/good_emails.txt")
      page = LoginPage.new(browser, true)
      browser.refresh
      page.username_element.when_present(15)         
      aggregate_failures("good_emails") do
        emails.each do |email|
          puts email          
          page.username = email
          page.submit                              
          expect(page.errorName !="").to be_falsey
        end
      end
    end
  
    it 'Negative email examples' do  
      puts 'Negatives ******'  
      page = LoginPage.new(browser, true)      
      emails = File.readlines("test_data/bad_emails.txt")
      aggregate_failures("bad_emails") do
        emails.each do |email|
          puts email
          page.username = email
          page.submit          
          expect(page.errorName !="").to be_truthy
        end
      end
    end
  end
  
  context "Password?" do
    it "password can not be empty" do
      page = LoginPage.new(browser, true)
      browser.refresh
      page.password_element.when_present
      page.password = ""
      page.submit
      expect(page.errorPassword !="").to be_truthy
    end
    it "wrong password" do
      page = LoginPage.new(browser, true)
      browser.refresh
      page.password_element.when_present
      page.username = "funnycaplanit@yandex.ru"
      page.password = "123451234512345"
      page.submit
      Watir::Wait.until {browser.url == FAIL_URL }
    end
    it "short password" do
      page = LoginPage.new(browser, true)      
      page.password_element.when_present
      page.username = "funnycaplanit@yandex.ru"
      page.password ="1"
      page.submit
      expect(page.errorPassword !="").to be_truthy
      # Watir::Wait.until {browser.url == FAIL_URL }
    end
    it "long password" do
      page = LoginPage.new(browser, true)    
      page.username_element.when_present
      page.username = "funnycaplanit@yandex.ru"
      page.password = str(257)
      page.submit
      expect(page.errorPassword !="").to be_truthy
      # Watir::Wait.until {browser.url == FAIL_URL }
    end    
  end

  context "Others" do
    it "user does not signed in" do
      page = LoginPage.new(browser, true)
      browser.refresh
      page.password_element.when_present
      page.username = "fun@yandex.ru"
      page.password = "123451234512345"
      page.submit
      Watir::Wait.until {browser.url == FAIL_URL }
    end

    it "positive case"  do
      page = LoginPage.new(browser, true)
      browser.refresh
      page.password_element.when_present
      page.username = "funnycaplanit@yandex.ru"
      page.password = "12345"
      page.submit     
      Watir::Wait.until {browser.url == TEST_URL }      
      log_out = button(class: "btn-hover btn-main", text: "Выход").visible? || 
                button(class: "btn-hover btn-main", text: "Logout").visible? 
      expect(log_out).to be_truthy
    end
  end

end