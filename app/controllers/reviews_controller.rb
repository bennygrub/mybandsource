class ReviewsController < ApplicationController
  before_action :set_user, except: [:report]
  before_action :set_review, only: [:update, :destroy, :upvote, :remove_upvote, :report]

  def create
    @review = Review.create({receiving_user_id: @user.id, leaving_user_id: current_user.id, comment: params[:comment], rating: params[:rating]})
    if !@review.valid?
      flash[:alert] = 'Review creation failed'
    else
      create_notification(current_user, @user, @review)
      @user.new_avg_rating_review_count(@review.rating)
      ActionCable.server.broadcast(
          "notification_center_channel_#{@user.id}",
          sender_name: current_user.name,
          sender_id: current_user.id,
          type: "review"
      )
    end
    create_review_display(@review)
  end

  def update
    old_rating = @review.rating
    if !@review.update(comment: params[:comment], rating: params[:rating])
      flash[:alert] = 'Review update failed'
    else
      @user.change_rating(old_rating, params[:rating].to_f)
    end
    update_review_display
  end

  def destroy
    destroy_notification(current_user, @user, @review)
    @user.delete_avg_rating_review_count(@review.rating)
    unless @review.destroy
      flash[:alert] = 'Review deletion failed'
    end
    destroy_review_display
  end

  def upvote
    @review.upvotes+=1
    @review.upvotes_userlist.nil? ?
      @review.upvotes_userlist = [current_user.id] :
      @review.upvotes_userlist += [current_user.id]
    unless @review.save(touch: false)
      flash[:alert] = 'Review upvote failed'
    end
    ActionCable.server.broadcast(
        "notification_center_channel_#{current_user.id}",
        sender_name: current_user.name,
        sender_id: current_user.id,
        type: "review"
    )
    render :action => 'upvote_display.js.erb', locals: {is_artist: @user.is_artist, responses_shown: params[:responses_shown]}
  end

  def remove_upvote
    @review.upvotes-=1
    @review.upvotes_userlist-=[current_user.id.to_s]

    unless @review.save(touch: false)
      flash[:alert] = 'Review remove upvote failed'
    end
    render :action => 'upvote_display.js.erb', locals: {is_artist: @user.is_artist, responses_shown: params[:responses_shown]}
  end

  def reorder
    if @user.is_artist
      (params[:recent_order] == 'false') ?
        @reviews = Review.where(receiving_user_id: @user.id).page(params[:page]).order('upvotes DESC').per(25) :
        @reviews = Review.where(receiving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    else
      (params[:recent_order] == 'false') ?
          @reviews = Review.where(leaving_user_id: @user.id).page(params[:page]).order('upvotes DESC').per(25) :
          @reviews = Review.where(leaving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    end
    if params[:show_responses] == 'false'
      render :action => 'show_without_responses.js'
    else
      render :action => 'show_with_responses.js'
    end
  end

  def show_responses
    if @user.is_artist
      @reviews = Review.where(receiving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    else
      @reviews = Review.where(leaving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    end
    render :action => 'show_with_responses.js'
  end

  def hide_responses
    if @user.is_artist
      @reviews = Review.where(receiving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    else
      @reviews = Review.where(leaving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    end
    render :action => 'show_without_responses.js'
  end

  def create_review_display (review)
    if @user.is_artist
      @reviews = Review.where(receiving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    else
      @reviews = Review.where(leaving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    end
    render :action => 'create_review_display.js.erb', locals: {user: @user, review: review}
  end

  def update_review_display
    if @user.is_artist
      @reviews = Review.where(receiving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    else
      @reviews = Review.where(leaving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    end
    render :action => 'update_review_display.js.erb', locals: {user: @user}
  end

  def destroy_review_display
    if @user.is_artist
      @reviews = Review.where(receiving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    else
      @reviews = Review.where(leaving_user_id: @user.id).page(params[:page]).order('updated_at DESC').per(25)
    end
    @review = Review.new
    render :action => 'destroy_review_display.js.erb', locals: {user: @user, review: @review}
  end

  def share
    link = root_url[0...-1] + user_path(@user) + "?review=" + params[:id] + "%23review" + params[:id]
    render :action => 'share_review.js.erb', locals: {link: link}
  end

  def report
    @review.reported = true
    @review.save
    render :action => 'reported.js.erb', locals: {review_id: @review.id}
  end

  private
  def review_params
    params.require(:review).permit(:comment, :rating)
  end

  def set_user
    @user = User.friendly.find(params[:user_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def create_notification(generating_user, receiving_user, review)
    Notification.create(generating_user_id: generating_user.id, receiving_user_id: receiving_user.id, review_id: review.id, notification_type: 'review', generating_user_name: generating_user.name, generating_user_picture: generating_user.picture)
  end

  def destroy_notification(generating_user, receiving_user, review)
    Notification.where(generating_user_id: generating_user.id, receiving_user_id: receiving_user.id, review_id: review.id, notification_type: 'review').destroy_all
  end
end