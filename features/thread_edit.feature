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

  @javascript
  Scenario: Edit thread title
    When I go to the thread with English title "Co-working spaces in Tokyo"
    And I click on the edit button next to the "title" field
    And I enter the text "Tokyo's co-working spaces" into the "title" field
    And I click the save button next to the "title" field
    Then I should see the translated text "Tokyo's co-working spaces" in the thread
    And the title of the thread should be "Tokyo's co-working spaces"

  @javascript
  Scenario: Edit thread title and summary together
    When I go to the thread with English title "Co-working spaces in Tokyo"
    And I click on the edit button next to the "title" field
    And I click on the edit button next to the "summary" field
    And I enter the text "Tokyo's co-working spaces" into the "title" field
    And I enter the text "a new summary" into the "summary" field
    And I click the save button next to the "title" field
    And I click the save button next to the "summary" field
    Then I should see the translated text "Tokyo's co-working spaces" in the thread
    And I should see the translated text "a new summary" in the thread
    And the title of the thread should be "Tokyo's co-working spaces"
    And the summary of the thread should be "a new summary"
