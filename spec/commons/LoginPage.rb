#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'selenium/webdriver'
require_relative 'LoginFailPage'

class LoginPage
  include PageObject
  page_url 'http://sevenbits:10ytuhbnzn@itlft.7bits.it/login'
  
  

  DEFAULT_DATA = {       
    'username' => 'funnicaplanit@yandex.ru',    
    'password' => '12345'  
  }
  
  #form
  text_field(:username,    name: "username" )
  text_field(:password,     name: "password")
  
  button(:submit, id: "js-submit-login")

  # Exception  
  div(:errorName,    class: "form-error login-error-email")
  div(:errorPassword, class: "form-error login-error-password")

  def default(data = {})
    populate_page_with DEFAULT_DATA.merge(data)  
    submit
  end

  def login_with(t_username, t_password)
    self.username = t_username
    self.password = t_password
    self.submit
  end
  
end