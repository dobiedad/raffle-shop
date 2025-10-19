# frozen_string_literal: true

class FeedController < ApplicationController
  before_action :authenticate_user!

  def index
    following_ids = current_user.following.pluck(:id)

    activities_query = UserActivity
                       .for_users(following_ids)
                       .recent
                       .includes(:user, subject: [:user, :winner, { images_attachments: :blob }])

    @pagy, @activities = pagy(activities_query, limit: 20)
  end
end
