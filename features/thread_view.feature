Feature: View a thread
  As a cojiro user
  I want to view a thread
  So that I can participate in the discussion

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"

  @javascript
  Scenario: View a thread
    Given the following thread exists:
      | user    | csasaki                                                                            |
      | title   | Co-working spaces in Tokyo                                                         |
      | summary | I want to write an article about the increased popularity of co-working spaces. |
    When I go to the page for the thread
    Then I should see the text "Co-working spaces in Tokyo" in the thread
    And I should see the text "I want to write an article about the increased popularity of co-working spaces." in the thread
    And I should see the text "csasaki" in the thread
    And I should see the text "Cojiro Sasaki" in the thread

  @javascript
  Scenario: View a thread translation
    Given the following thread exists:
      | user    | csasaki                                                                            |
      | title   | Co-working spaces in Tokyo                                                         |
      | summary | I want to write an article about the increased popularity of co-working spaces. |
    And it has the following translations to "ja":
      | title   | 東京のコワーキングスペース |
      | summary | 最近のコワーキングスペースの人気さについて記事を書きたいと思います。|
    When I switch my locale to "ja"
    And I go to the page for the thread
    Then I should see the text "東京のコワーキングスペース" in the thread
    And I should see the text "最近のコワーキングスペースの人気さについて記事を書きたいと思います。" in the thread
