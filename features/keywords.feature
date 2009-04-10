Feature: ARQL supported keywords

  Scenario: Or keyword
    Given users: kuli1, kuli2
    When arql => name = kuli1 or name = kuli2
    Then should find user: kuli1, kuli2

  Scenario: And keyword
    Given users: kuli1, kuli2
    When arql => name = kuli1 and name = kuli2
    Then should find user: ,

  Scenario: Less than keyword
    Given users: kuli1, kuli2
    When arql => id < 2
    Then should find user: kuli1

  Scenario: More than keyword
    Given users: kuli1, kuli2
    When arql => id > 1
    Then should find user: kuli2

  Scenario: nil keyword
    Given users: kuli1, kuli2
    And kuli1 is admin
    When arql => admin = nil
    Then should find user: kuli2

  Scenario: != nil keyword
    Given users: kuli1, kuli2
    And kuli1 is admin
    When arql => admin != nil
    Then should find user: kuli1

  Scenario: Only support = and != with nil
    Given users: kuli1, kuli2
    And kuli1 is admin
    When arql => admin > nil
    Then should raise Arql::OperatorInvalid

  Scenario: Operator !=
    Given users: kuli1, kuli2
    And kuli1 is admin
    When arql => admin != true
    Then should find user: kuli2

  Scenario: Operator != on number
    Given users: kuli1, kuli2, kuli3
    And kuli1's age is 5
    And kuli3's age is 1
    When arql => age != 5
    Then should find user: kuli2, kuli3
    
  Scenario Outline: Operator >= on number
    Given users: kuli1, kuli2, kuli3
    And kuli1's age is 5
    And kuli3's age is 1
    When arql => <condition>
    Then should find user: <result>  
  Examples:
    | condition | result |
    | age >= 6 |  |
    | age >= 5 | kuli1 |
    | age >= 4 | kuli1 |
    | age >= 3 | kuli1 |
    | age >= 2 | kuli1 |
    | age >= 1 | kuli1, kuli3 |
    | age >= 0 | kuli1, kuli3 |
    | age >= -1 | kuli1, kuli3 |
    
  Scenario Outline: Operator <= on number
    Given users: kuli1, kuli2, kuli3
    And kuli1's age is 5
    And kuli3's age is 1
    When arql => <condition>
    Then should find user: <result>  
  Examples:
    | condition | result |
    | age <= 6 | kuli1, kuli3 |
    | age <= 5 | kuli1, kuli3 |
    | age <= 4 | kuli3 |
    | age <= 3 | kuli3 |
    | age <= 2 | kuli3 |
    | age <= 1 | kuli3 |
    | age <= 0 |  |
  
