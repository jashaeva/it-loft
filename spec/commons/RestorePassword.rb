#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'selenium/webdriver'

class RestorePasswordPage
  include PageObject
  page_url 'http://sevenbits:10ytuhbnzn@itlft.7bits.it/password/restore'

  DEFAULT_DATA = {           
    'email' => 'funnicaplanit+request@yandex.ru'
  }
  ErrorMessageArray = [
    "The field can not be empty", 
    "Incorrect email", 
    "The permissible length of the address - [7, 144]", 
    "Некорректный email", 
    "Поле не должно быть пустым", 
    "Допустимая длина адреса - [7, 144]", 
    "Допустимая длина локального имени адреса - [1, 64]"
  ]  
  
  SuccessMessageArray = [ 
    "In your email sent a letter with further instructions.",
    "На указанный email выслано письмо с дальнейшеми инструкциями."
  ]
  UnsuccessMessageArray = [
    "User with this email was not found!",     
    "Пользователь с таким email не найден!"
  ]

  text_field(:email, name: "email")
  button(:restore, id: "js-submit-restore")
  
  # Exception    
  div(:error,  class: "form-error js-error-email")

  #Success
  div(:successMessage, id: "js-response")


  def default(data = {})
    populate_page_with DEFAULT_DATA.merge(data)  
    restore
  end

  def unsuccess
    return UnsuccessMessageArray.include?(self.error) 
  end

  def fail
    return ErrorMessageArray.include?(self.error)
  end
end