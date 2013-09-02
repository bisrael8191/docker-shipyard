docker-shipyard
===============

Creates a Shipyard Docker image with data separated from the application folder.
Based on https://github.com/ehazlett/shipyard/blob/master/Dockerfile

###Install
`docker build -t bisrael/shipyard github.com/bisrael8191/docker-shipyard`

###Run
Make sure host data folder '/var/data/shipyard' exists before starting the container.

`docker run -d -v /var/data/shipyard:/opt/data/shipyard:rw -p 8000:8000 bisrael/shipyard`

Follow the instructions in the notes, then login using 'admin:shipyard'.

###Notes
The first time the container is run, the database generated during the install needs
to be copied to the host filesystem in order to log in. So first, start the container
with the run command. Then copy the shipyard.db file using:

`docker cp CONTAINER_ID:/opt/apps/shipyard/shipyard.db /var/data/shipyard/`

Then stop and restart the shipyard container. You should be able to login and all
data will be stored in the volume, allowing the container to be restarted.

Possibly submit a pull request to set the default login when DB is first created.