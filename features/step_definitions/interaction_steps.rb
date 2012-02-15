Then /^I should see an? (error|success|notice) message(?:: "(.*)")?$/ do |msg_type,message|
  page.should have_css(".#{msg_type.gsub('notice','message')}", :text => message)
end
