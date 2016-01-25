#!/bin/env ruby
# encoding: utf-8
require 'pry'
require 'page-object'
require 'selenium/webdriver'

class HomePageShort
  include PageObject

  # page_url 'http://sevenbits:10ytuhbnzn@itlft.7bits.it/'
  page_url 'http://itlft.7bits.it/'
  

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
    "Спасибо за подписку! Через некоторое время вам на почтовый ящик придет письмо с дальнейшими инструкциями"
  ]
  STARTDATE=3
  ENDDATE=4

  DEFAULT_DATA = {       
    'eventStartDate' => '2016-01-01 12:00',
    'eventEndDate'   => '2016-01-02 12:00',
    'eventTitle'     =>  'Happy New Year celebrating'    
  }

  #Subscribe for news form
  text_field(:subscriber, id: "js-input-email-sub")
  button(:subscribe, id: "js-submit-sub")  
  #Request for new event form 
 
  text_field(:eventStartDate,   name: "eventStartDate")
  text_field(:eventEndDate,     name: "eventEndDate")
  text_field(:eventTitle,       name:"eventTitle") # 
  text_area(:eventDescription, name: "eventDescription") #
  text_field(:eventReference, name: "eventReference") #  
  image(:logo,  class: "img-responsive img-center js-img-move text-margin-bottom")
  button(:sendRequest, id: "js-request-short-submit")

  ## Exception  

  #subscribe form
  div(:errorSubscriberEmail,  id: "js-response-sub")  
  #request form
  div(:errorName,  class: "form-error js-error-name")
  div(:errorPhone, class: "form-error js-error-phone")
  div(:errorEmail, class: "form-error js-error-email")
  div(:errorDate,  class: "form-error js-error-date")
  div(:errorTitle, class: "form-error js-error-title")
  div(:errorDescription, class: "form-error js-error-description")
  div(:errorReference,   class: "form-error js-error-reference")
  div(:result,     id: "js-response")
 
  def default(data = {})
    populate_page_with DEFAULT_DATA.merge(data)  
    sendRequest
  end  

  def next_month_e    
      browser.element(xpath: "html/body/div[5]/div[3]/table/thead/tr/th[3]").click
  end

  def next_month_s    
      browser.element(xpath: "html/body/div[4]/div[3]/table/thead/tr[1]/th[3]").click    
  end

  def next_day(num)
    days = browser.elements(xpath: ".//td[@class='day']")
    count=0;
    days.each do |day|
      if !day.visible?  
        count+=1
      else
        break
      end
    end
    count = [count+num-1, days.length].min
    if days[count].visible? == true 
      days[count].click 
    end
  end

  def choose_hour(num_hour)    
    hours = browser.elements(xpath: './/*[@class="hour"]')
    count=0;
    hours.each do |hour|
      if !hour.visible?   
        count+=1
      else
        break
      end
    end
    count = [count+num_hour-1, hours.length].min
    if hours[count].visible? == true 
      hours[count].click 
    end
  end
  
  def choose_minute(num_minute)    
    mins = browser.elements(xpath: './/*[@class="minute"]')
    count=0;
    mins.each do |minute|
      if !minute.visible?
        count+=1
      else
        break
      end
    end
    count = [count+num_minute-1, mins.length].min
    if mins[count].visible? == true 
      mins[count].click 
    end
  end  
  
end