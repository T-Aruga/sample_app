require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
      assert_template 'users/new'                                                   # newアクションが描画(つまり@user.save失敗)されていればtrue、なければfalse
      assert_select   'div#error_explanation'                                       # divタグの中のid error_explanationをが描画されていれば成功
      assert_select   'div.field_with_errors'
      assert_select   'form[action="/signup"]'   # formタグの中に`/signup`があれば成功
      end
      
      test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
