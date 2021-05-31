## Development Environment

This project uses Docker and Docker Compose to setup a development environment. You'll need to install a current version of Docker, which you can get here: https://docs.docker.com/docker-for-mac/install/

To setup this project for the first time, begin by eyeballing the `Dockerfile`s in the repo. There is one in the `api/` directory for Craft, and another in the `client/` directory for Next.js.  Does the Craft `Dockerfile` contain the correct PHP version on the base image? Are you using the correct version of Composer? Is the correct Node version referenced in the Next Dockerfile?

If you've just used `brew scaffold` to put required files in place, note that you will need to merge updated files and commit those changes
to version control. You can also delete the `config/dev` directory, and `Brewfile.*`.

Then, follow these steps:

```
# Start up the containers. This will take longer the first time because
# Docker will need to build the containers. Every time you run this command
# the postgres database will be dropped and recreated if it already exists.
script/setup

# Once the containers are built, fire them up! The first time, a new
# user with credentials `admin` / `password` will be created, and Craft
# will be installed.
script/up

# Note: script/server does the same thing as script/up!
```

The Craft backend will be accessible here: http://localhost:8000/admin
The Next.js frontend will be accessible here: http://localhost:3000

#### Other useful commands:

```
# Shorthand for `docker compose down`. Shuts down and removes all containers.
script/down

# Run an Craft CLI command
script/craft/cli [[COMMAND]]

# Here's one you'll likely need to write project config from database structure
docker compose exec craft php craft project-config/write

# Add a node module
docker compose exec nextjs yarn add [[MODULE]]

# Update a node module
docker compose exec nextjs yarn upgrade [[MODULE]]

# Force rebuild of all container images
docker compose up --build --force-recreate --no-deps

# Sync a site from staging
bundle exec cap staging content:sync
```

If you need to SSH into any of the running containers, use the Docker dashboard,
locate the container, and click the terminal icon.
