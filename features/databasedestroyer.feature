Feature: Database Destroyer
  Scenario: Destroy database
    When the client sends a DELETE request to '/destroy'
    Then the test database should contain only the seed data