require 'spec_helper'

# As an organized TV fanatic
# I want to receive an error message if I try to add the same show twice
# So that I don't have duplicate entries

# Acceptance Criteria:
# [] If the title is the same as a show that I've already added, the details are not saved to the csv
# [] If the title is the same as a show that I've already added, I will be shown an error that says "The show has already been added".
# [] If the details of the show are not saved, I will remain on the new form page

feature "accounting for user error" do

  scenario "raise error for entering duplicate titles" do
    visit "/television_shows/new"

    fill_in "Title", with: "Doctor Who"
    fill_in "Network", with: "BBC"
    fill_in "Starting Year", with: "1963"
    fill_in "Synopsis", with: "The Doctor is a renegade Time Lord: an eccentric and highly-intelligent scientist from a distant planet."
    select "Fantasy", from: "Genre"

    click_button "Add TV Show"

    expect(page).to have_content "List of Shows"

    expect(page).to have_content "Doctor Who (BBC)"

    visit "/television_shows/new"

    fill_in "Title", with: "Doctor Who"
    fill_in "Network", with: "BBC"
    fill_in "Starting Year", with: "1963"
    fill_in "Synopsis", with: "The Doctor is a renegade Time Lord: an eccentric and highly-intelligent scientist from a distant planet."
    select "Fantasy", from: "Genre"

    click_button "Add TV Show"

    expect(page).to have_content "The show has already added"

    expect(page).to have_content "Title"
  end
end
