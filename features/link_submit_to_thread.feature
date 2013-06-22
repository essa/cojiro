@wip
Feature: Add my link to a thread
  As a curator
  I want to submit an edited link
  So that I can add it to a thread

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
    And I am on the thread "Capoeira in Japan and around the world"
    And I have added the link "http://ripplet.org/2013/04/self-grooming-and-public-transportation-if-you-cant-beat-them-create-a-space-for-them/" through the "Add a link" modal dialog

  @javascript
  Scenario: Success
    When I click on "Add to this thread"
    Then I should be on the thread "Capoeira in Japan and around the world"
    And I should see a message: "Added link"

  @javascript
  Scenario: Cancel
    When I click on "Cancel"
    Then I should be on the thread "Capoeira in Japan and around the world"
