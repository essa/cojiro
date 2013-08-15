# encoding: utf-8
Feature: Translate fields of a link
  As a curator
  I want to translate fields of a link into my own language
  So that more people can access the content

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
      | user    | source_locale | title | summary | url |
      | csaaski | ja | カポエイラ - ウィキペディア | カポエイラは、ブラジルの腿法。相手に蹴りや攻撃を当ててしまうものは下手とされ、基本的に相手には触れず、プレッシャーをかけてゆく。 | https://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9 |
      | csasaki | en | Capoeira on Wikipedia | Wikipedia article on Capoiera. | https://en.wikipedia.org/wiki/Capoeira |
    And I am on the thread "Capoeira in Japan and around the world"

  @javascript
  Scenario: Click to translate title
    When I click on the editable text "カポエイラ - ウィキペディア"
    Then I should see a textarea with "" in the link
    And I should see a popover with "カポエイラ - ウィキペディア"
    And I should see a submit button in the link
    And I should see a cancel button in the link
