Feature: Merge Articles
 As an administrator
 So that I can decrease the number of articles
 I want to be able to merge articles together

Background: 
 Given the blog is set up
 And I am logged into the admin panel	 
 And the following articles exist:
  |title| body |
  |Bob-omb| Start Lorem Ipsum Bob-omb end|
  |mooot| Start lorem ipsum moot end|
 And the following comments exist:
  |article|author|date| body |
  |Hello World!|bob|2012/06/09| Hello World! 1 |
  |Hello World!|modd|2012/06/09| Hello World! 2 |
  |Bob-omb|boom|2012/10/16| Bob-omb 1 |

 Given the following accounts exist:
  | login | email | firstname | lastname |
  | blogp | phoebesimon@gmail.com | phoebe | simon |
  | blogp2 | frankyu@gmail.com | Frank | Yu |

Scenario: A non-admin cannot merge articles
  Given I have logged out
  And I log in as "blogp"
  And I am on the edit page for "Bob-omb"
  Then I should not see "Merge"

Scenario: the title of the new article should be the title from one of the merged articles
  And I am on the edit page for "Bob-omb"
  When I merge "Bob-omb" into "Hello World!"
  Then the title should be "Hello World!"     

Scenario: when articles are merged, the merged article should contain both texts
  When I merge "Bob-omb" into "Hello World!"
  Then the article "Hello World!" should contain the text "Start Lorem Ipsum Bob-omb end" and "Welcome to Typo. This is your first article. Edit or delete it, then start blogging!" 
 
Scenario: when articles are merged, the merged article should have one author
  When I merge "Bob-omb" into "Hello World!"
  Then the author for "Hello World!" should be the author for "Hello World!" or "Bob-omb" 

Scenario: comments on each of the two original articles need to all carry over
  When I merge "Bob-omb" into "Hello World!"
  Then the comments for "Hello World!" should be the following:
    | author | date | body |
    | bob | 2012/06/09 | Hello World! 1 |
    | modd | 2012/06/09 | Hello World! 2 |
    | boom | 2012/10/16 | Bob-omb 1 |

  