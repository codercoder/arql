Feature: ARQL supported keywords

  Scenario: Or keyword
    Given users: kuli1, kuli2
    When arql => name = kuli1 or name = kuli2
    Then should find kuli1, kuli2

  Scenario: And keyword
    Given users: kuli1, kuli2
    When arql => name = kuli1 and name = kuli2
    Then should find ,

  Scenario: Less than keyword
    Given users: kuli1, kuli2
    When arql => id < 2
    Then should find kuli1

  Scenario: More than keyword
    Given users: kuli1, kuli2
    When arql => id > 1
    Then should find kuli2
