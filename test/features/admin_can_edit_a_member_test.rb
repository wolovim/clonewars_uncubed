require_relative 'feature_test_helper'

class AdminCanEditAMember < FeatureTest
    def test_admin_can_edit_a_member
      visit '/login'
      fill_in('username', with: 'admin')
      fill_in('password', with: 'omg')
      click_button('wp-submit')
      #view members
      visit '/members'
      assert_equal 200, page.status_code
      assert page.has_css?('#admin_member_form')
      fill_in('member[company]', with: "Zonk, Inc")
      fill_in('member[membership_type_id]', with: "2")
      fill_in('member[first_name]', with: "Don")
      fill_in('member[last_name]', with: "Shimmy")
      fill_in('member[email_address]', with: "zo@nk.com")
      fill_in('member[phone_number]', with: "222-111-3333")
      click_button('Add Member')
      assert page.has_content?("Shimmy")
      assert page.has_content?("Zonk, Inc")
      admin can edit a member
      # click_button('√')
      # assert_equal 200, page.status_code
      # assert page.has_css?('#admin_member_form')
      # fill_in('member[company]', with: "Donk")
      # fill_in('member[membership_type_id]', with: "2")
      # fill_in('member[first_name]', with: "Don")
      # fill_in('member[last_name]', with: "Shimmy")
      # fill_in('member[email_address]', with: "zo@nk.com")
      # fill_in('member[phone_number]', with: "222-111-3333")
      # click_button('edit_member')
      # visit '/members'
      # assert page.has_content?('Donk')
    end

end
