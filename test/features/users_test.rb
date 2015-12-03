require "test_helper"

class UsersTest < Capybara::Rails::TestCase
  setup do
    Group.create!(name: 'Potato')
  end
  test "Manage users" do
    visit root_path
    click_link 'New User'
    assert page.has_selector?('h1', text: 'New User')

    # 新しいグループを作成する
    fill_in 'Group name', with: 'Tomato'
    # バリデーションエラーが起きても入力値が残る
    click_on 'Create User'
    assert page.has_content?("Name can't be blank")
    assert page.has_field?('Group name', with: 'Tomato')
    # 登録実行
    fill_in 'Name', with: 'Alice'
    click_on 'Create User'

    assert page.has_content?('User was successfully created.')
    alice = User.find_by_name('Alice')
    assert_equal 'Tomato', alice.group.name

    # 既存のグループを割り当てる
    click_on 'Edit'
    assert page.has_selector?('h1', text: 'Editing User')
    assert page.has_field?('Group name', with: 'Tomato')
    fill_in 'Group name', with: 'Potato'
    click_on 'Update User'
    assert page.has_content?('User was successfully updated.')
    assert_equal 'Potato', alice.reload.group.name

    # グループの割り当てを解除する
    click_on 'Edit'
    assert page.has_selector?('h1', text: 'Editing User')
    assert page.has_field?('Group name', with: 'Potato')
    fill_in 'Group name', with: ''
    click_on 'Update User'
    assert page.has_content?('User was successfully updated.')
    assert_nil alice.reload.group
  end
end