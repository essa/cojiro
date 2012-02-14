Feature: Create new thread
  As a curator
  I want to create a new thread
  So that I can group and share my sources on a topic and discuss them with others

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | csasaki       |
      | uid      | 12345         |
      | nickname | Cojiro Sasaki |
    And my locale is "en"

  Scenario: User successfully creates a new thread
    When I create the following thread:
      | Title   | Co-working spaces in Tokyo                                                         |
      | Summary | I want to write an an article about the increased popularity of co-working spaces. |
    Then I should see the new thread "Co-working spaces in Tokyo"
    #    And I should see a success message

  @wip
  Scenario Outline: User tries to create a thread with invalid input
    When I create the following thread:
      | Title   | <title>   |
      | Summary | <summary> |
    Then I should see the new thread page
    And I should see an error message "<message>"

    Examples:
      | title   | summary                                             | message        |
      |         | I want to write an article about co-working spaces. | can't be blank |
