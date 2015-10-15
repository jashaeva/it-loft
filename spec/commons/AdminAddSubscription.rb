#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'selenium/webdriver'

class AdminAddSubscription
  include PageObject

  
  page_url 'http://sevenbits:10ytuhbnzn@itlft.7bits.it/admin/subscription'

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
    "Thank you for subscribe! After some time, the letter will arrive on mailbox with further instructions",
    "Спасибо за подписку! Через некоторое время вам на почтовый ящик придет письмо с дальнейшими инструкциями",
    "Подписчик сохранен. На его почтовый ящик отправлено письмо с дальнейшими инструкциями"
  ]

  #Subscribe for news form
  text_field(:subscriber, name: "subsForm.email")
  button(:subscribe, id: "js-submit-sb")  
  
  #subscribe form
  div(:errorSubscriber, id: "js-response-sb")  
  
  def default(data={})
    self.subscriber = "mutual_1_koun@list.ru"
    subscribe
  end

  def success
    return SuccessMessageArray.include?(self.errorSubscriber_element.text) 
  end

  def fail
    return ErrorMessageArray.include?(self.errorSubscriber_element.text)
  end
end