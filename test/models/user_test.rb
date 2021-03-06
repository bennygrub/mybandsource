require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "valid user save to DB" do
    user = User.new(name: 'peter', email: 'peter@test.com', password: 'xxxxxxx', password_confirmation: 'xxxxxxx', is_artist: false)
    assert user.valid?
    assert user.save!
  end

  test "user should not save with no email" do
    user = User.new(name: 'peter', password: 'xxxxxxx', password_confirmation: 'xxxxxxx', is_artist: false)
    assert !user.save
  end

  test "user should not save with no password" do
    user = User.new(name: 'peter', email: 'peter@test.com', is_artist: false)
    assert !user.save
  end

  test "user should not save with no name" do
    user = User.new(email: 'peter@test.com', password: 'xxxxxxx', password_confirmation: 'xxxxxxx', is_artist: false)
    assert !user.save
  end
end
