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
    And the "Language" dropdown is "English"
    And I click "Go!"
    Then I should see an error message: "Invalid URL"
    And I should still be on "Add a link" modal dialog

  @javascript
  Scenario: Blank data for 404 URL
    When I click on "Add a link"
    And I enter the link "http://google.com/404.html" into the dialog box
    And the "Language" dropdown is "English"
    And I click "Go!"
    Then the "Title" field should be blank
    And the "Summary" field should be blank
    And the "Comment" field should be blank

  @javascript
  Scenario: Embedly data for valid video URL (oEmbed type: video)
    When I click on "Add a link"
    And I enter the link "http://www.youtube.com/watch?v=Sgf0WcJEYz4" into the dialog box
    And the "Language" dropdown is "Japanese"
    And I click "Go"
    Then I should see a thumbnail image
    And the "Title" field should say  "カポエィラPV CAPOEIRA TEMPO JAPÃO 2005（カポエイラ・カポエラ）"
    And the "Summary" field should say "東京のカポエイラ団体、カポエィラ・テンポの2005年作成PVです。いきなりこんな激しい事は教えないので心配しないで下さい。未経験の人のために作ったクラス、超初級クラスで生徒募集中です。サイトはこちら。レッスンの流れを写真で紹介したり、技の説明動画やブログなどあります。 http://www.capoeiratempo.com"

  @javascript
  Scenario: Embedly data for valid website (oEmbed type: link)
    When I click on "Add a link"
    And I enter the link "http://ripplet.org/2013/04/self-grooming-and-public-transportation-if-you-cant-beat-them-create-a-space-for-them/" into the dialog box
    And the "Language" dropdown is "English"
    And I click "Go"
    Then I should see a thumbnail image
    And the "Title" field should say "Self-grooming and public transportation: If you can't beat them, create a space for them!"
    And the "Summary" field should say "Some people like to complain about young Japanese women doing their makeup on the train. The particular behavior has the dubious honor of being featured twice in Tokyo Metro's monthly manner poster series. Recently designed ladies restrooms in the bigger, "hipper" stations have makeup and changing areas with full length mirrors and little tables."

  @javascript
  Scenario: Embedly data for valid tweet URL (oEmbed providor: Twitter)
    When I click on "Add a link"
    And I enter the link "https://twitter.com/tzs/status/328846992044343296" into the dialog box
    And the "Language" dropdown is "English"
    And I click "Go"
    Then the "Tweet" field should say "[blogged!] Construction workers customize their temporary workplace http://bit.ly/11RsJGI"

  @javascript
  Scenario: Embedly data for valid Photo (oEmbed type: photo)
    When I click on "Add a link"
    And I enter the link "http://www.flickr.com/photos/ripplet/7128327045/in/set-72157629932925953" into the dialog box
    And the "Language" dropdown is "English"
    And I click "Go"
    Then I should see a thumbnail image
    And the "Title" field should say "Sandals"

  @javascript
  Scenario: Already added to cojiro
    When I click on "Add a link"
    And I enter the link "http://www.flickr.com/photos/ripplet/7128327045/in/set-72157629932925953" into the dialog box
    And the "Language" dropdown is "English"
    And I click "Go"
    Then I should see a message "This link is already registed in cojiro."
    And I should see the text "added this link on"
    And I should see the text "Added to"
    And I should see a thumbnail image
    And I should see the text "Sandals"

  @javascript
  Scenario: Editing title
