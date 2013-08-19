@javascript
Feature: Add link to thread
  As a curator
  I want to add a new link to my thread
  So that I can share and discuss it with others

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

  @vcr
  Scenario: Blank data for 404 URL
    When I click on "Add a link"
    And I enter the link "http://google.com/404.html" into the dialog box
    And I click "Go!"
    And I wait for the AJAX call to finish
    Then the "Title" field should be blank
    And the "Summary" field should be blank
    And the "Comment" field should be blank

  # oEmbed type: video
  @vcr
  Scenario: Embedly data for valid video URL
    When I click on "Add a link"
    And I enter the link "http://www.youtube.com/watch?v=Sgf0WcJEYz4" into the dialog box
    And I click "Go!"
    And I wait for the AJAX call to finish
    And the "Title" field should say "カポエィラPV CAPOEIRA TEMPO JAPÃO 2005（カポエイラ・カポエラ）"
    And the "Summary" field should say "東京のカポエイラ団体、カポエィラ・テンポの2005年作成PVです。いきなりこんな激しい事は教えないので心配しないで下さい。未経験の人のために作ったクラス、超初級クラスで生徒募集中です。サイトはこちら。レッスンの流れを写真で紹介したり、技の説明動画やブログなどあります。 http://www.capoeiratempo.com ..."

  # oEmbed type: link
  @vcr
  Scenario: Embedly data for valid website
    When I click on "Add a link"
    And I enter the link "http://ripplet.org/2013/04/self-grooming-and-public-transportation-if-you-cant-beat-them-create-a-space-for-them/" into the dialog box
    And I click "Go"
    And I wait for the AJAX call to finish
    And the "Title" field should say "Self-grooming and public transportation: If you can't beat them, create a space for them!"
    And the "Summary" field should say "Some people like to complain about young Japanese women doing their makeup on the train. The particular behavior has the dubious honor of being featured twice in Tokyo Metro's monthly manner poster series. Recently designed ladies restrooms in the bigger, "hipper" stations have makeup and changing areas with full length mirrors and little tables."

  # oEmbed provider: Twitter
  @wip
  Scenario: Embedly data for valid tweet URL
    When I click on "Add a link"
    And I enter the link "https://twitter.com/tzs/status/328846992044343296" into the dialog box
    And I click "Go"
    Then the "Tweet" field should say "[blogged!] Construction workers customize their temporary workplace http://bit.ly/11RsJGI"

  # oEmbed type: photo
  @vcr
  Scenario: Embedly data for valid photo
    When I click on "Add a link"
    And I enter the link "http://www.flickr.com/photos/ripplet/7128327045/in/set-72157629932925953" into the dialog box
    And I click "Go"
    And I wait for the AJAX call to finish
    Then the "Title" field should say "Sandals"

  @vcr
  Scenario: Already added to cojiro
    Given the date is "July 8, 2012 at 5pm"
    And the following thread exists:
      | user    | csasaki        |
      | title   | another thread |
      | summary | a summary      |
    And the thread has the following links:
      | user    | source_locale | title   | summary | url                                                                      |
      | csasaki | en            | Sandals |         | http://www.flickr.com/photos/ripplet/7128327045/in/set-72157629932925953 | 
    When I click on "Add a link"
    And I enter the link "http://www.flickr.com/photos/ripplet/7128327045/in/set-72157629932925953" into the dialog box
    And I click "Go"
    And I wait for the AJAX call to finish
#    Then the "Title" field should say "Sandals"
    Then I should see an info message: "This link is already registered in cojiro. It was added by csasaki on July 8, 2012."

  @vcr
  Scenario: Already added to this thread
    Given the date is "July 8, 2012 at 5pm"
    And the thread has the following links:
      | user    | source_locale | title   | summary | url                                                                      |
      | csasaki | en            | Sandals |         | http://www.flickr.com/photos/ripplet/7128327045/in/set-72157629932925953 | 
    # need to reload the page so client has link-thread association info
    And I am on the thread "Capoeira in Japan and around the world"
    When I click on "Add a link"
    And I enter the link "http://www.flickr.com/photos/ripplet/7128327045/in/set-72157629932925953" into the dialog box
    And I click "Go"
    Then I should see an error message: "This link has already been added to this thread."
