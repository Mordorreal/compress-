# Compress-

Small service that compress users files. Just a task for interview, don't take it too seriosly.
Compress can handle speed seeding of 2m records with copy (~3 min) and can return same amount records in one bulk with somehow meaningfull amount of time (cold for 2m records total ~280s (Views: ~145s | ActiveRecord: ~43s), ). Can be speedup by pagination and caching warm up but this is not in requirements.
Images stored on S3 and compressed with sidekiq async jobs.

* How to run service

1. rename .env.example to .env and input aws keys or copy given .env to root project folder
2. `docker-compose up --build`
3. In separate terminal you can run `docker-compose run --rm web bundle exec rails db:create db:migrate db:seed` to prepare and seed db

* How to run the test suite and linters

  Better to setup db on local in database.yml for test enviroment because it's a lot faster but other way with docker also works, you need to run `docker-compose run --rm web bundle exec rspec` to run in docker or following commands for local:
  
  `bundle install`

  `bundle exec rspec`

  `bundle exec rubocop`

* To get all sended emails you can use preconfigured http://localhost:5001/ or you need to configure your own smtp server

* GET /images Get all images with users

`curl -X GET http://localhost:3000/images -H 'Content-Type: application/json'`

* GET /users Get all users with images

`curl -X GET http://localhost:3000/users -H 'Content-Type: application/json'`

* POST /users Create new user

`curl -X POST http://localhost:3000/users -H 'Content-Type: application/json' -d '{"user": { "email": "test@test.com" }}'`

* POST /images/compress

`curl -X POST http://localhost:3000/images/compress -H 'Content-Type: multipart/form-data' -F image\[user_id\]=2746c349-c0cc-4df4-ac25-dc019059782c -F image\[file\]=@example.jpg`

* GET /images/:id/download Get link to compressed file

open in browser http://localhost:3000/images/b39ac101-a4ea-4544-a07e-c41320cfe96e/download and you will be redirected to image url


