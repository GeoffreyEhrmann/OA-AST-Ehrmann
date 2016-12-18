http = require "http"
express = require "express"
morgan = require('morgan') ('dev')
errorhandler = require 'errorhandler'
bodyparser = require 'body-parser'
cookieParser = require 'cookie-parser'
methodOverride = require 'method-override'
user = require "./users"
app = express()

if process.env.NODE_ENV == 'development'
  #only use in development
  app.use(errorhandler())

session = require 'express-session'
LevelStore = require('level-session-store')(session)

#configuration of session db
app.use session
  secret: 'TopSecret'
  store: new LevelStore './db/sessions'
  resave: true
  saveUninitialized: true

#display requests
app.use morgan

app.use bodyparser.json()
app.use bodyparser.urlencoded()
app.use cookieParser()
app.use methodOverride 'X-HTTP-Method-Override'

app.set 'port', 3333
app.set 'view engine', 'pug'
app.set 'views', "#{__dirname}/../views"

app.use '/', express.static "#{__dirname}/../public"
app.use '/bower_components',  express.static "#{__dirname}/../bower_components"

app.use require('./routes/auth.coffee') express.Router()
app.use require('./routes/users.coffee') express.Router()
app.use require('./routes/user-metrics.coffee') express.Router()

#if everything is ok, display that the app is listening to the port 3333
app.listen app.get('port'), ->
  console.log "listening on port #{app.get 'port'}"