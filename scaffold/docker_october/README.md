## Development Environment

This project uses docker and docker-compose to setup a development environment. You'll need to install a current version of docker, which you can get here: https://docs.docker.com/docker-for-mac/install/

To setup this project for the first time, begin by eyeballing the Dockerfile in this repo. Does it contain the correct PHP version on the base image? Look at the docker-compose.yml file. Is the node image you're using correct?

Then, follow these steps:

### Initial setup
1. Clone this repo
2. `cp .env.example .env`
3. `script/up`
4. `script/october/composer install`
5. `warewolf setup` Refer to the [Warewolf the project](#warewolf-the-project) section below for configuration.
6. `warewolf pull`
7. View the frontend at http://localhost:8000
8. If needed, [create a backend admin](#create-a-backend-admin).

### Start the project

`script/up`

### Stop the project

`script/down`

### Destroy containers for a fresh start

`script/destroy`

### CLI Shortcuts

```
script/october/artisan [...]
script/october/composer [...]
script/node/yarn [...]
```

### Other useful commands

```
# Connect to mysql. The database container exposes MySQL on port 8001.
mysql --host=127.0.0.1 --port=8001 --user=$DB_USER --password $DB_NAME

# Reset a user's password
script/october/artisan october:passwd admin password

# Add a node module
script/node/yarn add some-module

# Update a node module
script/node/yarn upgrade node-sass

# Force rebuild the October image after changing the Dockerfile
docker-compose up --build --force-recreate --no-deps october
```

### Connecting to the database

With October, we store our database connection information in the .env file in the project root. When the database container starts up, docker will source the .env file. Our docker-compose configuration will pass the October database env vars to the MySQL container. When that container first starts, it will create a database and user based on the variables.

### Using Warewolf

Update Warewolf to 0.1.5 if you haven't yet by running `gem update warewolf`. Warewolf has been updated to take a port argument to allow it to work with a database in a running container. Your `.warewolf/config` should look something like this:

```
remote=castiron@warewolf.cichq.com:warewolf/data/project
db_name=october
db_user=username
db_host=127.0.0.1
db_port=8001
db_pass='password'
```
The variables above can all be found in the .env file. Be sure to use the 127.0.0.1 IP address for the host. I've seen cases where localhost doesn't resolve properly in this context, not sure why yet.


### Create a backend admin
Make an admin user with username "admin" and password "admin":
```
docker exec db /var/lib/queries/run_sql.sh create_admin.sql
```

If instead you need or prefer an interactive process, start Tinker with `script/october/artisan tinker` and copy/paste the following into your terminal in sequence:
```
$user = Backend\Models\User::create([
            'email'                 => 'you@castironcoding.com',
            'login'                 => 'cic',
            'password'              => 'chu88yhands',
            'password_confirmation' => 'chu88yhands',
            'first_name'            => 'firstname',
            'last_name'             => 'lastname',
            'permissions'           => ['superuser' => 1],
            'is_activated'          => true,
        ]);
```
```
$user->is_superuser = true;
```
```
$user->save();
```
```
exit
```

