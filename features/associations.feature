Feature: ARQL associations related supported

  Scenario: find by belongs to default association id
    Given models: project, member
    And projects: arql
    And members: m1, m2
    And member m1 belongs to arql
    When find member by arql: project = 1
    Then should find member: m1

  Scenario: find by belongs to association with specified comparision name
    Given models: project, company
    And projects: arql, dtr
    And companies: coder
    And project arql belongs to coder
    When find project by arql: company = coder
    Then should find project: arql

  Scenario: find by belongs to association with specified comparision name in arql
    Given models: project, company
    And projects: arql, dtr
    And companies: coder
    And project arql belongs to coder
    When find project by arql: company.name = coder
    Then should find project: arql
