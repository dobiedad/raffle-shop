# frozen_string_literal: true

module UsersHelper
  # :nocov:
  def user_avatar_url(user)
    if user.profile_image.attached?
      user.profile_image.variant(resize_to_limit: [150, 150])
    else
      "https://i.pravatar.cc/150?img=#{user.id % 70}"
    end
  end
  # :nocov:

  def render_achievements(_user)
    achievements = []

    achievements << content_tag(:span, '🏆 First Win', class: 'tag is-success is-light')
    achievements << content_tag(:span, '⭐ Trusted User', class: 'tag is-warning is-light')
    achievements << content_tag(:span, '🎖️ Early Adopter', class: 'tag is-primary is-light')
    achievements << content_tag(:span, '💰 Big Spender', class: 'tag is-link is-light')
    achievements << content_tag(:span, '🔥 Hot Streak', class: 'tag is-danger is-light')

    safe_join(achievements)
  end
end
