Feature: Delete Person
  In order to manage people of a company
  As a user
  I want to destroy a person record

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

  Scenario: Destroy person normally
    When I send a destroy person request for "Jack"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And person "Jack" should not exist

  Scenario: Destroy person with invalid person id
    When I send a GET request to "/persons/10000"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"
    And the JSON response should have "$.message" with the text "person doesn't exist"
