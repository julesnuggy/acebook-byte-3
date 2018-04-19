# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Messenger', type: :feature do
  scenario 'User can check who is online' do
    sign_up
    click_button 'Messenger'
    expect(page).to have_content 'Users Online'
  end

  scenario 'User can check whether a specific friend is online' do
    sign_up
    sign_out
    sign_up2
    click_button 'Messenger'
    expect(page).to have_content 'Tom | send a message'
  end

  scenario 'Users can send a message to a specific friend' do
    sign_up
    sign_out
    sign_up2
    click_button 'Messenger'
    within('ul') do
      within('li.Tom') do
        click_link 'send a message'
      end
    end
    fill_in 'personal_message[body]', with: 'hello'
    click_button 'Create Personal message'
    expect(page).to have_content('hello')
  end

  scenario 'user can view messages sent to them in Inbox page' do
    sign_up
    sign_out
    sign_up2
    click_button 'Messenger'
    within('ul') do
      within('li.Tom') do
        click_link 'send a message'
      end
    end
    fill_in 'personal_message[body]', with: 'hello matey'
    click_button 'Create Personal message'
    sign_out
    login
    click_button 'Messenger'
    click_link 'Inbox'
    exactly(page).to have_content 'hello matey'
  end
end
