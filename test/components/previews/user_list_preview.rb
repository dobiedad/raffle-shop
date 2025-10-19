# frozen_string_literal: true

require_relative '../../../app/components/ui/user_list'

class UserListPreview < ComponentPreview
  def with_followers
    render UI::UserList.new(
      title: "bob@test.com's Followers",
      subtitle: '3 followers',
      users: [
        OpenStruct.new(
          id: 1,
          email: 'alice@test.com',
          followers: OpenStruct.new(count: 5),
          followings: OpenStruct.new(count: 2),
          profile_image: nil
        ),
        OpenStruct.new(
          id: 2,
          email: 'charlie@test.com',
          followers: OpenStruct.new(count: 12),
          followings: OpenStruct.new(count: 8),
          profile_image: nil
        )
      ],
      show_follow_button: false,
      empty_title: 'No followers yet',
      empty_subtitle: 'When people follow you, they will appear here.'
    )
  end

  def with_following
    render UI::UserList.new(
      title: "bob@test.com's Following",
      subtitle: '2 following',
      users: [
        OpenStruct.new(
          id: 1,
          email: 'alice@test.com',
          followers: OpenStruct.new(count: 5),
          followings: OpenStruct.new(count: 2),
          profile_image: nil
        ),
        OpenStruct.new(
          id: 2,
          email: 'charlie@test.com',
          followers: OpenStruct.new(count: 12),
          followings: OpenStruct.new(count: 8),
          profile_image: nil
        )
      ],
      show_follow_button: true,
      empty_title: 'No follows yet',
      empty_subtitle: 'Find creators you like and follow them to build your feed.',
      empty_cta: '<a href="#" class="button is-primary is-light">Explore raffles</a>'.html_safe
    )
  end

  def empty_state
    render UI::UserList.new(
      title: "bob@test.com's Followers",
      subtitle: '0 followers',
      users: [],
      show_follow_button: false,
      empty_title: 'No followers yet',
      empty_subtitle: 'When people follow you, they will appear here.'
    )
  end

  def empty_state_with_cta
    render UI::UserList.new(
      title: "bob@test.com's Following",
      subtitle: '0 following',
      users: [],
      show_follow_button: true,
      empty_title: 'No follows yet',
      empty_subtitle: 'Find creators you like and follow them to build your feed.',
      empty_cta: '<a href="#" class="button is-primary is-light">Explore raffles</a>'.html_safe
    )
  end
end
