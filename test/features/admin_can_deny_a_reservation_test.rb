require_relative 'feature_test_helper'

class AdminDeletesReservation < FeatureTest
  def test_an_admin_can_delete_a_reservation
    visit '/pricing'
    fill_in('reservations[date]', with: '10/11/2014')
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
    assert page.has_content?('10/11/2014')
    click_button('Deny Reservation')
    refute page.has_content?('10/11/2014')
    # delete this later
    File.delete(File.expand_path("~/turing/clonewars_uncubed/test_database.db"))
  end

end
