# frozen_string_literal: true

module UsersHelper
  # :nocov:
  def user_avatar_url(user)
    if user.profile_image&.attached?
      user.profile_image.variant(resize_to_limit: [150, 150])
    else
      "https://i.pravatar.cc/150?img=#{user.id % 70}"
    end
  end
  # :nocov:

  def render_achievements(user)
    return '' unless user&.achievements&.any?

    achievements = user.achievements.map do |achievement|
      content_tag(:span, achievement.display_name, class: "tag #{achievement.color} is-light")
    end

    safe_join(achievements)
  end

  def follow_button_for(user, size: 'is-small', style: nil)
    return '' if user == current_user
    return '' unless user_signed_in?

    render partial: 'shared/follow_button', locals: { user: user, button_size: size, button_style: style }
  end
end
