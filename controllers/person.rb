get '/persons' do
  if (params.key?("offset") && params["offset"].to_i < 0) ||
     (params.key?("limit") && params["limit"].to_i <= 0)
     return json success: false, message: "invalid parameter value"
  end

  if !params.key?("company_id")
    return json success: false, message: "company_id is missing"
  end

  company = Company.where(id: params[:company_id]).first

  if company.nil?
    return json success: false, message: "company doesn't exist"
  end

  params[:offset] ||= 0
  params[:limit] ||= 50

  persons = company.persons.offset(params[:offset]).limit(params[:limit])

  json success: true, total: company.persons.count, offset: params[:offset], limit: params[:limit], persons: persons.map(&:as_json)
end

post '/persons' do
  person = Person.new(params.slice("name", "company_id"))

  if person.save
    json success: true, person: person.as_json
  else
    json success: false, message: person.errors.full_messages.join(". ")
  end
end

get '/persons/:id' do
  person = Person.where(id: params[:id]).first

  if person.nil?
    json success: false, message: "person doesn't exist"
  else
    json success: true, person: person.as_json
  end
end

put '/persons/:id' do
  person = Person.where(id: params[:id]).first

  if person.nil?
    return json success: false, message: "person doesn't exist"
  end

  if person.update(params.slice("name", "company_id"))
    json success: true, person: person.as_json
  else
    json success: false, message: person.errors.full_messages.join(". ")
  end
end

delete '/persons/:id' do
  person = Person.where(id: params[:id]).first

  if person.nil?
    return json success: false, message: "person doesn't exist"
  end

  person.destroy!

  json success: true
end
