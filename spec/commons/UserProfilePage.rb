#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'selenium/webdriver'

class UserProfilePage
  include PageObject
  page_url 'http://sevenbits:10ytuhbnzn@itlft.7bits.it/user-profile'

  DEFAULT_DATA = 
  {
    :firstName => 'Mike',
    :lastName  => 'Twister',
    :phone  => '+7 912 1151013 (113)',
    :password => '12345'
  }

  
  text_field(:firstName, name: "firstName")   
  text_field(:lastName,  name: "lastName")    
  text_field(:phone,     name: "phoneNumber")    
  text_field(:password,  name: "password")
  button(:save,         class: "btn btn-loft text-22 btn-lg full-width")

  ## Exception  
  div(:errorFirst,    class: "form-error js-error-firstname")
  div(:errorLast,     class: "form-error js-error-lastname")
  div(:errorPhone,    class: "form-error js-error-phone")
  div(:errorPassword, class: "form-error js-error-password")

 
  def default(data = {})
    populate_page_with DEFAULT_DATA.merge(data)  
    save
  end  
end