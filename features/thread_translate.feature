Feature: Translate a thread
  As a cojiro user
  I want to translate a thread
  So that I can share it with readers of another language

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And the following thread exists:
      | user    | csasaki                                                                            |
      | title   | Co-working spaces in Tokyo                                                         |
      | summary | I want to write an article about the increased popularity of co-working spaces. |

  @javascript
  Scenario: View translated attributes of a thread
    When I go to the thread with English title "Co-working spaces in Tokyo"
    Then I should see the translated text "Co-working spaces in Tokyo" in the thread
    And I should see the translated text "I want to write an article about the increased popularity of co-working spaces." in the thread

  @javascript
  Scenario: Find untranslated attributes of a thread
    When I switch my locale to "ja"
    And I go to the thread with English title "Co-working spaces in Tokyo"
    Then I should see the untranslated text "Co-working spaces in Tokyo" in the thread
    And I should see the untranslated text "I want to write an article about the increased popularity of co-working spaces." in the thread
