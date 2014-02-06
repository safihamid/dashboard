Given /^I am on (.+)$/ do |url|
  @browser.navigate.to "http://#{url}"
end

When /^I fill in "([^"]*)" found by "([^"]*)" with "([^"]*)"$/ do |value, type, keys|
  @element = @browser.find_element(type, value)
  @element.send_keys keys
end

When /^I wait for (\d+) seconds$/ do |seconds|
  sleep seconds.to_i
end

When /^I submit$/ do
  @element.submit
end

When /^I inject simulation$/ do

  #@browser.execute_script('$("body").css( "background-color", "black")')
  @browser.execute_script("var fileref=document.createElement('script');  fileref.setAttribute('type','text/javascript'); fileref.setAttribute('src', '/assets/jquery.simulate.js'); document.getElementsByTagName('head')[0].appendChild(fileref)")
end

When /^I press "([^"]*)"$/ do |button|
  @button = @browser.find_element(:id, button)
  @button.click
end

When /^I drag block "([^"]*)" to offset "([^"]*), ([^"]*)"$/ do |from, dx, dy|
  @browser.execute_script("$(\"[block-id='#{from}']\").simulate( 'drag', {handle: 'corner', dx: #{dx}, dy: #{dy}, moves: 5});")
end 

When /^I drag block "([^"]*)" to block "([^"]*)"$/ do |from, to|
  @code = 
    "var drag_dx = $(\"[block-id='#{to}']\").position().left - $(\"[block-id='#{from}']\").position().left;" +
    "var drag_dy = $(\"[block-id='#{to}']\").position().top  - $(\"[block-id='#{from}']\").position().top;" +
    "$(\"[block-id='#{from}']\").simulate( 'drag', {handle: 'corner', dx: drag_dx, dy: drag_dy + 30, moves: 5});"
  @browser.execute_script @code
end 

Then /^block "([^"]*)" is child of block "([^"]*)"$/ do |child, parent|
  @child_item = @browser.find_element(:css, "g[block-id='#{child}']")
  @parent_item = @browser.find_element(:css, "g[block-id='#{parent}']")
  @actual_parent_item = @child_item.find_element(:xpath, "..")
  @parent_item.should eq @actual_parent_item
end

Then /^I should see title "([^"]*)"$/ do |title|
  @browser.title.should eq title
end

