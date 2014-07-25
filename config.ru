$:.unshift File.expand_path("./../lib", __FILE__)
require 'app'
require 'bundler'
Bundler.require

run UncubedApp
