Feature: Get company information
  In order to know more about a company
  As a user
  I want to get detailed information of a company

  Background:
    Given I send and accept JSON
    And I have following companies:
      |   name    |     address     |     city     |    country    |     email       |     phone     |
      |  Google   | Street No #23   |   New Yourk  |      USA      | test@example.me |   567-2846    |
      |  Apple    | Street No #22   |   Los Angles |      USA      | ipod@example.me |   111-1111    |

  Scenario: Get company information normally
    When I send a get company request for "Google"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.company.name" with the text "Google"
    And the JSON response should have "$.company.address" with the text "Street No #23"
    And the JSON response should have "$.company.city" with the text "New Yourk"
    And the JSON response should have "$.company.country" with the text "USA"
    And the JSON response should have "$.company.email" with the text "test@example.me"
    And the JSON response should have "$.company.phone" with the text "567-2846"

  Scenario: Get company information with invalid company id
    When I send a GET request to "/companies/10000"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"
    And the JSON response should have "$.message" with the text "company doesn't exist"
