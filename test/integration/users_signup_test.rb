require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    # ユーザー情報が無効な時はユーザーが作成されない
    assert_no_difference 'User.count' do
      post users_path,
           params: { user: { name: '', email: 'user@invaild', password: 'foo', password_confirmation: 'bar' } }
    end

    # 正しいレスポンスコードが返され、テンプレートがレンダリングされる
    assert_response :unprocessable_entity
    assert_template 'users/new'

    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end

  # ユーザー登録が成功してDBに新規ユーザーが作成されるか
  test 'valid signup information' do
    assert_difference 'User.count', 1 do
      post users_path,
           params: { user: { name: "Example User", email: 'user@example.com', password: 'password',
                             password_confirmation: 'password' } }
    end
    follow_redirect!
    assert_template 'users/show'
    # flashが空ではないことを確認する
    assert_not flash.empty?
  end
end
