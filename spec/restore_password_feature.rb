#!/bin/env ruby
# encoding: utf-8

# require 'pry'
require_relative '../spec/spec_helper'
require_relative '../spec/commons/RestorePassword'
require_relative '../spec/commons/HomePage'

describe "Restore password" do 
  
  context 'Positive email examples, but not exists in DB as users' do
  

    it 'read emails from file, valid email, but didnot signed in system' do 
      emails = File.readlines("test_data/good_emails.txt")      
      page = RestorePasswordPage.new(browser, true)
      browser.refresh      
      page.email_element.when_visible
      aggregate_failures("good_emails") do
        emails.each do |email|           
          page.email = email
          page.error_element.when_visible
          expect(page.error !="").to be_truthy
        end
      end
    end 
  end

  context 'Negative examples' do
    it 'read emails from file, get error message' do            
      emails = File.readlines("test_data/bad_emails.txt")      
      page = RestorePasswordPage.new(browser, true)
      browser.refresh      
      page.email_element.when_visible
      aggregate_failures("bad_emails") do
        emails.each do |email|          
          page.email = email
          page.error_element.when_visible          
          expect(page.error !="").to be_truthy           
        end
      end     
    end
  end


  context "Another positive examples" do
    it "positive example, email in DB en_locale" do      
      page = HomePage.new(browser, true)            
      local_en = link(class: "locales_menu_en locale_language") 
      local_en.click if local_en.visible?   
      Watir::Wait.until {browser.url == "http://itlft.7bits.it/"}
      page = RestorePasswordPage.new(browser, true)      
      page.email_element.when_visible(15)
      page.email = "jblank@list.ru"
      page.restore      
      Watir::Wait.until {browser.url == "http://itlft.7bits.it/"}      
    end

    it "positive example, email in DB rus_locale" do
      page = HomePage.new(browser, true)            
      local_rus=link(class: "locales_menu_rus locale_language")      
      local_rus.click if local_rus.visible?
      Watir::Wait.until {browser.url == "http://itlft.7bits.it/"}
      page = RestorePasswordPage.new(browser, true)      
      page.email_element.when_visible
      page.email = "jblank@list.ru"      
      page.restore      
      Watir::Wait.until {browser.url == "http://itlft.7bits.it/"}

      # browser.goto "https://mail.ru"
      # text_field(name: "Login").set "jblank@list.ru"
      # text_field(name: "Password").set "123qwe+"
      # button(id: "mailbox__auth__button").click

      #receive, click to link
      #take password
      #log in        
      # letters=browser.divs(class: "b-datalist__item js-datalist-item b-datalist__item_unread")
      # letters.each do |letter|
      #   if letter.div(class: "b-datalist__item__body").a.attribute_value("data-subject") == "Восстановление пароля от аккаунта IT LOFT."
      #     letter.div(class:  "b-datalist__item__body").a.click
      #     break
      #   end
      # end

    end       
  end

end
