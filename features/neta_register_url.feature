Feature: Register a new URL
  As a curator
  I want to register a new URL
  So that I can add it to a thread

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And the following thread exists:
      | user    | csasaki                                                                            |
      | title   | Capoeira in Japan and around the world |
      | summary | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. |
    And I am on the thread "Capoeira in Japan and around the world"

  @javascript
  Scenario: Invalid URL
    When I click on "Add a link"
    And I enter the link "httpppppp://www.youtube.com" into the dialog box
    And I click "Go!"
    Then I should see an error message: "Invalid URL"
    And I should still be on "Add a link" modal dialog

  @javascript
  Scenario: Blank data for 404 URL
    When I click on "Add a link"
    And I enter the link "http://google.com/404.html" into the dialog box
    And I click "Go!"
    Then the "Language" dropdown should be blank
    And the "Media" dropdown should be blank
    And the "Title" field should be blank
    And the "Summary" field should be blank

  @javascript
  Scenario: Embedly data for valid video URL
    When I click on "Add a link"
    And I enter the link "http://www.youtube.com/watch?v=Sgf0WcJEYz4" into the dialog box
    And I click "Go"
    Then I should see the text: "カポエィラPV CAPOEIRA TEMPO JAPÃO 2005（カポエイラ・カポエラ）"
    And I should see the text: "東京のカポエイラ団体、カポエィラ・テンポの2005年作成PVです。いきなりこんな激しい事は教えないので心配しないで下さい。未経験の人のために作ったクラス、超初級クラスで生徒募集中です。サイトはこちら。レッスンの流れを写真で紹介したり、技の説明動画やブログなどあります。 http://www.capoeiratempo.com"
    Then the "Media" dropdown should be "Video"
    And the "Language" dropdown should be "Japanese"

  @javascript
  Scenario: Embedly data for valid tweet URL

  @javascript
  Scenario: Embedly data for valid website/image URL

  @javascript
  Scenario: Already added to cojiro

  @javascript
  Scenario: Editing title
