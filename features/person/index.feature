Feature: Get Person List
  In order to manage people of a company
  As a user
  I want to get a list of person information

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
      |    Liu    |
      |   Leon    |

  Scenario: Get person list normally with default offset and limit
    When I send a request to get person list of company "Google" with default limit and offset
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.total" with the text "4"
    And the JSON response should have "$.limit" with the text "50"
    And the JSON response should have "$.offset" with the text "0"
    And the JSON response should have "$.persons[*]" with a length of 4
    And the JSON response should have "$.persons[?(@.name=='Jack')].id"
    And the JSON response should have "$.persons[?(@.name=='Jack')].company_id"

  Scenario: Get person list with specified offset and limit
    When I send a request to get person list of company "Google" with limit "2" and offset "1"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.total" with the text "4"
    And the JSON response should have "$.limit" with the text "2"
    And the JSON response should have "$.offset" with the text "1"
    And the JSON response should have "$.persons[*]" with a length of 2
    And the JSON response should have "$.persons[?(@.name=='Smith')].id"
    And the JSON response should have "$.persons[?(@.name=='Smith')].company_id"

  Scenario: Get person list with no company id
    When I send a GET request to "/persons?limit=2&offset=1"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"
    And the JSON response should have "$.message" with the text "company_id is missing"

  Scenario: Get person list with invalid company id
    When I send a GET request to "/persons?company_id=1000&limit=2&offset=1"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "false"
    And the JSON response should have "$.message" with the text "company doesn't exist"
