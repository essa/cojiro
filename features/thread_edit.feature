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
      | Title   | Capoeira in Japan and around the world |
      | Summary | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. |

  @javascript
  Scenario: Edit thread title
    When I go to the thread with English title "Capoeira in Japan and around the world"
    And I click on the edit button next to the "title and summary" field
    And I enter the text "Brazilian martial art Capoeira in Japan and around the world" into the "title" field of the overlay
    And I click the save button in the overlay
    Then I should go back to the thread page
    And the title of the thread should be "Brazilian martial art Capoeira in Japan and around the world"

  @javascript
  Scenario: Edit thread title and summary together
    When I go to the thread with English title "Capoeira in Japan and around the world"
    And I click on the edit button next to the "title and summary" field
    And I enter the text "Brazilian martial art Capoeira in Japan and around the world" into the "title" field of the overlay
    And I enter the text "While the martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan." into the "summary" field
    And I click the save button in the overlay
    Then I should go back to the thread page
    And the title of the thread should be "Capoeira in Japan and around the world"
    And the summary of the thread should be "While the martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan."

  @javascript
  Scenario Outline: Tries to save without a title
    When I go to the thread with English title "Capoeira in Japan and around the world"
    And I click on the edit button next to the "title and summary" field
    And I enter the text "" into field of the overlay
    And I click the save button in the overlay
    Then I should see an error message: "There were problems with the following fields:"
    And I should see an error message: "<message>"

    Examples:
      | title   | summary                                             | message        |
      |         | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. | can't be blank |