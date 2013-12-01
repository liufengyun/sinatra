Given(/^I have following companies:$/) do |table|
  Company.create!(table.hashes)
end

When(/^I update company "(.*?)" with following:$/) do |arg1, string|
  company = Company.where(name: arg1).first
  header 'Content-Type', 'application/json'

  request "/companies/#{company.id}", :input => string, :method => :put
end

When(/^I send a get company request for "(.*?)"$/) do |arg1|
  company = Company.where(name: arg1).first

  request "/companies/#{company.id}", :method => :get
end

Then(/^company "(.*?)" should not exist$/) do |arg1|
  Company.where(name: arg1).count.should == 0
end

When(/^I send a destroy company request for "(.*?)"$/) do |arg1|
  company = Company.where(name: arg1).first

  request "/companies/#{company.id}", :method => :delete
end
