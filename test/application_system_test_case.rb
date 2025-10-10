# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def fill_in_trix_editor(label, with:)
    if js?
      assert evaluate_script('window.trixEditorLoaded')
      fill_in_rich_text_area label, with: with
    else
      find(:xpath, hidden_trix_editor_input_xpath_expression(label).to_xpath, visible: false).set(with)
    end
  end

  def js?
    Capybara.current_driver != :rack_test
  end
end
