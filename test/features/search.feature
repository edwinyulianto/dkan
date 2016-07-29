@api
# features/search.feature
Feature: Search
  In order to see a dataset
  As a website user
  I need to be able to search for a word

  Background:
    Given I am on the homepage
    And pages:
    | name                      | url                                                |
    | Dataset Search            | /search/type/dataset                               |
    | Dataset Results           | /search/type/dataset?query=Dataset%2001            |
    | Not valid type search     | /search/type/notvalid                              |
    | Not valid tags search     | /search/field_tags/notvalid                        |
    | Not valid topics search   | /search/field_topic/notvalid                       |
    | Not valid resource search | /search/field_resources%253Afield_format/notvalid  |
    | Not valid license search  | /search/field_license/notvalid                     |
    Given users:
      | name    | mail                | roles                |
      | Badmin  | admin@example.com   | site manager         |
      | Gabriel | gabriel@example.com | editor               |
    Given groups:
      | title    | author  | published |
      | Group 01 | Badmin  | Yes       |
    And group memberships:
      | user    | group    | role on group        | membership status |
      | Gabriel | Group 01 | administrator member | Active            |
    And "Tags" terms:
      | name         |
      | something 01 |
      | politics  01 |
    And datasets:
      | title           | publisher | author  | published | tags         | description |
      | Test Dataset 01 |           | Gabriel | Yes       | something 01 | Test 01     |
      | Test Dataset 02 | Group 01  | Gabriel | Yes       | politics 01  | Test 02     |

  Scenario: Searching datasets
    When I search for "Dataset 01"
    Then I should be on the "Dataset Results" page
    And I should see "Dataset 01"

  Scenario: See number of datasets on search page
    Given I am on the "Dataset Search" page
    Given I search for "Test"
    Then I should see "2" search results shown on the page
    And I should see "2 results"

  Scenario: Filter by facet tag
    Given I search for "Test"
    When I click "politics 01"
    Then I should not see "Dataset 01"
    But I should see "Dataset 02"

  Scenario: Filter by facet group
    Given I search for "Test"
    When I click "Group 01"
    Then I should not see "Dataset 01"
    But I should see "Dataset 02"

  Scenario Outline: Forbid XSS injection in search
    Given I am on the "<page>" page
    Then I should see "Page not found"
    Examples:
    | page                      |
    | Not valid type search     |
    | Not valid tags search     |
    | Not valid topics search   |
    | Not valid resource search |
    | Not valid license search  |
