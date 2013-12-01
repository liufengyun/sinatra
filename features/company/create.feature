Feature: Create Company
  In order to manage company
  As a user
  I want to create a new company

  Background:
    Given I send and accept JSON

  Scenario: Create company normally
    When I send a POST request to "/companies" with the following:
      """
      {
        "name": "Google",
        "address": "Street No #23",
        "city": "New York",
        "country": "USA",
        "email": "test@example.me",
        "phone": "567-2846"
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.company.id"
    And the JSON response should have "$.company.name" with the text "Google"
    And the JSON response should have "$.company.address" with the text "Street No #23"
    And the JSON response should have "$.company.city" with the text "New York"
    And the JSON response should have "$.company.country" with the text "USA"
    And the JSON response should have "$.company.email" with the text "test@example.me"
    And the JSON response should have "$.company.phone" with the text "567-2846"

  Scenario: Get company with required fields missing
    When I send a POST request to "/companies" with the following:
      """
      {
        "name": "",
        "address": "Street No #23",
        "city": "New York",
        "country": "USA",
        "email": "test@example.me",
        "phone": "567-2846"
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"
