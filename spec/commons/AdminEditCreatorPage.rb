#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'selenium/webdriver'

class AdminEditCreatorPage
  include PageObject

  DEFAULT_DATA = 
  {
    :name => 'Mister Twister',
    :email  => 'admin@itlft.omsk',
    :phone  => '+7-912-115-1013 (112)'
  }

  
  text_field(:name,  name: "requesterName")   
  text_field(:email, name: "requesterEmail")  
  text_field(:phone, name: "requesterPhone")    
  button(:sendRequest, id: "js-submit-rq")

  ## Exception  
  div(:errorName,  class: "form-error js-error-name")
  div(:errorEmail, class: "form-error js-error-email")
  div(:errorPhone, class: "form-error js-error-phone")
  
 
  def default(data = {})
    populate_page_with DEFAULT_DATA.merge(data)  
    sendRequest
  end  
end