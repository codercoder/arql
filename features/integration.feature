Feature: Integrate ARQL with ActiveRecord

  Scenario: arql and conditions option
    When conditions => name = 'kuli3'
    And arql => name = kuli1 or name = kuli2
    Then should raise Arql::WhyNotArql

  Scenario: arql and limit option
    Given users: kuli1, kuli2, kuli3
    When limit => 1
    And arql => name = 'kuli1' or name = 'kuli3'
    Then should find user: kuli1

  Scenario: find by conditions should work well
    Given users: kuli1, kuli2, kuli3
    When conditions => name = 'kuli3'
    Then should find user: kuli3

  Scenario: Model.find(:first, ...) should work well
    Given users: kuli1, kuli2, kuli3
    When arql => name = 'kuli1' or name = 'kuli3'
    Then find first should be kuli1
