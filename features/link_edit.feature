Feature: Edit fields of a link
  As a curator
  I want to edit fields of a link
  So that I can improve the content

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And the following thread exists:
      | user    | csasaki |
      | title   | Capoeira in Japan and around the world |
      | summary | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. |
    And the thread has the following links:
      | user    | source_locale | title                | summary                                                            | url                         |
      | csasaki | en            | Best Capoiera Brazil | Capoeira group in Salvador Bahia Brazil - 'Grupo Engenho da Bahia' | http://youtu.be/6H0D8VaIli0 |
    And I am on the thread "Capoeira in Japan and around the world"

  @javascript
  Scenario: Click to edit title
    When I click on the editable text "Best Capoiera Brazil"
    Then I should see a textarea with "Best Capoiera Brazil" in the link
    And I should see a submit button in the link
    And I should see a cancel button in the link

  @javascript
  Scenario: Edit title
    When I click on the editable text "Best Capoiera Brazil"
    And I enter "Worst Capoiera Brazil" into the textarea in the link
    And I click on the submit button in the link
    And I wait for the AJAX call to finish
    Then I should see the editable text "Worst Capoiera Brazil" in the link
    And I should not see the editable text "Best Capoiera Brazil" in the link
    And there should exist a link with title "Worst Capoiera Brazil" in the database
    And there should not exist a link with title "Best Capoiera Brazil" in the database

  @javascript
  Scenario: Click to edit summary
    When I click on the editable text "Capoeira group in Salvador Bahia Brazil - 'Grupo Engenho da Bahia'"
    Then I should see a textarea with "Capoeira group in Salvador Bahia Brazil - 'Grupo Engenho da Bahia'" in the link
    And I should see a submit button in the link
    And I should see a cancel button in the link

  @javascript
  Scenario: Edit summary
    When I click on the editable text "Capoeira group in Salvador Bahia Brazil - 'Grupo Engenho da Bahia'"
    And I enter "foo" into the textarea in the link
    And I click on the submit button in the link
    And I wait for the AJAX call to finish
    Then I should see the editable text "foo" in the link
    And I should not see the editable text "Capoeira group in Salvador Bahia Brazil - 'Grupo Engenho da Bahia'" in the link
    And there should exist a link with summary "foo" in the database
    And there should not exist a link with summary "Capoeira group in Salvador Bahia Brazil - 'Grupo Engenho da Bahia'" in the database
