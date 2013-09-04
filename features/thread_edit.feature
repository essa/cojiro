@javascript
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
      | title   | Capoeira in Japan and around the world |
      | summary | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. |

  Scenario: Edit thread title
    When I go to the thread with English title "Capoeira in Japan and around the world"
    And I click on the edit button in the statbar
    And I fill in "Title in English" with "foo"
    And I click "Save"
    And I wait for the AJAX call to finish
    Then I should see the text "foo" in the thread
    And the title of the thread should be "foo"

  Scenario: Edit thread title and summary together
    When I go to the thread with English title "Capoeira in Japan and around the world"
    And I click on the edit button in the statbar
    And I fill in "Title in English" with "foo title"
    And I fill in "Summary in English" with "bar summary"
    And I click "Save"
    And I wait for the AJAX call to finish
    Then I should see the text "foo title" in the thread
    Then I should see the text "bar summary" in the thread
    And the title of the thread should be "foo title"
    And the summary of the thread should be "bar summary"

  Scenario: Tries to save without a title
    When I go to the thread with English title "Capoeira in Japan and around the world"
    And I click on the edit button in the statbar
    And I fill in "Title in English" with ""
    And I click "Save"
    Then I should see an error message "can't be blank" on the "Title" field
