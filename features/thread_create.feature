Feature: Create new thread
  As a curator
  I want to create a new thread
  So that I can group and share my sources on a topic and discuss them with others

  Background:
    Given the following Twitter users:
      | uid   | name    | nickname |
      | 12345 | csasaki | csasaki  |

  @wip
  Scenario: User successfully creates a new thread
    Given I am logged in through Twitter as "csasaki"
    When I create the following thread:
      | title   | Co-working spaces in Tokyo |
      | summary | I want to write an an article about the increased popularity of co-working spaces. |
    Then I should see the new thread "Co-working spaces in Tokyo"
    And I should see a success message

  @wip
  Scenario Outline: User tries to create a thread with invalid input
    Given I am logged in through Twitter as "csasaki"
    When I create the following thread:
      | title   | <title>   |
      | summary | <summary> |
    Then I should see the new thread page
    And I should see an error message "<message>"

    Examples:
      | title   | summary                                             | message        |
      |         | I want to write an article about co-working spaces. | can't be blank |
