@wip @javascript
Feature: Change language settings
  As a cojiro user
  I want to change my settings
  So that I can customize how content is displayed

  Background:
    Given I am logged into Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And the following thread exists:
      | user    | csasaki                                                                            |
      | title   | Capoeira in Japan and around the world |
      | summary | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. |
    And the following neta exists:
      | title   | 東京のカポエイラ大会映像 |
      | summary | 東京で開催されたカポエイラ大会の貴重な映像です。 |
      | language | Japanese|

  Scenario: User changes their interface language
    When I go to the thread with English title "Capoeira in Japan and around the world"
    And I click on a language link in the right corner
    And I select "Japanese" in the "Cojiro interface" dropdown
    And I click the save button in the overlay
    Then I should go back to the home page
    And I should see the text "スレッドの新規作成"

  Scenario: User adds a content language
    When I go to the thread with English title "Capoeira in Japan and around the world"
    And I click on a language link in the right corner
    And I select "Japanese" next to the text "Turn on highlights for links in"
    And I click the save button in the overlay
    Then I should go back to the home page
    And I should see the text "東京で開催されたカポエイラ大会の貴重な映像です。"
