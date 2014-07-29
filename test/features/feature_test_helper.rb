require_relative "../test_helper"
require 'sinatra'
require 'capybara'
require_relative "../../lib/app"

Capybara.app = UncubedApp

class FeatureTest < Minitest::Test
  include Capybara::DSL

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
