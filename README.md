A small API application based on Rails 5

## How to run it

1. `bundle install`
2. `rails db:create`
3. `rails db:migrate`
4. `rails db:seed`
5. `rails s`
3. Open http://0.0.0.0:3000 in a browser

## How it's structured

* `/app` is the main folder of the application
* `/spec` specs

## Documentation

* API http://0.0.0.0:3000/apipie
* Note, that you need to be authenticated and pass `access-token`, `client`, `token-type` in every request 

## How to sign in

* Using curl:
 
`curl -XPOST -v -H 'Content-Type: application/json' http://0.0.0.0:3001/api/v1/auth/sign_in -d '{"email": "zarechenskiy.mihail@gmail.com", "password": "qwerty321" }'`

## How to run tests

* `rspec spec`

## TODO

* restructure messages by users
* improve api documentation with instructions for nested parameters
* add foreign keys
* improve methods getting friends/messages to use a single query instead of 2
* add acceptance tests