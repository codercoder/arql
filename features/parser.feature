Feature: ARQL parser

  Scenario Outline: Parse identifiers
    Given users: kuli1
    When parse with user model: <arql>
    Then should output: <options>
  Examples:
    | arql | options |
    | name = kuli1 | {:conditions => "'users'.'name' = 'kuli1'"} |
    | id = 1 | {:conditions => "'users'.'id' = 1"} |
