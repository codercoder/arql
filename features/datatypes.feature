Feature: ARQL supported data types

  Scenario Outline: String type
    Given users: kuli1, kuli2, kuli"3, kuli'4, kuli\"5, kuli\'6, kuli 7, kuli' \"8
    When arql => name = <user_name_string>
    Then should find user: <found_user_name>
  Examples:
    | user_name_string | found_user_name |
    | kuli1 | kuli1 |
    | 'kuli1' | kuli1 |
    | "kuli1" | kuli1 |
    | kuli"3 | kuli"3 |
    | kuli'4 | kuli'4 |
    | kuli\"5 | kuli\"5 |
    | kuli\\'6 | kuli\\'6 |
    | 'kuli 7' | kuli 7 |
    | "kuli' \\\"8" | kuli' \"8 |

  Scenario Outline: Number type
    Given users: kuli1, kuli2
    When arql => id = <user_id_number>
    Then should find user: <found_user_name>
  Examples:
    | user_id_number | found_user_name |
    | 1 | kuli1 |
    | 1. | kuli1 |
    | 1.0 | kuli1 |
    | .1 | , |
    | 0.1 | , |

  Scenario Outline: Boolean type
    Given users: kuli1, kuli2
    And kuli1 is admin
    And kuli2 is not admin
    When arql => admin = <is_admin>
    Then should find user: <found_user_name>
  Examples:
    | is_admin | found_user_name |
    | true | kuli1 |
    | false | kuli2 |
