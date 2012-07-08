Feature: Create new thread
  As a curator
  I want to create a new thread
  So that I can group and share my sources on a topic and discuss them with others

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"

  @javascript
  Scenario: User successfully creates a new thread
    When I create the following thread:
      | Title   | Co-working spaces in Tokyo                                                         |
      | Summary | I want to write an an article about the increased popularity of co-working spaces. |
    And I wait for the AJAX call to finish
    Then I should see the new thread "Co-working spaces in Tokyo"
    And I should see a success message

  @javascript
  Scenario Outline: User tries to create a thread with invalid input
    When I create the following thread:
      | Title   | <title>   |
      | Summary | <summary> |
    Then I should see the new thread page
    And I should see an error message: "There were errors in the information entered."
    And I should see an error message: "<message>"

    Examples:
      | title   | summary                                             | message        |
      |         | I want to write an article about co-working spaces. | can't be blank |
