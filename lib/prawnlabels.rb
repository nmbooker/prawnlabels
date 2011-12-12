$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require_relative 'prawnlabels/generate.rb'

module PrawnLabels
  VERSION = '0.0.1'
end
