#test view banner
require_relative 'integration_test_helper'
require 'pry'
class BannerTest < FeatureTest

  def test_user_can_see_banner
    require_js
    visit '/'
    # binding.pry
    assert page.find('#banner')
  end

end
