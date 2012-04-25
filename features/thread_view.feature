Feature: View a thread
  As a cojiro user
  I want to view a thread
  So that I can participate in the discussion

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"

  @javascript @wip
  Scenario: View a thread
    Given the following thread exists:
      | user    | csasaki                                                                            |
      | title   | Co-working spaces in Tokyo                                                         |
      | summary | I want to write an an article about the increased popularity of co-working spaces. |
    And I am on the page for the thread "Co-working spaces in Tokyo"
    Then I should see the text "Co-working spaces in Tokyo" in the thread
    And I should see the text "I want to write an an article about the increased popularity of co-working spaces." in the thread
    And I should see the text "csasaki" in the thread
    And I should see the text "Cojiro Sasaki" in the thread
