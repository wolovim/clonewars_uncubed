require_relative "feature_test_helper"

class UserCreatesAnEvent < FeatureTest

  def test_that_a_user_can_see_the_event_form_page
    visit '/event_form'
    assert_equal 200, page.status_code
    page.has_css?('form events')
  end

  def test_that_a_user_can_get_to_the_event_form_from_social_page
    visit '/social'
    assert_equal 200, page.status_code
    assert page.has_link?('Click Here')
    click_link('Click Here')

    # now user is on member login page
    assert_equal 200, page.status_code
    page.has_css?('form member login')
    fill_in('username', with: 'admin')
    fill_in('password', with: 'omg')
    click_button('wp-submit')

    # now user is on the event form page
    fill_in('event[company]', with: 'Turing')
    fill_in('event[title]',   with: 'Meetup')
    fill_in('event[details]', with: 'Programming')
    click_button('ef-submit')

    # now the user is on the event form confirmation page
    assert_equal 200, page.status_code
    page.has_button?('add event')
    page.has_button?('goto social')
    click_button('goto social')

    # now the user is back on the social page, which should have their event added
    page.has_content?('Turing')
    page.has_content?('Meetup')
    page.has_content?('Programming')
    page.has_link?('Logout')

    	#### now the user can delete their event
    # visit '/social'
    # page.has_button?('DELETE EVENT')
    # assert page.has_content?('Turing')
    # assert page.has_content?('Meetup')
    # assert page.has_content?('Programming')
    # click_button('DELETE EVENT')
    # refute page.has_content?('Turing')
    # refute page.has_content?('Meetup')
    # refute page.has_content?('Programming')
  end
end