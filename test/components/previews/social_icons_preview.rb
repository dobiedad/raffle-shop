# frozen_string_literal: true

require_relative '../../../app/components/ui/social_icons'

class SocialIconsPreview < ComponentPreview
  def default
    render(
      UI::SocialIcons.new(
        share_url: 'https://example.com/raffle/123',
        share_text: 'Check out this awesome raffle!'
      )
    )
  end

  def email_only
    render(
      UI::SocialIcons.new(
        share_url: 'https://example.com',
        share_text: 'Check this out!',
        show_native_share: false,
        show_whatsapp: false,
        show_telegram: false,
        show_twitter: false
      )
    )
  end
end
