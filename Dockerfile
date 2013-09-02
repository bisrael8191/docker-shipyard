# Creates a Shipyard Docker image with data separated from the application folder
#
# Credit: Based on https://github.com/ehazlett/shipyard/blob/master/Dockerfile
#
# VERSION 1.0

# Base image
FROM ubuntu

# Dockerfile creation date, change to re-run all commands and update the image
ENV DOCKERFILE_DATE 2013-09-02

MAINTAINER Brad Israel

# Update the base image
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Set up Shipyard environment
RUN apt-get install -y python-dev python-setuptools libxml2-dev libxslt-dev libmysqlclient-dev supervisor redis-server git-core
RUN easy_install pip
RUN pip install virtualenv
RUN pip install uwsgi
RUN virtualenv --no-site-packages /opt/ve/shipyard

# Clone the shipyard project to install folder
RUN (mkdir -p /opt/apps && cd /opt/apps && git clone https://github.com/ehazlett/shipyard.git)

# Remove the git remotes
RUN (cd /opt/apps/shipyard && git remote rm origin)
RUN (cd /opt/apps/shipyard && git remote add origin https://github.com/ehazlett/shipyard.git)

# Copy config files
RUN cp /opt/apps/shipyard/.docker/supervisor.conf /opt/supervisor.conf
#RUN cp /opt/apps/shipyard/.docker/known_hosts /root/.ssh/known_hosts
RUN cp /opt/apps/shipyard/.docker/run.sh /usr/local/bin/run

# Default the DB_NAME to a separate data folder
RUN mkdir /opt/data/shipyard
ENV DB_NAME /opt/data/shipyard/shipyard.db

# Configure shipyard virtualenv
RUN /opt/ve/shipyard/bin/pip install -r /opt/apps/shipyard/requirements.txt
RUN (cd /opt/apps/shipyard && /opt/ve/shipyard/bin/python manage.py syncdb --noinput)
RUN (cd /opt/apps/shipyard && /opt/ve/shipyard/bin/python manage.py migrate)
RUN (cd /opt/apps/shipyard && /opt/ve/shipyard/bin/python manage.py update_admin_user --username=admin --password=shipyard)

# Set up a volume for the shipyard data (doesn't work yet, use docker run -v HOSTDIR:/opt/data/shipyard:rw)
#VOLUME ["/opt/data/shipyard"]

# Port to open internally (use docker -p PORTNUM to expose it externally)
EXPOSE 8000

# Command to run
ENTRYPOINT ["/bin/sh", "-e", "/usr/local/bin/run"]