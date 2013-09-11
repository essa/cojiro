@javascript
Feature: View a thread
  As a cojiro user
  I want to view a thread
  So that I can participate in the discussion

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And the following users exist:
      | name      | fullname            |
      | alice     | Alice in Wonderland |
    And my locale is "en"

  Scenario: View a thread
    Given the date is "July 8, 2012 at 5pm"
    And the following thread exists:
      | user    | csasaki                                                                            |
      | title   | Co-working spaces in Tokyo                                                         |
      | summary | I want to write an article about the increased popularity of co-working spaces. |
    And the thread has the following links:
      | user    | source_locale | title                 | summary | url                         |
      | alice   | en            | Best Capoeira Brazil  |         | http://youtu.be/6H0D8VaIli0 |

    When I go to the page for the thread
    Then I should see the text "Co-working spaces in Tokyo" in the thread
    And I should see the text "I want to write an article about the increased popularity of co-working spaces." in the thread
    And I should see the text "Cojiro Sasaki" in the statbar
    And I should see the text "July 8, 2012" in the statbar
    And I should see the avatar of "alice" in the statbar

  Scenario: View a thread translation
    Given the date is "July 8, 2012 at 5pm"
    And the following thread exists:
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
    And I should see the text "2012年7月8日" in the thread
