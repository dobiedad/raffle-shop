# frozen_string_literal: true

require 'application_system_test_case'

class RafflesTest < ApplicationSystemTestCase
  test 'creating a new raffle' do
    login_as(bob)

    visit raffles_path

    click_link 'New Raffle', match: :first

    fill_in 'Name', with: 'MacBook Pro Giveaway'
    fill_in_trix_editor 'General Description', with: 'Brand new MacBook Pro 16-inch'
    fill_in_trix_editor 'Condition Description', with: 'Nearly new with a few scratches'
    fill_in_trix_editor "What's Included", with: 'Charger and case'
    fill_in_trix_editor 'Extra Information', with: 'I have used this no more than 10 times'
    fill_in 'Price Target', with: '2500.00'
    fill_in 'Ticket Price', with: '10.00'
    select 'Tech', from: 'Category'
    select 'New', from: 'Condition'
    fill_in 'End Date', with: 10.days.from_now

    click_button 'Create Raffle'

    assert_text 'Raffle was successfully created'
    assert_text 'MacBook Pro Giveaway'
  end

  test 'entering a raffle' do
    raffle = raffles(:iphone_giveaway)

    login_as(bob)

    visit root_url

    click_link raffle.name

    click_button 'Buy 1 Ticket'

    assert_text 'You have purchased 1 ticket.'
  end
end
