require_relative "feature_test_helper"

class UserCanDeleteAMember < FeatureTest
  def test_a_user_can_login_and_delete_a_member
    #login
    visit '/login'
    assert_equal 200, page.status_code
    fill_in('username', with: "admin")
    fill_in('password', with: "omg")
    click_button('wp-submit')

    #create a member
    visit '/members'
    assert_equal 200, page.status_code
    assert page.has_css?('#admin_member_form')
    fill_in('member[company]', with: "Zeeb Co")
    fill_in('member[membership_type_id]', with: "3")
    fill_in('member[first_name]', with: "Zo")
    fill_in('member[last_name]', with: "Zoomy")
    fill_in('member[email_address]', with: "zo@zeeb.com")
    fill_in('member[phone_number]', with: "111-111-4444")
    click_button('Add Member')
    assert page.has_content?("Zeeb Co")
    assert page.has_content?("Zoomy")

    #delete a member
    click_button('X')
    refute page.has_content?("Zeeb Co")
    refute page.has_content?("Zoomy")
  end
end
