http = require('http')
user = require('./user.coffee')
http.createServer((req, res) ->
  user.get 'Geoff', (id) ->
    res.writeHead 200, 'Content-Type': 'text/plain'
    res.end 'Salut ' + id + ' comment vas-tu ?'
   
).listen 3300, '127.0.0.1'
