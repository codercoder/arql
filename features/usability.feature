Feature: ARQL usability support

  Scenario: raise column invalid when column name does not exist
    Given users: kuli1, kuli2
    When arql => non_exist_column_name = kuli1
    Then should raise Arql::ColumnInvalid

  Scenario: always quote binding value
    Given users: who'sthis"user`?!@$%^&*-+
    When arql => name = who'sthis"user`?!@$%^&*-+
    Then should find user: who'sthis"user`?!@$%^&*-+

  Scenario: always quote table name
    Given models: table_name_is_select, foo
    And table_name_is_selects: select_name
    And foos: foo1, foo2
    And foo foo1 belongs to select_name
    When find foo by arql: table_name_is_select = select_name
    Then should find foo: foo1

  Scenario: quote column name
    Given models: column_name_is_from
    And column_name_is_froms: from1
    When find column_name_is_from by arql: from = from1
    Then should find column_name_is_from: from1

  Scenario: quote column name as association
    Given models: column_name_is_from, foo
    And column_name_is_froms: from1
    And foos: foo1, foo2
    And foo foo1 belongs to from1
    When find foo by arql: column_name_is_from = from1
    Then should find foo: foo1
