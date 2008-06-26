$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Todoist
  
end

begin
  require 'json'
rescue LoadError
  require 'rubygems'
  require 'json'
end

require 'cgi'
require 'net/http'
require 'net/https'
require 'todoist/errors'
require 'todoist/connection'
require 'todoist/project'
