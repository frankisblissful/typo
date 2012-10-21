Feature: Create and Edit Categories
  As an administrator
  So that I can organize my articles
  I want to be able to label them with categories

Background:
  Given the blog is set up
  And I am logged into the admin panel
  
Scenario: Create a new category
  Given I am on the categories page
  And I fill in "category_name" with "Test"
  And I fill in "category_keywords" with "Test2"
  And I fill in "category_permalink" with "test"
  And I fill in "category_description" with "Test3"
  And I press "Save"
  Then I should be on the categories page
  And I should see "Category was successfully saved"
  And I should see "Test"
  And I should see "Test2"
  And I should see "test"
  And I should see "Test3"