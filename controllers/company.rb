post '/companies' do
  company = Company.new(params.slice("name", "address", "city", "country", "email", "phone"))

  if company.save
    json success: true, company: company.as_json
  else
    json success: false, message: company.errors.full_messages.join(". ")
  end
end

get '/companies/:id' do
  company = Company.where(id: params[:id]).first

  if company.nil?
    json success: false, message: "company doesn't exist"
  else
    json success: true, company: company.as_json
  end
end

get '/companies' do
  if (params.key?(:offset) && params[:offset] < 0) ||
     (params.key?(:limit) && params[:limit] <= 0)
     return json success: false
  end

  params[:offset] ||= 0
  params[:limit] ||= 50

  companies = Company.offset(params[:offset]).limit(params[:limit])

  json success: true, total: Company.count, offset: params[:offset], limit: params[:limit], companies: companies.map(&:as_json)
end

put '/companies/:id' do
  company = Company.where(id: params[:id]).first

  if company.nil?
    return json success: false, message: "company doesn't exist"
  end

  if company.update(params.slice("name", "address", "city", "country", "email", "phone"))
    json success: true, company: company.as_json
  else
    json success: false, message: company.errors.full_messages.join(". ")
  end
end

delete '/companies/:id' do
  company = Company.where(id: params[:id]).first

  if company.nil?
    return json success: false, message: "company doesn't exist"
  end

  company.destroy!

  json success: true
end
