
# Toy app

A small Ruby on Rails project using MySQL, Redis, and Docker for containerized development. This app also includes integrations for GitHub, Google OAuth, Slack notifications, and Sentry for error tracking.


## Installation

1. **Clone project**
```
git clone https://github.com/TrieuThanhTung/toy-app-tt
cd toy-app-tt
```

2. **Set Up Environment Variables**
   Create a .env file in the root directory and run command:
```bash
cp .env.example .env
```
with the following format and fill in the values as needed.
3. **Build and Start Docker Containers**
   In the project directory, run the following commands in order:
```
docker compose build
docker compose up -d
```
* `docker compose build` - Builds the Docker images.
* `docker compose up -d` - Starts the services in detached mode.
4. **Set Up the Database**
   Once the containers are running, execute these commands to create and initialize the database:
```
docker compose run web bin/rails db:create
docker compose run web bin/rails db:migrate
docker compose run web bin/rails db:seed
```
* `db:create` - Creates the MySQL database.
* `db:migrate` - Applies migrations.
* `db:seed` - Inserts sample data.

=> The application will be accessible at http://localhost:3000.
## Useful Commands

- **Restarting Services**:
  ```bash
  docker compose restart
  ```
- **Viewing Logs**:
  ```bash
  docker compose logs -f
  ```
- **Stopping Services**:
  ```bash
  docker compose down
  ```
## Documentation

* [Ruby on rails](https://rubyonrails.org/)
* [Mysql](https://www.mysql.com/)
* [Redis](https://redis.io/)
* [Docker](https://www.docker.com/)
* [Docker compose](https://docs.docker.com/compose/)

