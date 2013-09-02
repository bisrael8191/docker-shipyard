docker-shipyard
===============

Creates a Shipyard Docker image with data separated from the application folder.
Based on https://github.com/ehazlett/shipyard/blob/master/Dockerfile

###Install
`docker build -t bisrael/shipyard github.com/bisrael8191/Dockerfiles/tree/shipyard`

###Run
`docker run -d -p 8000:8000 bisrael/shipyard`

###Notes
Haven't figured out how to store the database in a volume yet. It should be something like:

`docker run -d -v /var/data/shipyard:/opt/data/shipyard:rw -p 8000:8000 bisrael/shipyard`

The database is written there, but it's reset so the login information is gone. Possibly submit
a pull request to set the default admin/shipyard login when DB is first created.