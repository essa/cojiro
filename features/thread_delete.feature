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
      | title   | Co-working spaces in Tokyo                                                         |
      | summary | I want to write an an article about the increased popularity of co-working spaces. |
    When I delete the thread "Co-working spaces in Tokyo"
    Then I should see the homepage
    And I should see a success message: "Thread "Co-working spaces in Tokyo" deleted."
