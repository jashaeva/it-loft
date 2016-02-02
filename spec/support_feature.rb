#!/bin/env ruby
# encoding: utf-8
require "pry"
require "rspec/expectations"

require_relative '../spec/spec_helper'
require_relative '../spec/commons/SupportPage'
require_relative '../spec/commons/useful_func'


describe "Send a letter to the support" do
  page = nil
  context "Letter Title?" do    
    before (:each) do
      page = SupportPage.new(browser, true)    
      page.title_element.when_visible      
    end

    it "non-empty?" do            
      page.title = ""
      page.send
      expect(page.errorTitle !="").to be_truthy
    end
    it " str = 'Z' " do      
      page.title = "Z"
      page.send
      expect(page.errorTitle =="").to be_truthy
    end
    it " str = 'Я' " do
      page.title = "Я"
      page.send
      expect(page.errorTitle =="").to be_truthy
    end
    it " str = 'Zфыпававав' " do
      page.title = "Zфыпававав"
      page.send
      expect(page.errorTitle == "").to be_truthy
    end        
    it "strlen = 256" do
      page.title = str(255)    
      page.send_element.when_visible
      page.send
      expect(page.errorTitle =="").to be_truthy
    end
    it "str(257)" do
      page.title = str(256)
      page.send
      expect(page.errorTitle !="").to be_truthy
    end
  end

  context "Letter Body?" do      
    before (:each) do
      page = SupportPage.new(browser, true)    
      page.body_element.when_visible 
    end

    it "non-empty?" do
      page.body = ""
      page.send
      expect(page.errorBody !="").to be_truthy
    end
    it " str = 'Z' " do    
      page.body = "Z"
      page.send
      expect(page.errorBody =="").to be_truthy
    end
    it " str = 'Я' " do
      page.body = "Я"
      page.send
      expect(page.errorBody =="").to be_truthy
    end
    it " str = 'Zфыпававав' " do
      page.body = "Zфыпававав"
      page.send
      expect(page.errorBody == "").to be_truthy
    end        
    it "strlen = 4096" do
      page.body = str(4095)    
      page.send_element.when_visible
      page.send
      expect(page.errorBody =="").to be_truthy
    end
    it "strlen = 4097" do
      page.body = str(4096)
      page.send
      expect(page.errorBody !="").to be_truthy
    end
  end  
end