@javascript
Feature: Add link to thread
  As a curator
  I want to add a link to my thread
  So that I can share it with other users

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And the following thread exists:
      | user    | csasaki                                |
      | title   | Capoeira in Japan and around the world |
      | summary | The martial art of capoeira originated in Brazil, but is now popular all around the world. There is a particularly vibrant community in Japan. |
    And the thread has the following links:
      | user    | source_locale | title                 | summary | url                         |
      | csasaki | en            | Best Capoeira Brazil  |         | http://youtu.be/6H0D8VaIli0 |
    And I am on the thread "Capoeira in Japan and around the world"

  @vcr
  Scenario: Add link with no changes
    Given I have added the link "http://youtu.be/Z8xxgFpK-NM"
    When I select "English" from the drop-down list
    And I click on "Add to this thread"
    And I wait for the AJAX call to finish
    Then I should see a link with url "http://youtu.be/Z8xxgFpK-NM" in the thread
    And the link element should have the title "The best capoeira video ever"
    #And the link element should have the summary "Capoeiristas Isaak and Bicudinho from the group Senzala de Santos. I don't own this video, I found it at www.d1autremonde.com"
    And I should see a link with url "http://youtu.be/6H0D8VaIli0" in the thread
    And the link element should have the title "Best Capoeira Brazil"
    And I should see that the thread has 2 links

  @vcr
  Scenario: Add link with blank title
    Given I have added the link "http://youtu.be/Z8xxgFpK-NM"
    When I select "English" from the drop-down list
    And I fill in "Title in English" with ""
    And I click on "Add to this thread"
    Then the "Title in English" field should have a red box around it
    Then the "Title in English" field should have an error message "can't be blank"

  @vcr
  Scenario: Add link with new title
    Given I have added the link "http://youtu.be/Z8xxgFpK-NM"
    When I select "English" from the drop-down list
    And I fill in "Title in English" with "foobar title"
    And I click on "Add to this thread"
    And I wait for the AJAX call to finish
    Then I should see a link with url "http://youtu.be/Z8xxgFpK-NM" in the thread
    And the link element should have the title "foobar title"
    #And the link element should have the summary "Capoeiristas Isaak and Bicudinho from the group Senzala de Santos. I don't own this video, I found it at www.d1autremonde.com"

  @vcr
  Scenario: Add link with new summary
    Given I have added the link "http://www.rescue.org/blog/irc-and-capoeira-west-bank"
    When I select "English" from the drop-down list
    And I fill in "Summary in English" with "foobar summary"
    And I click on "Add to this thread"
    And I wait for the AJAX call to finish
    Then I should see a link with url "http://www.rescue.org/blog/irc-and-capoeira-west-bank" in the thread
    And the link element should have the title "Capoeira in the West Bank | International Rescue Committee (IRC)"
    And the link element should have the summary "foobar summary"

  @vcr
  Scenario: Add link with different source locale
    Given I have added the link "http://blogs.yahoo.co.jp/aiteio0110/35349421.html"
    When I select "Japanese" from the drop-down list
    And I click on "Add to this thread"
    And I wait for the AJAX call to finish
    Then I should see a link with url "http://blogs.yahoo.co.jp/aiteio0110/35349421.html" in the thread
    And the link element should have the title "底抜けキッド！ウルティモ・ブログ"
    And the link element should have the summary "７月２１日（日）代々木公園で行われた「ブラジル・フェスティバル２０１３」を見に行く。 前日はラモス瑠偉が来てたりサンバのショーがあったりしたらしい。 ブラジル料理を堪能しようと楽しみにしてたんだけど... この人混み、何じゃこりゃ〜！！ 結局、..."
    And there should exist a link with Japanese title "底抜けキッド！ウルティモ・ブログ" in the database
    And the link should have a Japanese summary "７月２１日（日）代々木公園で行われた「ブラジル・フェスティバル２０１３」を見に行く。 前日はラモス瑠偉が来てたりサンバのショーがあったりしたらしい。 ブラジル料理を堪能しようと楽しみにしてたんだけど... この人混み、何じゃこりゃ〜！！ 結局、..."

  @vcr
  Scenario: Add link with comment
    Given I have added the link "http://youtu.be/Z8xxgFpK-NM"
    When I select "English" from the drop-down list
    And I fill in "Comment" with "This is great!"
    And I click on "Add to this thread"
    And I wait for the AJAX call to finish
    And I hover over the link with url "http://youtu.be/Z8xxgFpK-NM" in the thread
    Then I should see the text "This is great!"
    And I should see the text "@csasaki added less than a minute ago"
