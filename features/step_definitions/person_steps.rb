Given(/^I have following people for company "(.*?)":$/) do |arg1, table|
  company = Company.where(name: arg1).first
  company.persons.create(table.hashes)
end

When(/^I send a get person request for "(.*?)"$/) do |arg1|
  person = Person.where(name: arg1).first

  request "/persons/#{person.id}", :method => :get
end

When(/^I update person "(.*?)" with following:$/) do |arg1, string|
  person = Person.where(name: arg1).first
  content = ERB.new(string).result(binding)

  header 'Content-Type', 'application/json'

  request "/persons/#{person.id}", :input => content, :method => :put
end

Then(/^the JSON response should have "(.*?)" with the id of company "(.*?)"$/) do |arg1, arg2|
  company = Company.where(name: arg2).first
  json    = JSON.parse(last_response.body)
  json["person"]["company_id"].should == company.id
end

Then(/^person "(.*?)" should not exist$/) do |arg1|
  Person.where(name: arg1).count.should == 0
end

When(/^I send a destroy person request for "(.*?)"$/) do |arg1|
  person = Person.where(name: arg1).first

  request "/persons/#{person.id}", :method => :delete
end

When(/^I send a request to get person list of company "(.*?)" with default limit and offset$/) do |arg1|
  company = Company.where(name: arg1).first

  request "/persons?company_id=#{company.id}", :method => :get
end

When(/^I send a request to get person list of company "(.*?)" with limit "(.*?)" and offset "(.*?)"$/) do |arg1, arg2, arg3|
  company = Company.where(name: arg1).first

  request "/persons?company_id=#{company.id}&limit=#{arg2}&offset=#{arg3}", :method => :get
end
