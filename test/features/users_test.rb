require "test_helper"

class UsersTest < Capybara::Rails::TestCase
  setup do
    Group.create!(name: 'Potato')
  end
  test "Manage users" do
    visit root_path
    click_link 'New User'
    assert page.has_selector?('h1', text: 'New User')

    fill_in 'Name', with: 'Alice'
    fill_in 'Group name', with: 'Tomato'
    click_on 'Create User'

    assert page.has_content?('User was successfully created.')
    alice = User.find_by_name('Alice')
    assert_equal 'Tomato', alice.group.name
  end
end
