Feature: Homepage for logged-in users
  As a cojiro user
  I want to see the latest threads
  So that I can find threads to contribute to

  Background:
    Given I am logged in through Twitter as the following user:
      | name     | Cojiro Sasaki |
      | uid      | 12345         |
      | nickname | csasaki       |
    And my locale is "en"
    And the following users exist:
      | name      | fullname         |
      | mmiyamoto | Mihashi Miyamoto |
    And the following threads exist:
      | user      | title                      | summary                                                                           |
      | csasaki   | Co-working spaces in Tokyo | I want to write an article about the increasing popularity of co-working spaces." |
      | mmiyamoto | Geisha bloggers            | A thread about geisha bloggers. |

  @javascript
  Scenario: View threads that I started
    Given I am on the homepage
    And I select "threads that I started" from the drop-down list
    Then I should see the text "Co-working spaces in Tokyo"
    But I should not see the text "Geisha blogggers"

  @javascript @wip
  Scenario: View threads that I joined
