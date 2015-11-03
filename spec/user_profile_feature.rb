#!/bin/env ruby
# encoding: utf-8

# require "pry"
# require "rspec/expectations"

require_relative '../spec/spec_helper'
require_relative '../spec/commons/UserProfilePage'
require_relative '../spec/commons/LoginPage'


describe "User Profile Page" do
  
  before (:all) do 
    browser.driver.manage.timeouts.implicit_wait = 15      
    page = LoginPage.new(browser, true)
    
    page.login_with('funnicaplanit@yandex.ru', '12345')
    Watir::Wait.until { browser.url == 'http://itlft.7bits.it/' }           
  end
  
  context "FirstName?" do
    
    it "non-empty?" do        
      page = UserProfilePage.new(browser, true)
      page.firstName_element.when_visible      
      page.firstName = ""
      page.save      
      expect(page.errorFirst !="").to be_truthy
    end
    it " str = 'Z' " do
      page = UserProfilePage.new(browser, true)
      
      page.firstName = "Z"
      page.save
      expect(page.errorFirst !="").to be_falsey
    end
    it " str = 'Я' " do
      page = UserProfilePage.new(browser, true)
      page.firstName  = "Я"
      page.save
     expect(page.errorFirst !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = UserProfilePage.new(browser, true)
      page.firstName  = "Zфыпававав"
      page.save
      expect(page.errorFirst !="").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = UserProfilePage.new(browser, true)
      page.firstName = "Анна-Мария Елизавета Д'Эстрэ"
      page.save  
     expect(page.errorFirst !="").to be_falsey
    end
    it "strlen = 256" do
      page = UserProfilePage.new(browser, true)      
      page.firstName_element.when_visible
      page.firstName_element.clear
      page.firstName  = str(255)    
      page.save_element.when_visible
      page.save
      expect(page.errorFirst !="").to be_falsey
    end
    it "str(257)" do
      page = UserProfilePage.new(browser, true)
      page.firstName  = str(256)
      page.save
      expect(page.errorFirst !="").to be_truthy
    end
    it 'restore old value' do
      page = UserProfilePage.new(browser, true)
      page.firstName_element.clear      
      page.firstName = "Mister Twister Administrator"
      page.save
      expect(page.errorFirst !="").to be_falsey
    end
  end  

  context "LastName?" do
    
    it "non-empty?" do        
      page = UserProfilePage.new(browser, true)
      page.lastName_element.when_visible      
      page.lastName = ""
      page.save      
      expect(page.errorLast !="").to be_truthy
    end
    it " str = 'Z' " do
      page = UserProfilePage.new(browser, true)      
      page.lastName = "Z"
      page.save
      expect(page.errorLast !="").to be_falsey
    end
    it " str = 'Я' " do
      page = UserProfilePage.new(browser, true)
      page.lastName  = "Я"
      page.save
     expect(page.errorLast !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = UserProfilePage.new(browser, true)
      page.lastName  = "Zфыпававав"
      page.save
      expect(page.errorLast !="").to be_falsey
    end    
    it " str = 'Анна-Мария Елизавета Д'Эстрэ'" do
      page = UserProfilePage.new(browser, true)
      page.lastName = "Анна-Мария Елизавета Д'Эстрэ"
      page.save  
      expect(page.errorLast !="").to be_falsey
    end
    it "strlen = 256" do
      page = UserProfilePage.new(browser, true)
      browser.refresh      
      page.lastName_element.when_visible
      page.lastName.clear
      page.lastName  = str(255)    
      page.save_element.when_visible
      page.save
      expect(page.errorLast !="").to be_falsey
    end
    it "str(257)" do
      page = UserProfilePage.new(browser, true)
      page.lastName  = str(256)
      page.save
      expect(page.errorLast !="").to be_truthy
    end
    it 'restore old value' do
      page = UserProfilePage.new(browser, true)
      page.lastName_element.clear      
      page.lastName = "Twister Administrator"
      page.save
      expect(page.errorLast !="").to be_falsey
    end
  end  

  context "Phone number?" do    
    it "strlen = 256" do
      page = UserProfilePage.new(browser, true)      
      expect(page.errorLast !="").to be_falsey 
      page.phone_element.when_visible
      page.phone_element.clear
      page.phone = str(255)    
      page.save_element.when_visible
      page.save
      expect(page.errorPhone !="").to be_falsey
    end
    it "str(257)" do
      page = UserProfilePage.new(browser, true)
      page.phone = str(256)
      page.save
      expect(page.errorPhone !="").to be_truthy
    end
  end

  context "Password?" do
    it "short password" do
      page = UserProfilePage.new(browser, true) 
      page.password_element.when_visible
      page.password ="1234"
      page.save
      expect(page.errorPassword !="").to be_truthy      
    end    
    it "long(257) password" do
      page = UserProfilePage.new(browser, true) 
      page.password = str(256)
      page.save
      expect(page.errorPassword !="").to be_truthy      
    end    
    it "good long(256) password" do
      page = UserProfilePage.new(browser, true)     
      page.password = str(255)
      page.save      
      expect(page.errorPassword !="").to be_falsey
    end    
    it "5-char long password" do
      page = UserProfilePage.new(browser, true) 
      page.password ="12345"
      page.save
      expect(page.errorPassword !="").to be_falsey
    end
  end
  
  after (:all) do        
    logout() 
  end
end