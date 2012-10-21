require 'date'

Given /^the blog is set up$/ do
  Blog.default.update_attributes!({:blog_name => 'Teh Blag',
                                   :base_url => 'http://localhost:3000'});
  Blog.default.save!
  User.create!({:login => 'admin',
                :password => 'U5TAS4R',
                :email => 'joe@snow.com',
                :profile_id => 1,
                :name => 'admin',
                :state => 'active'})
end

And /^I am logged into the admin panel$/ do
  visit '/accounts/login'
  fill_in 'user_login', :with => 'admin'
  fill_in 'user_password', :with => 'U5TAS4R'
  click_button 'Login'
  if page.respond_to? :should
    page.should have_content('Login successful')
  else
    assert page.has_content?('Login successful')
  end
end

And /^I log in as "(.*)"$/ do |login|
  visit '/accounts/login/'
  fill_in 'user_login', :with => "#{login}"
  fill_in 'user_password', :with => '67crystal76'
  click_button 'Login'
  if page.respond_to? :should
    page.should have_content('Login successful')
  else
    assert page.has_content?('Login successful')
  end
end

Given /^the following accounts exist/ do |accounts_table|
  accounts_table.hashes.each do |account|
    visit '/admin/users/new/'
    fill_in 'user_login', :with => account["login"]
    fill_in 'user_password', :with => "67crystal76"
    fill_in 'user_password_confirmation', :with => "67crystal76"
    fill_in 'user_email', :with => account["email"]
    select 'Blog publisher', :from => 'user_profile_id'
    fill_in 'user_firstname', :with => account["firstname"]
    fill_in 'user_lastname', :with => account["lastname"]
    click_button 'Save'
  end
end


Given /the following articles exist/ do |articles_table|
  articles_table.hashes.each do |article|
    visit '/admin/content/new'
    fill_in 'article_title', :with => article["title"]
    fill_in 'article__body_and_extended_editor', :with => article["body"]
    click_button 'Publish'
    if page.respond_to? :should
      page.should have_content('Article was successfully created')
    else
      assert page.has_content?('Article was successfully created')
    end
  end

end

Given /the following comments exist/ do |comments_table|
  comments_table.hashes.each do |comments|
    article = Content.find_by_title(comments["article"])
    if comments["date"]=='today'
      comments["date"] = "#{Time.now.utc.to_date.year}/#{Time.now.utc.to_date.month}/#{Time.now.utc.to_date.mday}"
    end
    visit "/#{comments["date"]}/#{article.permalink}"
    fill_in 'comment_author', :with => comments["author"]
    fill_in 'comment_body', :with => comments["body"]
    click_button 'comment'
  end

end


Then /^I should be logged in as admin$/ do
  active_user_login = User.find_by_state('active').login
  assert (active_user_login == 'admin')
end

Then /^I should not be logged in as admin$/ do
  active_user_login = User.find_by_state('active').login
  assert (not (active_user_login == 'admin'))
end

Then /^I should be logged in as "(.*)"$/ do
  active_user_login = $1
  assert (User.find_by_state('active').login == active_user_login)
end

Given /^I have logged out$/ do
  visit '/accounts/logout'
end


When /^I merge "(.*?)" into "(.*?)"$/ do |arg1, arg2|

  article_to_eat = Content.find_by_title(arg2)
  article_to_eaten = Content.find_by_title(arg1)
  steps %Q{ When I am on the edit page for "#{article_to_eat.title}"}
  steps %Q{
    When I fill in "merge_with" with "#{article_to_eaten.id}"
    And I press "Merge With This Article"
  }
end

Then /^the title should be "(.*?)"$/ do |arg1|
 assert (not (Content.find_by_title(arg1).nil?))
end

Then /^the article "(.*?)" should contain the text "(.*?)" and "(.*?)"$/ do |arg1, arg2, arg3|
  art = Article.find_by_title(arg1)
  assert art.body.include?(arg2)
  assert art.body.include?(arg3)
end

Then /^the author for "(.*?)" should be the author for "(.*?)" or "(.*?)"$/ do |arg1, arg2, arg3|
  article_to_eat = Content.find_by_title(arg2)
  article_to_eaten = Content.find_by_title(arg1)
  assert (article_to_eat.body.include? (article_to_eaten.body))
end

Then /^the article for comment "(.*?)" should be "(.*?)"$/ do |comment_id, article_title|
  assert (Comment.find_by_id($1).article_id == Article.find_by_title($2).id)
end


Then /^the comments for "(.*?)" should be the following/ do |article_title, comments_table|
  article = Article.find_by_title(article_title)
  comments = Comment.find_all_by_article_id(article.id)
  authors = []
  bodies = []
  comments.each do |comment|
    authors << comment.author
    bodies << comment.body
  end
  comments_table.hashes.each do |comment|
    if comment["date"]=='today'
      comment["date"] = "#{Time.now.utc.to_date.year}/#{Time.now.utc.to_date.month}/#{Time.now.utc.to_date.mday}"
    end
    assert authors.include?(comment["author"]) and bodies.include?(comment["body"])
  end
end

