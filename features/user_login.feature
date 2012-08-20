Feature: Login to cojiro
  As a cojiro user
  I want to log in to cojiro
  So that I can add new links and group them in threads

  @javascript @wip
  Scenario: Valid login through Twitter
    Given I am logged into Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And I am on the homepage
    When I click on "Sign in through Twitter"
    Then I should see a link to "csasaki"
    And I should see a link to "Logout"
    And I should not see a link to "Sign in through Twitter"
    And the following user should exist:
      | name     | csasaki        |
      | fullname | Cojiro Sasaki  |

  Scenario Outline: Invalid login
