# frozen_string_literal: true

module ControllerAssertions
  def assert_text(text)
    assert_select '*', text: Regexp.new(Regexp.escape(text))
  end

  def assert_no_text(text)
    assert_select '*', text: Regexp.new(Regexp.escape(text)), count: 0
  end
end
