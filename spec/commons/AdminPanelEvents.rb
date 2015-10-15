#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'selenium/webdriver'

class AdminPanelEvents
  include PageObject
  
  page_url 'http://sevenbits:10ytuhbnzn@itlft.7bits.it/admin/events'
    
end