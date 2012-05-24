Feature: View latest threads
  As a casual reader
  I want to see the latest threads
  So that I find topics that are of interest to me

  Background:
    Given the following threads exist:
      | user    | title                      | summary                                                                           |
      | csasaki | Co-working spaces in Tokyo | I want to write an article about the increasing popularity of co-working spaces." |
    And my locale is "en"

  @javascript
  Scenario: View latest threads
    Given I am on the homepage
    Then I should see the text "Co-working spaces in Tokyo" in the threads list
