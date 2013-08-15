Then /there (should|should not) exist a link with title "([^"]*)" in the database/ do |expectation, title|
  Link.find_by_title(title).send(expectation.gsub(' ', '_'), be)
end

Then /there (should|should not) exist a link with summary "([^"]*)" in the database/ do |expectation, summary|
  Link.find_by_summary(summary).send(expectation.gsub(' ', '_'), be)
end
