Feature: Homepage for logged-out users
  As a casual reader
  I want to see the latest threads
  So that I find topics that are of interest to me

  Background:
    Given the following threads exist:
      | user    | title                      | summary                                                                           |
      | csasaki | Co-working spaces in Tokyo | I want to write an article about the increasing popularity of co-working spaces." |

  @javascript
  Scenario: View latest threads
    Given my locale is "en"
    And I am on the homepage
    Then I should see the text "Co-working spaces in Tokyo" in the threads list
    And I should see a note "Updated less than a minute ago" next to the thread "Co-working spaces in Tokyo" in the threads list
    #And I should see a "New" tag next to the thread "Co-working spaces in Tokyo"

  @javascript
  Scenario: View latest threads in another language
    Given my locale is "ja"
    And I am on the homepage
    Then I should see the untranslated text "Co-working spaces in Tokyo" in the threads list
