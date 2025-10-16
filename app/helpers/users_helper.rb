# frozen_string_literal: true

module UsersHelper
  def user_avatar_url(user)
    "https://i.pravatar.cc/150?img=#{user.id % 70}"
  end

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
