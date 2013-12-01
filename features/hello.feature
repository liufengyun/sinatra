Feature: Hello
  In order to test server
  As a user
  I want to say hello to server

  Scenario: Say hello to server
    When I send a GET request for "/hello"
    Then the response status should be "200"
    And the JSON response should have "$.success" with the text "true"
    And the JSON response should have "$.message" with the text "hello world"
