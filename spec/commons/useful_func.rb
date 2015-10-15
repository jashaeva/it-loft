#!/bin/env ruby
# encoding: utf-8
require_relative 'roots'

def logout
  #form(id: "logout-form", action: "/j_spring_security_logout").submit()  
  goto TEST_URL+'logout'
end

def validate_byname(nameT, tfText, buttonText, answer)
    browser.refresh
    text_field(name: nameT).clear
    text_field(name: nameT).set tfText
    button(text: buttonText).click              
    span(text: answer).wait_until_present(4)
end

def validate_byid(tfText, idName, buttonText, answer)
    browser.refresh
    text_field(id: idName).clear
    text_field(id: idName).set tfText
    button(text: buttonText).click              
    span(text: answer).wait_until_present(4)
end

def datapath filename
  File.expand_path(File.join(File.dirname(__FILE__), filename))
end

def str(num)
  res='a'
  num.times{|i| res += 'b'}
  return res
end
