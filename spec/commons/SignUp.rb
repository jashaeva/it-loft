#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'selenium/webdriver'

class SignUpPage
  include PageObject
  page_url 'http://sevenbits:10ytuhbnzn@itlft.7bits.it/signup'
  
  

  DEFAULT_DATA = {       
    'firstName'   => 'Funni',  
    'lastName'    => 'Bannie',
    'phoneNumber' => '',
    'email'       =>  'funnicaplanit+112@yandex.ru',
    'password' => '12345'  
  }
  
  #form
  text_field(:firstName,    name: "firstName")
  text_field(:lastName,     name: "lastName")
  text_field(:phoneNumber,  name: "phoneNumber")
  text_field(:email,        name: "email")
  text_field(:password,     name: "password")
  
  button(:submit, id: "js-submit-sg")

  # Exception  
  div(:errorFirstName,   class: "form-error js-error-firstname")
  div(:errorLastName,    class: "form-error js-error-lastname")
  div(:errorPhoneNumber, class: "form-error js-error-phone")
  div(:errorEmail,       class: "form-error js-error-email")
  div(:errorPassword,    class: "form-error js-error-password")

  # Success
  div(:success,  id: "js-response-sg")

  def default(data = {})
    populate_page_with DEFAULT_DATA.merge(data)  
    submit
  end  
end