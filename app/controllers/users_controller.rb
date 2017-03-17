class UsersController < ApplicationController
  include UsersHelper
  before_action :set_user, only: [:show, :following, :followers]
  before_action :authenticate_user!, only: [:following, :followers]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def following
    @title = "Following"
    users = @user.following
    artists = @user.artists
    @combined = safe_zip(artists, users)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @users = @user.followers
    render 'show_follow'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
