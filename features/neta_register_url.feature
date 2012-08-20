Feature: Register a new URL
  As a curator
  I want to register a new URL
  So that I can add it to a thread

  @javascript @wip
  Scenario: Prefill embed data for URL
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And the following thread exists:
      | user    | csasaki                                                                            |
      | title   | Co-working spaces in Tokyo                                                         |
      | summary | I want to write an an article about the increased popularity of co-working spaces. |
    And I am on the thread "Co-working spaces in Tokyo"
    When I click on the "Add new neta" link
    And I enter the link "http://happymonster.co/2011/08/22/coworking-in-tokyo-shanghai-and-hong-kong/" into the dialog box
    Then I should see the text: "Coworking in Tokyo, Shanghai, and Hong Kong | HappyMonster"
    And I should see the text: "Well, that was awesome. Below are my brief reports on the spaces I visited, along with a few thoughts along the way."
