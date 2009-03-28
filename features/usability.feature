Feature: ARQL usability support

  Scenario: raise column invalid when column name does not exist
    Given users: kuli1, kuli2
    When arql => non_exist_column_name = kuli1
    Then should raise Arql::ColumnInvalid

  Scenario: always quote binding value
    Given users: who'sthis"user`?!@$%^&*-+
    When arql => name = who'sthis"user`?!@$%^&*-+
    Then should find user: who'sthis"user`?!@$%^&*-+
