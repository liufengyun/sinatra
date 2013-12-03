# ReadMe

This is a sinatra application which demonstrates usage of following technologies:

- cucumber
- PostgreSQL
- heroku
- Ember.js
- Bootstrap
- S3(direct upload to S3)

Online demo: [company.herokuapp.com](http://company.herokuapp.com)

## How to Run

1. Modify `config/database.yml` to your local database setting.
2. Modify `config/application.yml` in order to store passports in S3.
3. Run `bundle install`
4. Run `rake db:migrate`

Now, just run `rackup` and play with it!

Create new company

```
curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"name":"Google","address":"xyz", "city":"New York", "country": "USA"}'  \
     http://localhost:9292/companies
```

Update company

```
curl -X PUT \
     -H "Content-Type: application/json" \
     -d '{"name":"Google","address":"xyz"}'  \
     http://localhost:9292/companies/1
```

Show company detail

```
curl http://localhost:9292/companies/1
```

Get company list

```
curl http://localhost:9292/companies?limit=20&offset=2
```

`limit` and `offset` are optional. If not specified, `limit` defaults to `50` and `offset` defaults to `0`.

Destroy a company

```
curl -X DELETE http://localhost:9292/companies/1
```

Create new person

```
curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"name":"Jack","company_id":1}'  \
     http://localhost:9292/persons
```

Update a person

```
curl -X PUT \
     -H "Content-Type: application/json" \
     -d '{"name":"Jack","company_id":1}'  \
     http://localhost:9292/persons/1
```

Show person detail

```
curl http://localhost:9292/persons/1
```

Destroy a person

```
curl -X DELETE http://localhost:9292/persons/1
```

Get persons list by company

```
curl http://localhost:9292/persons?company_id=1&limit=20&offset=2
```

`limit` and `offset` are optional. If not specified, `limit` defaults to `50` and `offset` defaults to `0`.

Get policy and signature in order to upload to S3

```
curl -X POST http://localhost:9292/persons/1/policy
```

Attach s3 file to person

```
curl -X PUT \
     -H "Content-Type: application/json" \
     -d '{"s3_url": "https://yourbucket.s3.s3.amazonaws.com/path/to/file"}'  \
     http://localhost:9292/persons/1/attach
```

Detach file from a person

```
curl -X DELETE http://localhost:9292/persons/1/detach
```
Note: the file will be deleted from S3.

## Run tests

1. Modify `config/database.yml` to your local database setting for testing.
2. Modify `config/application.yml` in order to store passports in S3 for testing.
3. Run `rake db:migrate RACK_ENV=test`

Now, run `bundle exec cucumber` and enjoy your coffee:-)
