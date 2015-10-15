#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'pry'
require 'selenium/webdriver'

class UserAddEventPage
  include PageObject

  page_url 'http://sevenbits:10ytuhbnzn@itlft.7bits.it/user-request'
  
  DEFAULT_DATA = {       
    #'eventStartDate' => '2016-01-01 12:00',
    #'eventEndDate'   => '2016-01-02 12:00',
    'eventTitle'     =>  'Happy New Year celebrating -- test',
    'eventDescription' => 'Happy New Year celebrating!!!!!'    
  }

  
  #Request for new event form 
  text_field(:eventStartDate,   name: "eventStartDate")
  text_field(:eventEndDate,     name: "eventEndDate")
  text_field(:eventTitle,       name:"eventTitle") 
  text_area(:eventDescription, name: "eventDescription") 
  text_field(:eventReference, name: "eventReference") 
  image(:logo,  class: "img-responsive img-center js-img-move text-margin-bottom")
  button(:sendRequest, id: "js-request-short-submit")
                            
  

  
  #request form
  
  div(:errorDate,  class: "form-error js-error-date")
  div(:errorTitle, class: "form-error js-error-title")
  div(:errorDescription, class: "form-error js-error-description")
  div(:errorReference,   class: "form-error js-error-reference")
 
  def default()
    self.eventTitle = "Happy New Year celebrating -- test"
    self.eventDescription = 'Happy New Year celebrating!!!!!'

    self.eventEndDate_element.click
    self.next_month_e
    self.next_day(3)
    self.choose_hour(11)
    self.choose_minute(1)
  
    self.eventStartDate_element.click  
    self.next_month_s
    self.next_day(1)
    self.choose_hour(11)
    self.choose_minute(1)
    
    self.sendRequest
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
        # STDERR.puts day.inner_html + " not visible"
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
      # STDERR.puts hour.inner_html + " not visible"
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
    #    STDERR.puts minute.inner_html + " not visible"
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