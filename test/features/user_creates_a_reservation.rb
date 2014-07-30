require_relative "feature_test_helper"

class UserCreatesAReservation < FeatureTest
  # user story
  # user visits the pricing page - OK OK OK
  # that page exists - OK
  # user creates a reservation
  # user gets redirected to the pricing page

  def test_a_user_can_see_the_pricing_page
    visit '/pricing'
    assert_equal 200, page.status_code
    assert page.has_css?('.date-pick')
  end

  def test_a_user_can_create_a_reservation
    #Create a reservation
    visit '/pricing'
    fill_in('reservations[date]', with: '10/10/2014')
    select('10', from:'reservations[hour]')
    select('45', from:'reservations[minute]')
    select('pm', from:'reservations[am_pm]')
    select('17', from:'reservations[party_size]')
    click_button('Reserve')
    #Log in to admin
    visit '/login'
    fill_in('username', with: "admin")
    fill_in('password', with: "omg")
    click_button('wp-submit')
    #View reservation
    visit '/pricing'
    assert page.has_content?('10/10/2014')
    assert page.has_content?('10:45 pm')
  end


end
