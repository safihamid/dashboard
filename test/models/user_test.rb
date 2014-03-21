require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "validations" do
    good_data = { email: 'foo@bar.com', password: 'foosbars', username: 'user.12-34', name: 'tester'}

    user = User.create(good_data.merge({email: 'foo@bar'}))
    assert user.errors.messages.length == 1

    user = User.create(good_data.merge({username: 'tiny'}))
    assert user.errors.messages.length == 1

    user = User.create(good_data.merge({username: 'superreallydoublelongusername'}))
    assert user.errors.messages.length == 1

    user = User.create(good_data.merge({username: 'bo gus'}))
    assert user.errors.messages.length == 1
    
    # actually create a user
    user = User.create(good_data)
    #puts user.errors.messages.inspect
    assert user.valid?

    user = User.create(good_data.merge({email: 'FOO@bar.com', username: 'user.12-35'}))
    assert user.errors.messages.length == 1, "Email should be rejected as a dup"

    user = User.create(good_data.merge({email: 'OTHER@bar.com', username: 'USER.12-34'}))
    assert user.errors.messages.length == 1, "username should be rejected as a dup"
  end

  test "birthday validation" do
    good_data = { email: 'foo@bar.com', password: 'foosbars', username: 'user.12-34', name: 'tester'}

    assert_no_difference('User.count') do
      # birthday in the future (this date is actually a mysql error)
      user = User.create(good_data.merge({birthday: '03/04/20140'}))
      assert user.errors.messages.length == 1, "Invalid birthday should be rejected"
    end

    assert_difference('User.count') do
      user = User.create(good_data.merge({birthday: 'xxxxx'}))
      # if it's totally invalid just ignore it
      assert_equal nil, user.birthday
    end

    assert_difference('User.count') do
      user = User.create(good_data.merge({birthday: '03/04/2010', username: 'anewone', email: 'new@email.com'}))
      assert_equal Date.new(2010, 4, 3), user.birthday
    end
  end
end
