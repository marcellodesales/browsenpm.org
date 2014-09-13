# marcellodesales/browse-npm
FROM nodesource/node:trusty
MAINTAINER Marcello_deSales@intuit.com

# Don't install browsenpm,
# but allow it to be mounted from outside
# Custom versions FTW

RUN apt-get install -y git

# use changes to package.json to force Docker not to use the cache
# when we change our application's nodejs dependencies:
ADD package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p /runtime && cp -a /tmp/node_modules /runtime

WORKDIR /runtime 

ADD . /runtime

EXPOSE 80
VOLUME /runtime

# init npm couchapp
CMD ["bin/server", "-c config.json"]
