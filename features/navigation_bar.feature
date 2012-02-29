Feature: Navigation bar
  As a cojiro user
  I want to navigate the cojiro website
  So that I can easily find the threads that I want to read 

  Background:
    Given my locale is "en"

  Scenario Outline: Logged-out user
    When I go to the <page>
    Then I should see a link to "<link>" in the navigation bar

    Examples:
      | page      | link                    |
      | homepage  | Sign in through Twitter |

  Scenario Outline: Logged-in user
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    When I go to the <page>
    Then I should see a link to "<link>" in the navigation bar

    Examples:
      | page      | link               |
      | homepage  | Start a thread |
