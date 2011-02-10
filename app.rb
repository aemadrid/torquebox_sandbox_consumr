require 'rubygems'
require "bundler/setup"
require 'sinatra'
require 'org.torquebox.torquebox-messaging-client'

get '/' do
  "Hello Consumr TorqueBox!"
end
