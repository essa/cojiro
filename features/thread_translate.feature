Feature: Translate a thread
  As a cojiro user
  I want to translate a thread
  So that I can share it with readers of another language

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And the following thread exists:
      | user    | csasaki                                                                            |
      | title   | 東京におけるコワーキングスペース                                                         |
      | summary | 最近、人気上昇中のコワーキングスペースのまとめ記事を書きたいと思っています。　|
      | language | Japanese　|

  @javascript
  Scenario: User adds title and summary in their interface language 
    When I go to the thread with Japanese title "東京におけるコワーキングスペース"
    And I click on "Edit title and summary"
    And I enter the text "Coworking spaces in Tokyo" into the "title" field
    And I enter the text "Help me write an article about the different coworking spaces that are popping up in Tokyo" into the "summary" field
    And I click the save button in the overlay
    Then I should go back to the thread page
    And the title of the thread should be "Coworking spaces in Tokyo"
    And the summary of the thread should be "Help me write an article about the different coworking spaces that are popping up in Tokyo"

  @javascript
  Scenario Outline: User tries to add title/summary with invalid input
    When I go to the thread with Japanese title "東京におけるコワーキングスペース"
    And I click on "Edit title and summary"
    And I click the save button in the overlay
    Then I should see the error message: "There were problems with the following fields:"
    And I should see an error message: "<message>"

    Examples:
      | title   | summary                                             | message |
      |         | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. | can't be blank |