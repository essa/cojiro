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
      | Title   | Capoeira in Japan and around the world |
      | Summary | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. |
    And I wait for the AJAX call to finish
    Then I should see the new thread "Capoeira in Japan and around the world"
    And I should see a success message: "Thread successfully created."

  @javascript
  Scenario Outline: User tries to create a thread with invalid input
    When I create the following thread:
      | Title   | <title>   |
      | Summary | <summary> |
    Then I should see the new thread page
    And I should see an error message: "There were problems with the following fields:"
    And I should see an error message: "<message>"

    Examples:
      | title   | summary                                             | message        |
      |         | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. | can't be blank |