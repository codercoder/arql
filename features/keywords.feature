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
