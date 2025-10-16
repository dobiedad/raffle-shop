# frozen_string_literal: true

module UI
  class RaffleBadgePreview < ViewComponent::Preview
    def default
      render(UI::RaffleBadge.new(text: "3 tickets"))
    end

    def success
      render(UI::RaffleBadge.new(text: "Won!", variant: :success))
    end

    def warning
      render(UI::RaffleBadge.new(text: "Ending Soon", variant: :warning))
    end

    def danger
      render(UI::RaffleBadge.new(text: "Cancelled", variant: :danger))
    end

    def single_ticket
      render(UI::RaffleBadge.new(text: "1 ticket"))
    end

    def multiple_tickets
      render(UI::RaffleBadge.new(text: "8 tickets"))
    end

    def long_text
      render(UI::RaffleBadge.new(text: "Participating"))
    end

    def on_card_example
      render_with_template
    end
  end
end
