#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'pry'
require 'selenium/webdriver'



class CancelEventPage 
  include PageObject
  
  text_area(:transferComment, name: "transferComment") 
  button(:sendRequest,  id: "js-cancel-event-submit")
                            
  ## Exception  
  div(:errorComment, class: "form-error js-error-description")
  div(:response, id: "js-response")

  def default()    
    self.transferComment = 'Happy New Year celebrating was CANCELLED. Sorry.'
    self.sendRequest
  end  

  
end