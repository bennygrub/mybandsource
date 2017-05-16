class NotificationsController < ApplicationController
  def mark_viewed_user
    @notifications = Notification.where(receiving_user_id: current_user.id, viewed: false)
    @notifications.each do |notification|
      notification.update(viewed: true)
    end
    render :action => 'mark_read_user'
  end

  def mark_viewed_artist
    @notifications = Notification.where(receiving_artist_id: 0, viewed: false)
    @notifications.each do |notification|
      notification.update(viewed: true)
    end
    render :action => 'mark_read_artist'
  end
end
