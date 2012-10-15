Feature: Merge Articles
 As an administrator
 So that I can decrease the number of articles
 I want to be able to merge articles together

Background: 
 Given the blog is set up
 And I am logged into the admin panel	 
 And the following articles exist:
  |title|
  |Bob-omb|
  |mooot|
 And the following comments exist:
  |article|author|date|
  |Hello World!|bob|2012/06/09|
  |Hello World!|modd|2012/06/09|
  |Bob-omb|boom|2012/10/15|

Scenario: A non-admin cannot merge articles
  Given I have logged out
  And I am on the edit page for "Bob-omb"
  Then I should be on the login page

Scenario: the title of the new article should be the title from one of the merged articles
  When I merge "Bob-omb" into "Hello World!"
  Then the title should be "Hello World!"     
Scenario: when articles are merged, the merged article should contain both texts
  When I merge "Bob-omb" into "Hello World!"
  Then the article "Hello World!" should contain the text from "Hello World!" and "Bob-omb"  
Scenario: when articles are merged, the merged article should have one author
  When I merge "Bob-omb" into "Hello World!"
  Then the author for "Hello World!" should be the author for "Hello World!" or "Bob-omb" 
Scenario: comments on each of the two original articles need to all carry over
  When I merge "Bob-omb" into "Hello World!"
  Then the comments for "Hello World!" should be the comments for "Hello World!" and "Bob-omb"

  