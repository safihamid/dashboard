module CalloutHelpers
  def is_callout_visible(callout_id)
    @browser.execute_script("return $('#qtip-#{callout_id}').is(':visible')")
  end
end

World(CalloutHelpers)


