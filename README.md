browsenpm.org
=============

Browse packages, users, code, stats and more the public npm registry in style.

Requirements
===========

This app must have Internet connection to Nodejitsu, NPM.org and other servers to be able to render packages information.

Optionally, you can run all the depending sub-systems in Docker, as described below.

Docker Container
============

Running this on a container requires the following containers:

* Redis: https://registry.hub.docker.com/_/redis/

Based on the documentation, you can start it with persistence and storing the data in a desired volume.

```
docker run -d --name='redis' -v /app/npm-redis-volume:/data redis redis-server --appendonly yes
```

* NPM + CouchDB: https://registry.hub.docker.com/u/burkostya/npm-registry/

This is running the NPM.org private registry, Kappa and CouchDB server. Again, you can just follow the
documentation and set the Couchdb credentials, expose port numbers, etc. 

```
docker run --name='npm-registry' -d -e 'COUCHDB_ADMIN_LOGIN=intuit' -e 'COUCHDB_ADMIN_PASSWORD=intuit' -p 5984:5984 -p 80:80 -v /app/npm-volume/:/var/lib/couchdb burkostya/npm-registry:2.5.5
```

Where the COUCHDB and volumen values are based in your environment.

This app can start and link to those containers using the following command:

```
sudo docker run --name browsenpm-server -d -p 8081:8081 --link npm-registry:couchdb --link redis:redis --link npm-registry:private_npm marcellodesales/browse-npm
035e83d07a7ff49a865a75f98ae072e14d41419e66075ca4b601c1663c3c4ecb
```

After the server is running, you might have the following container running:

```
$ sudo docker ps
CONTAINER ID        IMAGE                               COMMAND                CREATED             STATUS              PORTS                                        NAMES
035e83d07a7f        marcellodesales/browse-npm:latest   bin/server             11 seconds ago      Up 2 seconds        80/tcp, 0.0.0.0:8081->8081/tcp               browsenpm-server                                                                                                                                                 
cc93d42c8bbc        burkostya/npm-registry:2.5.5        /app/init app:start    26 minutes ago      Up 26 minutes       0.0.0.0:80->80/tcp, 0.0.0.0:5984->5984/tcp   browsenpm-server/couchdb,browsenpm-server/private_npm,grave_yonath/couchdb,grave_yonath/private_npm,jolly_carson/couchdb,jolly_carson/private_npm,npm-registry   
3f129cde98c3        redis:latest                        redis-server --appen   37 minutes ago      Up 37 minutes       6379/tcp                                     browsenpm-server/redis,grave_yonath/redis,jolly_carson/redis,redis 
```

You can inspect the "browsenpm-server" container and make sure it is running:

```
$ sudo docker logs browsenpm-server
Browsenpm.org is now running on http://localhost:8081
```
### Installation

Browsenpm.org has several dependencies to run locally for development purposes.

```bash
sudo apt-get install redis-server couchdb
npm install
```

After update the configuration in `development.json` and provide the details
needed. Note that your database might require authentication credentials.

### Running

```bash
npm start

# Or run the server by specifying a configuration file.
bin/server -c config.dev.json
```

Providing a custom configuration is optional. By default `development.json`
will be used.

### Database

Both Redis and CouchDB should be running to cache data for certain pagelets. Make
sure you run them locally or provide a server that runs either.

CouchDB will be used to cache all the data of [npm-probe]. The views in
`plugins/couchdb.json` should be available on the database to ensure the
pagelet can fetch the data. These views will be added to the `browsenpm` database
on startup.

### Status npm-mirrors

The current registry status is provided via [npm-probe]. Several probes are run at
set intervals. The publish probe requires authentication with `npm-probe`. These
credentials can (and are) provided to the configuration of the [npm-probe] instance.

npm-probe is provided with a CouchDB cache instance. All data is stored in the
database `browsenpm`.

When running multiple instances of browsenpm.org accessible via balancers, make
sure to only start npm-probe once. Set the environment variable `PROBE=silent` to
prevent an instance from collecting data.

[npm-probe]: https://github.com/Moveo/npm-probe

### Cache

During development it might be useful to destroy cached data, simply set any of the
following environment variables to flush cache.

```bash
CACHE=flush:redis
CACHE=flush:couchdb
```

### Debugging

Most components have debug statements to help debugging, shortlist:

| Module    | Description    | Statement                            |
| --------- | -------------- | ------------------------------------ |
| bigpipe   | all components | `DEBUG=bigpipe:*`                    |
| bigpipe   | server         | `DEBUG=bigpipe:server`               |
| bigpipe   | pages          | `DEBUG=bigpipe:page`                 |
| bigpipe   | pagelets       | `DEBUG=bigpipe:pagelet`              |
| npm-probe | statistics     | `DEBUG=npm-probe`                    |
| dynamis   | cache layer    | `DEBUG=dynamis`                      |
| ALL       | every module   | `DEBUG=bigpipe:*,dynamis,npm-probe`  |
