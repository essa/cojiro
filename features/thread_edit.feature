Feature: Edit thread
  As a curator
  I want to edit a thread I have created
  To keep the thread up-to-date

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And the following thread exists:
      | user    | csasaki                                                                            |
      | title   | Co-working spaces in Tokyo                                                         |
      | summary | I want to write an an article about the increased popularity of co-working spaces. |

  @javascript @wip
  Scenario: User successfully edits thread title
    When I go to the thread "Co-working spaces in Tokyo"
    And I click on the edit button next to "Co-working spaces in Tokyo"
    And I enter "Co-working spaces in Tokyo, Japan"
    Then I should see the text "Co-working spaces in Tokyo, Japan"
    And the title of the thread should be "Co-working spaces in Tokyo, Japan"
