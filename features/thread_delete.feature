Feature: Delete a thread
  As a cojiro user
  I want to delete a thread that I created
  So that I can close the discussion

  @javascript @wip
  Scenario: User successfully deletes a thread
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And the following thread exists:
      | user    | csasaki                                                                            |
      | Title   | Capoeira in Japan and around the world |
      | Summary | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. |
    When I click on the edit button next to the "title and summary" field
    And I click the delete link
    Then I should see the homepage
    And I should see a success message: "Thread "Capoeira in Japan and around the world" deleted."

  @javascript @wip
  Scenario: User cannot delete a thread they didn't create deletes a thread
    Given I am logged in through Twitter as the following user:
      | name     | Tomomi Sasaki |
      | uid      | 12345         |
      | nickname | tsasaki       |
    And my locale is "en"
    And the following thread exists:
      | user    | csasaki                                                                            |
      | Title   | Capoeira in Japan and around the world |
      | Summary | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. |
    When I click on the edit button next to the "title and summary" field
    Then I should not see the text "delete"
