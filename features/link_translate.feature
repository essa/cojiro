@wip
Feature: Translate fields of a link
  As a curator
  I want to translate fields of a link into my own language
  So that more people can access the content

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "ja"
    And the following thread exists:
      | user    | csasaki                                                                            |
      | title   | Capoeira in Japan and around the world |
      | summary | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. |
    And I am on the thread "Capoeira in Japan and around the world"

  @javascript
  Scenario: Add title in Japanese
  When I click on the "日本語を追加する" link under the text "A piece of capoeira in Cameroon"
  And I add the text "カメルーンにおけるカポエイラ"
  And click the save button
  Then I should see the text "カメルーンにおけるカポエイラ"

  @javascript
  Scenario: Edits title in Japanese
  When I click on the edit icon above the text "カメルーンにおけるカポエイラ"
  And I add the text "カメルーンにおけるカポエイラの事情"
  And click the save button
  Then I should see the text "カメルーンにおけるカポエイラの事情"

