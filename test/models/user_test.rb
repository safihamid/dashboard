require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @good_data = { email: 'foo@bar.com', password: 'foosbars', username: 'user.12-34', name: 'tester'}
  end
  
  test "cannot create user with invalid email" do
    user = User.create(@good_data.merge({email: 'foo@bar'}))
    assert user.errors.messages.length == 1
  end
  
  test "cannot create user with short username" do
    user = User.create(@good_data.merge({username: 'tiny'}))
    assert user.errors.messages.length == 1
  end

  test "cannot create user with long username" do
    user = User.create(@good_data.merge({username: 'superreallydoublelongusername'}))
    assert user.errors.messages.length == 1
  end

  test "cannot create user with username with whitespace" do
    user = User.create(@good_data.merge({username: 'bo gus'}))
    assert user.errors.messages.length == 1
  end
    
  test "cannot create user with username with duplicate email" do
    # actually create a user
    user = User.create(@good_data)
    #puts user.errors.messages.inspect
    assert user.valid?

    user = User.create(@good_data.merge({email: 'FOO@bar.com', username: 'user.12-35'}))
    assert user.errors.messages.length == 1, "Email should be rejected as a dup"
  end
  
  test "cannot create user with username with duplicate username" do
    # actually create a user
    user = User.create(@good_data)
    #puts user.errors.messages.inspect
    assert user.valid?

    user = User.create(@good_data.merge({email: 'OTHER@bar.com', username: 'USER.12-34'}))
    assert user.errors.messages.length == 1, "username should be rejected as a dup"
  end

  test "cannot create user with birthday in the future" do
    assert_no_difference('User.count') do
      # birthday in the future (this date is actually a mysql error)
      user = User.create(@good_data.merge({birthday: '03/04/20140'}))
      assert user.errors.messages.length == 1, "Invalid birthday should be rejected"
    end
  end

  test "trying to create a user with an invalid date as birthday creates user without a birthday" do
    assert_difference('User.count') do
      user = User.create(@good_data.merge({birthday: 'xxxxx'}))
      # if it's totally invalid just ignore it
      assert_equal nil, user.birthday
    end
  end

  test "can create a user with a birthday" do
    assert_difference('User.count') do
      user = User.create(@good_data.merge({birthday: '03/04/2010', username: 'anewone', email: 'new@email.com'}))
      assert_equal Date.new(2010, 4, 3), user.birthday
    end
  end

  test "can create user without email" do
    assert_difference('User.count') do
      User.create!(username: 'student', user_type: 'student', name: 'Student without email', password: 'xxxxxxxx', provider: 'manual')
    end
  end

  test "cannot create teacher without email" do
    assert_no_difference('User.count') do
      user = User.create(username: 'badteacher', user_type: 'teacher', name: 'Bad Teacher', password: 'xxxxxxxx', provider: 'manual')
    end
  end

  test "cannot make an account without email a teacher" do
    user = User.create(username: 'student', user_type: 'student', name: 'Student without email', password: 'xxxxxxxx', provider: 'manual')

    user.user_type = 'teacher'
    assert !user.save
  end


  test "cannot make an account without email an admin" do
    user = User.create(username: 'student', user_type: 'student', name: 'Student without email', password: 'xxxxxxxx', provider: 'manual')

    user.admin = true
    assert !user.save
  end

  test "cannot create admin without email" do
    assert_no_difference('User.count') do
      User.create(username: 'badteacher', user_type: 'student', admin: true, name: 'Wannabe admin', password: 'xxxxxxxx', provider: 'manual')
    end
  end

end
