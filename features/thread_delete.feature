Feature: Delete a thread
  As a cojiro user
  I want to delete a thread that I created
  So that I can close the discussion

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"

  Scenario: User successfully deletes a thread
