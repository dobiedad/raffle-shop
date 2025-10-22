# frozen_string_literal: true

module UI
  class SocialIcons < ApplicationViewComponent
    attribute :share_url, required: true
    attribute :share_text, default: 'Check this out!'
    attribute :show_native_share, default: true
    attribute :show_whatsapp, default: true
    attribute :show_telegram, default: true
    attribute :show_twitter, default: true
    attribute :show_email, default: true

    def whatsapp_url
      "https://wa.me/?text=#{ERB::Util.url_encode("#{share_text}: #{share_url}")}"
    end

    def telegram_url
      "https://t.me/share/url?url=#{ERB::Util.url_encode(share_url)}&text=#{ERB::Util.url_encode(share_text)}"
    end

    def twitter_url
      "https://twitter.com/intent/tweet?url=#{ERB::Util.url_encode(share_url)}&text=#{ERB::Util.url_encode(share_text)}"
    end

    def email_url
      "mailto:?subject=#{ERB::Util.url_encode(share_text)}&body=#{ERB::Util.url_encode(share_url)}"
    end

    def dom_id
      "social-share-#{SecureRandom.hex(4)}"
    end
  end
end
