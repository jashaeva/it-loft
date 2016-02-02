#-*- coding: utf-8 -*-

require "rubygems"
require 'bundler/setup'

require "rspec/core/rake_task"

TEST_HOME = File.expand_path(File.dirname(__FILE__))

desc "The admin- features test"
RSpec::Core::RakeTask.new(:admin) do |t|
  t.fail_on_error = false
  t.rspec_opts = %w[--color]
  t.verbose = false
  t.pattern = "#{TEST_HOME}/spec/**/admin*feature.rb"    
end

desc "The homepage- features test"
RSpec::Core::RakeTask.new(:home) do |t|
  t.fail_on_error = false
  t.rspec_opts = %w[--color]
  t.verbose = false
  t.pattern = "#{TEST_HOME}/spec/**/home*feature.rb"    
end

desc "The sign in/up features test"
RSpec::Core::RakeTask.new(:sign) do |t|
  t.fail_on_error = false
  t.rspec_opts = %w[--color]
  t.verbose = false
  t.pattern = "#{TEST_HOME}/spec/**/sign*feature.rb"    
end

desc "The user- features test"
RSpec::Core::RakeTask.new(:user) do |t|
  t.fail_on_error = false
  t.rspec_opts = %w[--color]
  t.verbose = false
  t.pattern = "#{TEST_HOME}/spec/**/user*feature.rb"  
end

desc "The support feature's test"
RSpec::Core::RakeTask.new(:support) do |t|
  t.fail_on_error = false
  t.rspec_opts = %w[--color]
  t.verbose = false
  t.pattern = "#{TEST_HOME}/spec/**/support*feature.rb"  
end

desc "The restore password feature's test"
RSpec::Core::RakeTask.new(:restore) do |t|
  t.fail_on_error = false
  t.rspec_opts = %w[--color]
  t.verbose = false
  t.pattern = "#{TEST_HOME}/spec/**/restore*feature.rb"  
end

desc "Defaults" 
task :default => [:admin, :home, :sign, :user, :support, :restore]

