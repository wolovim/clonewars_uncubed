require_relative 'feature_test_helper'

class UserCanEditContent < FeatureTest
  def test_an_admin_can_edit_index_page_content
    #User logs in
    visit '/login'
    assert_equal 200, page.status_code
    fill_in('username', with: "admin")
    fill_in('password', with: "omg")
    click_button('wp-submit')
    #User clicks to edit content
    visit '/'
    assert_equal 200, page.status_code
    assert page.has_css?('#post-11')
    # refute page.has_content?('Blah')
    click_button('Edit Content')
    #On edit page
    assert_equal 200, page.status_code
    fill_in("content[title]", with: "Coworking for the Entrepreneurial Blah")
    click_button("Update Content")
    assert page.has_content?('Blah')
    # File.delete(File.expand_path("~/Dropbox/Projects/Turing/clonewars_uncubed/test_database.db"))
  end
  
  # def test_that_teardown_worked
  #   visit '/'
  #   assert page.has_content?('Blah')
  #   # File.delete(File.expand_path("~/Dropbox/Projects/Turing/clonewars_uncubed/test_database.db"))
  # end

end
