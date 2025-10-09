# frozen_string_literal: true

require 'application_system_test_case'

class RafflesTest < ApplicationSystemTestCase
  test 'creating a new raffle a new raffle' do
    login_as(bob)

    visit raffles_path

    click_link 'New Raffle'

    fill_in 'Name', with: 'MacBook Pro Giveaway'
    find('trix-editor').click.set('Brand new MacBook Pro 16-inch')
    fill_in 'Price Target', with: '2500.00'
    fill_in 'Ticket Price', with: '10.00'

    click_button 'Create Raffle'

    assert_text 'Raffle was successfully created'
    assert_text 'MacBook Pro Giveaway'
  end
end
