module.exports = {
  "port": process.env.APP_PORT && parseInt(process.env.APP_PORT) || 8081,
  "tokens": [],
  "registry": process.env.PRIVATE_NPM_PORT_80_TCP && process.env.PRIVATE_NPM_PORT_80_TCP.replace("tcp", "http")
                || "https://registry.nodejitsu.com/",
  "probes": [
    "ping",
    "delta"
  ],
  "service": "browsenpm",
  "redis": {
    "host": process.env.REDIS_PORT_6379_TCP_ADDR || "localhost",
    "port": process.env.REDIS_PORT_6379_TCP_PORT && parseInt(process.env.REDIS_PORT_6379_TCP_PORT) || 6379
  },
  "couchdb": {
    "database": "browsenpm",
    "host": process.env.COUCHDB_PORT_5984_TCP_ADDR || "localhost",
    "port": process.env.COUCHDB_PORT_5984_TCP_PORT && parseInt(process.env.COUCHDB_PORT_5984_TCP_PORT) || 5984
  },
  "npm": {
    "loglevel": process.env.APP_LOG_LEVEL || "silent"
  }
}
