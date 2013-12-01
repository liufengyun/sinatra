Feature: Update Company Information
  In order to manage company
  As a user
  I want to update company information

  Background:
    Given I send and accept JSON
    And I have following companies:
      |   name    |     address     |     city     |    country    |     email       |     phone     |
      |  Google   | Street No #23   |   New Yourk  |      USA      | test@example.me |   567-2846    |
      |  Apple    | Street No #22   |   Los Angles |      USA      | ipod@example.me |   111-1111    |

  Scenario: Update company information normally
    When I update company "Google" with following:
      """
      {
        "name": "google",
        "address": "Street No #100",
        "city": "Paris",
        "email": "google@example.me",
        "phone": "222-2222"
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.company.id"
    And the JSON response should have "$.company.name" with the text "google"
    And the JSON response should have "$.company.address" with the text "Street No #100"
    And the JSON response should have "$.company.city" with the text "Paris"
    And the JSON response should have "$.company.country" with the text "USA"
    And the JSON response should have "$.company.email" with the text "google@example.me"
    And the JSON response should have "$.company.phone" with the text "222-2222"

  Scenario: Update company information without invalid company id
    When I send a PUT request to "/companies/10000" with the following:
      """
      {
        "name": "google",
        "address": "Street No #100",
        "city": "Paris",
        "email": "google@example.me",
        "phone": "222-2222"
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"
    And the JSON response should have "$.message" with the text "company doesn't exist"

  Scenario: Update company with required fields empty
    When I update company "Google" with following:
      """
      {
        "name": "",
        "address": "Street No #100",
        "city": "Paris",
        "email": "google@example.me",
        "phone": "222-2222"
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"

