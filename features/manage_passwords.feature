Feature: Manage passwords

  Scenario: Create new password
    Given I am on the new password page
    When I fill in "Private password" with "private_password 1"
    When I fill in "Private password confirmation" with "private_password 1"
    And I fill in "Domain" with "domain 1"
    And I fill in "Username" with "username 1"
    And I check "Use alphabet"
    And I check "Use number"
    And I check "Use symbol"
    And I press "Generate Password"
    Then I should see /Pa14\&\%\"\+\^BU\-Z\-gfcqEVJ\]/

  Scenario Outline: Input validation
    Given I am on the new password page
    When I fill in "Private password" with "<Private password>"
    When I fill in "Private password confirmation" with "<Private password confirmation>"
    And I fill in "Domain" with "<Domain>"
    And I fill in "Username" with "<Username>"
    And I <Alphabet action> "Use alphabet"
    And I <Number action> "Use number"
    And I <Symbol action> "Use symbol"
    And I press "Generate Password"
    Then I should see "<Expected text>"
  Examples:
    | Private password | Private password confirmation | Domain     | Username   | Alphabet action | Number action  | Symbol action              | Expected text                                         |
    | password 1       |                               | domain 1   | username 1 | check           | check          | check                      | doesn't match confirmation                            |
    |                  |                               | domain 1   | username 1 | check           | check          | check                      | can't be blank                                        |
    | password 1       | password 1                    |            | username 1 | check           | check          | check                      | can't be blank                                        |
    | password 1       | password 1                    | domain 1   | username 1 | uncheck         | uncheck        | uncheck                    | Either one of alphabet, number or symbol must be used |
