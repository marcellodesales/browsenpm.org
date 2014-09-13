# marcellodesales/browse-npm
FROM nodesource/node:trusty
MAINTAINER Marcello_deSales@intuit.com

# Don't install browsenpm,
# but allow it to be mounted from outside
# Custom versions FTW

VOLUME /runtime

ADD . /runtime

# Create workspace
# And bind it to the site folder at runtime
WORKDIR /runtime

EXPOSE 80

RUN apt-get install -y git

RUN npm install

# init npm couchapp
CMD ["bin/server -c confi.json"]
