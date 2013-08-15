# encoding: utf-8
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
      | user    | source_locale | title | summary | url |
      | csaaski | ja | カポエイラ | カポエイラは、ブラジルの腿法。相手に蹴りや攻撃を当ててしまうものは下手とされ、基本的に相手には触れず、プレッシャーをかけてゆく。 | https://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%9D%E3%82%A8%E3%82%A4%E3%83%A9 |
      | csasaki | en | Capoeira on Wikipedia | Wikipedia article on Capoiera. | https://en.wikipedia.org/wiki/Capoeira |
    And I am on the thread "Capoeira in Japan and around the world"

  @javascript
  Scenario: Click to edit title
    When I click on the editable text "Capoeira on Wikipedia"
    Then I should see a textarea with "Capoeira on Wikipedia" in the link
    And I should see a submit button in the link
    And I should see a cancel button in the link

  @javascript
  Scenario: Edit title
    When I click on the editable text "Capoeira on Wikipedia"
    And I enter "Wikipedia article on Capoeira" into the textarea in the link
    And I click on the submit button in the link
    And I wait for the AJAX call to finish
    Then I should see the editable text "Wikipedia article on Capoiera" in the link
    And I should not see the editable text "Capoiera on Wikipedia" in the link
    And there should exist a link with title "Wikipedia article on Capoeira" in the database
    And there should not exist a link with title "Capoeira on Wikipedia" in the database

  @javascript
  Scenario: Click to edit summary
    When I click on the editable text "Wikipedia article on Capoiera."
    Then I should see a textarea with "Wikipedia article on Capoiera." in the link
    And I should see a submit button in the link
    And I should see a cancel button in the link

  @javascript
  Scenario: Edit summary
    When I click on the editable text "Wikipedia article on Capoiera."
    And I enter "foo" into the textarea in the link
    And I click on the submit button in the link
    And I wait for the AJAX call to finish
    Then I should see the editable text "foo" in the link
    And I should not see the editable text "Wikipedia article on Capoiera." in the link
    And there should exist a link with summary "foo" in the database
    And there should not exist a link with summary "Wikipedia article on Capoiera." in the database
