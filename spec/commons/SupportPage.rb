#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'selenium/webdriver'

class SupportPage
  include PageObject
  page_url 'http://sevenbits:10ytuhbnzn@itlft.7bits.it/support'

  DEFAULT_DATA = 
  {
    :title => 'Help!!!',
    :body  => 'Twister Pfhjdhfkjdh fhfjkshkjhskjfh shfskj',
  }

  
  text_field(:title, name: "title")   
  text_area(:body,  name: "body")    
  button(    :send,    id: "js-support-message-submit")

  ## Exception  
  div(:errorTitle,  class: "form-error js-error-title")
  div(:errorBody,   class: "form-error js-error-body")
  
  #in success
  div(:response, id: "js-response")
  
  def default(data = {})
    populate_page_with DEFAULT_DATA.merge(data)  
    send
  end  
end