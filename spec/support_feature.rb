#!/bin/env ruby
# encoding: utf-8
require "pry"
require "rspec/expectations"

require_relative '../spec/spec_helper'
require_relative '../spec/commons/SupportPage'


describe "Send a letter to the support" do
  
  context "Letter Title?" do    
    it "non-empty?" do        
      page = SupportPage.new(browser, true)    
      page.title_element.when_visible      
      page.title = ""
      page.send
      expect(page.errorTitle !="").to be_truthy
    end
    it " str = 'Z' " do
      page = SupportPage.new(browser, true)      
      page.title = "Z"
      page.send
      expect(page.errorTitle !="").to be_falsey
    end
    it " str = 'Я' " do
      page = SupportPage.new(browser, true)      
      page.title = "Я"
      page.send
      expect(page.errorTitle !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = SupportPage.new(browser, true)      
      page.title = "Zфыпававав"
      page.send
      expect(page.errorTitle != "").to be_falsey
    end        
    it "strlen = 256" do
      page = SupportPage.new(browser, true)      
      page.title_element.when_visible
      page.title_element.clear
      page.title = str(255)    
      page.send_element.when_visible
      page.send
      expect(page.errorTitle !="").to be_falsey
    end
    it "str(257)" do
      page = SupportPage.new(browser, true)      
      page.title = str(256)
      page.send
      expect(page.errorTitle !="").to be_truthy
    end
  end

  context "Letter Body?" do      
    it "non-empty?" do        
      page = SupportPage.new(browser, true)    
      page.body_element.when_visible      
      page.body = ""
      page.send
      expect(page.errorBody !="").to be_truthy
    end
    it " str = 'Z' " do
      page = SupportPage.new(browser, true)      
      page.body = "Z"
      page.send
      expect(page.errorBody !="").to be_falsey
    end
    it " str = 'Я' " do
      page = SupportPage.new(browser, true)      
      page.body = "Я"
      page.send
      expect(page.errorBody !="").to be_falsey
    end
    it " str = 'Zфыпававав' " do
      page = SupportPage.new(browser, true)      
      page.body = "Zфыпававав"
      page.send
      expect(page.errorBody != "").to be_falsey
    end        
    it "strlen = 4096" do
      page = SupportPage.new(browser, true)      
      page.body_element.when_visible
      page.body_element.clear
      page.body = str(4095)    
      page.send_element.when_visible
      page.send
      expect(page.errorBody !="").to be_falsey
    end
    it "strlen = 4097" do
      page = SupportPage.new(browser, true)      
      page.body = str(4096)
      page.send
      expect(page.errorBody !="").to be_truthy
    end
  end  
end