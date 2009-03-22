Feature: ARQL supported data types

  Scenario Outline: String type
    Given users: kuli1, kuli2, kuli"3, kuli'4, kuli\"5, kuli\'6, kuli 7
    When find user by arql: name = <user_name_string>
    Then should find <found_user_name>
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
