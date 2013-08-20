@javascript
Feature: Add link to thread
  As a curator
  I want to add a link to my thread
  So that I can share it with other users

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And the following thread exists:
      | user    | csasaki                                |
      | title   | Capoeira in Japan and around the world |
      | summary | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. |
    And the thread has the following links:
      | user    | source_locale | title                 | summary | url                         |
      | csasaki | en            | Best Capoeira Brazil  |         | http://youtu.be/6H0D8VaIli0 |
    And I am on the thread "Capoeira in Japan and around the world"
    And I have added the link "http://youtu.be/Z8xxgFpK-NM"

  @vcr
  Scenario: Add link with no source locale
    When I click on "Add to this thread"
    Then the "This link is in" field should have a red box around it
    Then the "This link is in" field should have an error message "can't be blank"

  @vcr
  Scenario: Add link with no changes
    When I select "English" from the drop-down list
    And I click on "Add to this thread"
    And I wait for the AJAX call to finish
    Then I should see a link with url "http://youtu.be/Z8xxgFpK-NM" in the thread
    And the link should have the title "The best capoeira video ever"
    And the link should have the summary "Capoeiristas Isaak and Bicudinho from the group Senzala de Santos. I don't own this video, I found it at www.d1autremonde.com"
    And I should see a link with url "http://youtu.be/6H0D8VaIli0" in the thread
    And the link should have the title "Best Capoeira Brazil"
    And I should see that the thread has 2 links

  @vcr
  Scenario: Add link with blank title
    When I select "English" from the drop-down list
    And I fill in "Title in English" with ""
    And I click on "Add to this thread"
    Then the "Title in English" field should have a red box around it
    Then the "Title in English" field should have an error message "can't be blank"

  @vcr
  Scenario: Add link with new title
    When I select "English" from the drop-down list
    And I fill in "Title in English" with "foobar title"
    And I click on "Add to this thread"
    Then I should see a link with url "http://youtu.be/Z8xxgFpK-NM" in the thread
    And the link should have the title "foobar title"
    And the link should have the summary "Capoeiristas Isaak and Bicudinho from the group Senzala de Santos. I don't own this video, I found it at www.d1autremonde.com"

  @vcr
  Scenario: Add link with new summary
    When I select "English" from the drop-down list
    And I fill in "Summary in English" with "foobar summary"
    And I click on "Add to this thread"
    Then I should see a link with url "http://youtu.be/Z8xxgFpK-NM" in the thread
    And the link should have the title "The best capoeira video ever"
    And the link should have the summary "foobar summary"
