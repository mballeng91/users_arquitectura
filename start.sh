
docker-compose build
docker-compose run --rm ms_autenticateuser rails db:create
docker-compose run --rm ms_autenticateuser rails db:migrate
docker-compose up
