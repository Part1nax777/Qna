require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provie additional info to question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Part1nax777/ca92824f0b92004dfa797d5913b19e54' }
  given(:fail_url) { 'gist.github.com/Part1nax777/ca92824f0b92004dfa797d5913b19e54' }
  given(:test_url) { 'https://gist.github.com/Part1nax777/699babd91935812526a7e09092b61a17' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User not can add invalid link to question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: fail_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
    expect(page).to_not have_link 'My gist'
  end

  scenario 'If link to gist show gist' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_content 'test'
  end
end
