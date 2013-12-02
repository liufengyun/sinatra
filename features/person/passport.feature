Feature: Manage passports
  In order to manage people of a company
  As a user
  I want to manage passports of persons

  Background:
    Given I send and accept JSON
    And I have following companies:
      |   name    |     address     |     city     |    country    |     email       |     phone     |
      |  Google   | Street No #23   |   New Yourk  |      USA      | test@example.me |   567-2846    |
      |  Apple    | Street No #22   |   Los Angles |      USA      | ipod@example.me |   111-1111    |
    And I have following people for company "Google":
      |   name    |
      |   Jack    |
      |  Smith    |

  Scenario: Attach a passport
    When I attch file "test.txt" for "Jack"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.person.id"
    And the JSON response should have "$.person.name" with the text "Jack"
    And the JSON response should have "$.person.company_id"
    And the JSON response should have "$.person.passport_url"
    And the JSON response should have "$.person.passport_file_name" with the text "test.txt"
    And the file "test.txt" should exist for "Jack"

  Scenario: Detach a passport
    Given I attch file "test.txt" for "Jack"
    When I detach the file for "Jack"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.person.id"
    And the JSON response should have "$.person.name" with the text "Jack"
    And the JSON response should have "$.person.company_id"
    And the JSON response should not have "$.person.passport_url"
    And the file "test.txt" should not exist for "Jack"
    And the JSON response should have "$.person.passport_file_name" with the text ""

  Scenario: Detach passport when nothing attached
    When I detach the file for "Jack"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"
    And the JSON response should have "$.message" with the text "passport doesn't exist"
