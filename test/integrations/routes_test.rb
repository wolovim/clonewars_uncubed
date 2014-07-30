require_relative "integration_test_helper"

class RouteTester < FeatureTest
  def test_can_view_index_page
    visit '/'
    assert_equal 200, page.status_code
  end

  def test_can_view_pricing_page
    visit '/pricing'
    assert_equal 200, page.status_code
  end

  def test_can_view_gallery_page
    visit '/gallery'
    assert_equal 200, page.status_code
  end

  def test_can_view_members_page
    visit '/members'
    assert_equal 200, page.status_code
  end

  def test_can_view_contact_page
    visit '/contact-us'
    assert_equal 200, page.status_code
  end

  def test_can_view_social_page
    visit '/social'
    assert_equal 200, page.status_code
  end

  def test_can_view_nearby_page
    visit '/nearby'
    assert_equal 200, page.status_code
  end

  def test_can_view_login_page
    visit '/login'
    assert_equal 200, page.status_code
  end
end
