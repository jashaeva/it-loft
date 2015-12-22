#!/bin/env ruby
# encoding: utf-8
require 'page-object'
require 'selenium/webdriver'
require_relative 'LoginFailPage'

class AdminPanelRequests
  include PageObject
  
  page_url 'http://itlft.7bits.it/admin/requests'
    
end