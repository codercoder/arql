Feature: ARQL usability support

  Scenario: raise column invalid when column name does not exist
    Given users: kuli1, kuli2
    When arql => non_exist_column_name = kuli1
    Then should raise Arql::ColumnInvalid

