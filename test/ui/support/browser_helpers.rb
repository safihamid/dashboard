module BrowserHelpers
  def element_has_text(selector, expectedText)
    expectedText.gsub!('\"', '"')
    text = @browser.execute_script("return $(\"#{selector}\").text();");
    text.should eq expectedText
  end
end

World(BrowserHelpers)
