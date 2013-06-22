Feature: Edit fields of a neta
  As a curator
  I want to edit fields of a neta
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
      | user    | title                | summary                                                            | url                         |
      | csasaki | Best Capoiera Brazil | Capoeira group in Salvador Bahia Brazil - 'Grupo Engenho da Bahia' | http://youtu.be/6H0D8VaIli0 |
    And I am on the thread "Capoeira in Japan and around the world"

  @javascript
  Scenario: Editing title
    Then I should see the text "Best Capoiera Brazil"

  @javascript
  Scenario: Editing summary
