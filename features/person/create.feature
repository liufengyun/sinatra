Feature: Create New User
  In order to manage people of a company
  As a user
  I want to create a new user

  Background:
    Given I send and accept JSON
    And I have following companies:
      |   name    |     address     |     city     |    country    |     email       |     phone     |
      |  Google   | Street No #23   |   New Yourk  |      USA      | test@example.me |   567-2846    |
      |  Apple    | Street No #22   |   Los Angles |      USA      | ipod@example.me |   111-1111    |

  Scenario: Create user normally
    When I send a POST request to "/persons" with the following:
      """
      {
        "name": "Jack",
        "company_id": "<%= Company.where(name: 'Google').first.id %>"
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.person.id"
    And the JSON response should have "$.person.name" with the text "Jack"
    And the JSON response should have "$.person.company_id"

  Scenario: Create user without name
    When I send a POST request to "/persons" with the following:
      """
      {
        "name": "",
        "company_id": "<%= Company.where(name: 'Google').first.id %>"
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"

  Scenario: Create user without company
    When I send a POST request to "/persons" with the following:
      """
      {
        "name": "Jack"
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"
