Feature: Update Person Information
  In order to manage people of a company
  As a user
  I want to update the information of a person

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

  Scenario: update information normally
    When I update person "Jack" with following:
      """
      {
        "name": "Jackie",
        "company_id": <%= Company.where(name: "Apple").first.id %>
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.person.id"
    And the JSON response should have "$.person.name" with the text "Jackie"
    And the JSON response should have "$.person.company_id" with the id of company "Apple"

  Scenario: update information with invalid company id
    When I update person "Jack" with following:
      """
      {
        "name": "Jackie",
        "company_id": 500
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"

  Scenario: Update person information without invalid person id
    When I send a PUT request to "/persons/10000" with the following:
      """
      {
        "name": "Jackie",
        "company_id": <%= Company.where(name: "Apple").first.id %>
      }
      """
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"
    And the JSON response should have "$.message" with the text "person doesn't exist"
