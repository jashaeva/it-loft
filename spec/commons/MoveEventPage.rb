#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'pry'
require 'selenium/webdriver'



class MoveEventPage 
  include PageObject
  
  #page_url "http://sevenbits:10ytuhbnzn@itlft.7bits.it/user-event/move/<%=params[:id]%>"
  
  #  def initialize t_browser, t_visit, t_ev_id
  #    super(t_ev_id)
  #    @browser = t_browser
  # #   @ev_id = t_ev_id    
  #    STDERR.puts @url 
  #    @url = "http://sevenbits:10ytuhbnzn@itlft.7bits.it/user-event/move/#{@t_ev_id}"
  #    browser.goto(@url) if t_visit 
  #  end

  
  text_field(:eventStartDate,   name: "eventStartDate")
  text_field(:eventEndDate,     name: "eventEndDate")
  text_area(:transferComment, name: "transferComment") 

  button(:sendRequest,  id: "js-move-event-submit")
                            
  ## Exception  
  div(:errorDate, class: "form-error js-error-date")
  div(:errorComment, class: "form-error js-error-description")
  div(:response, id: "js-response")

  def default()    
    self.transferComment = 'Happy New Year celebrating was MOVED to next year.Because.'
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