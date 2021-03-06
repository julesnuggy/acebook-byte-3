# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Messenger', type: :feature do
  scenario 'User can check who is online' do
    sign_up
    click_button 'Inbox'
    click_link 'Send Messages'
    expect(page).to have_content 'Users Online'
  end

  scenario 'User can check whether a specific friend is online' do
    sign_up
    sign_out
    sign_up2
    click_button 'Inbox'
    click_link 'Send Messages'
    expect(page).to have_content 'Tom | send a message'
  end

  scenario 'Users can send a message to a specific friend' do
    users_signup_message('hello')
    expect(page).to have_content('hello')
  end

  scenario 'user can view messages sent to them in Inbox page' do
    users_signup_message('hello matey')
    sign_out
    sign_in
    click_button 'Inbox'
    expect(page).to have_content 'hello matey'
  end

  scenario 'users can see whether a friend they are in a conversation with is online' do
    Capybara.using_session("Jerry's session") do
      sign_up2
    end

    Capybara.using_session("Tom's session") do
      sign_up_send_msg('Hello Jerry')
    end

    Capybara.using_session("Jerry's session") do
      click_button 'Inbox'
      expect(page.find('span', text: 'Tom')[:class].include?('online')).to eq true
    end
  end
end
