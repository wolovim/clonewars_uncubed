require_relative 'feature_test_helper'

class UserContactsAdmin < FeatureTest

  def test_a_user_can_see_the_contact_us_page
    visit '/contact-us'
    assert_equal 200, page.status_code
    page.has_css?('form contact form')
    page.has_css?('iframe map')
  end

  def test_a_user_can_send_an_email_to_admin
    visit '/contact-us'
    fill_in('firstname', with: 'Charles')
    fill_in('lastname',  with: 'Darwin')
    fill_in('email',     with: 'Cdarwin@gotcha.com')
    fill_in('subject',   with: 'Something fishy')
    fill_in('message',   with: 'Hurry up an evolve')
    click_button('Submit')
  end
end