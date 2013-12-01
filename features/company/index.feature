Feature: Get Company List
  In order to manage company
  As a user
  I want to see the company list

  Background:
    Given I send and accept JSON
    And I have following companies:
      |   name    |     address     |     city     |    country    |     email       |     phone     |
      |  Google   | Street No #23   |   New Yourk  |      USA      | test@example.me |   567-2846    |
      |  Apple    | Street No #22   |   Los Angles |      USA      | ipod@example.me |   111-1111    |
      |  IBM      | Street No #25   |   Tokyo      |      JP       | ibm@example.me  |   222-2222    |
      |  Yahoo    | Street No #28   |   Berlin     |      Germany  | yaho@example.me |   333-3333    |

  Scenario: Get company list normally with default offset and limit
    When I send a GET request to "/companies"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.total" with the text "4"
    And the JSON response should have "$.limit" with the text "50"
    And the JSON response should have "$.offset" with the text "0"
    And the JSON response should have "$.companies[*]" with a length of 4
    And the JSON response should have "$.companies[?(@.name=='Google')].address" with the text "Street No #23"
    And the JSON response should have "$.companies[?(@.name=='Google')].city" with the text "New Yourk"
    And the JSON response should have "$.companies[?(@.name=='Google')].country" with the text "USA"
    And the JSON response should have "$.companies[?(@.name=='Google')].email" with the text "test@example.me"
    And the JSON response should have "$.companies[?(@.name=='Google')].phone" with the text "567-2846"

  Scenario: Get company with specified offset and limit
    When I send a GET request to "/companies?limit=2&offset=1"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.total" with the text "4"
    And the JSON response should have "$.limit" with the text "2"
    And the JSON response should have "$.offset" with the text "1"
    And the JSON response should have "$.companies[*]" with a length of 2
    And the JSON response should have "$.companies[?(@.name=='IBM')].address" with the text "Street No #25"
    And the JSON response should have "$.companies[?(@.name=='IBM')].city" with the text "Tokyo"
    And the JSON response should have "$.companies[?(@.name=='IBM')].country" with the text "JP"
    And the JSON response should have "$.companies[?(@.name=='IBM')].email" with the text "ibm@example.me"
    And the JSON response should have "$.companies[?(@.name=='IBM')].phone" with the text "222-2222"
