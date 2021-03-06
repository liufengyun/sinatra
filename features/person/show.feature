Feature: Get Person Information
  In order to manage people of a company
  As a user
  I want to get the detail information of a person

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

  Scenario: Get person information normally
    When I send a get person request for "Jack"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.person.id"
    And the JSON response should have "$.person.name" with the text "Jack"
    And the JSON response should have "$.person.company_id"

  Scenario: Get person information with invalid person id
    When I send a GET request to "/persons/5000"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"
    And the JSON response should have "$.message" with the text "person doesn't exist"
