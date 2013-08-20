@javascript
Feature: Logout of cojiro
  As a cojiro user
  I want to logout of my account
  So that I can do something else

  Scenario: Successful logout
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And I am on the homepage
    When I click on "@csasaki"
    And I click on "Logout"
    Then I should see a link to "Sign in through Twitter"
    And I should not see a link to "csasaki"
    And I should not see a link to "Logout"
