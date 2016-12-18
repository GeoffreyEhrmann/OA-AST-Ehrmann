user = require "../users"

module.exports = (router) ->
  router.post '/signup', (req, res) ->
    user.save req.body.username, req.body.password, req.body.name,
    req.body.email, (err, value) ->
      if err
        res.redirect('/signup')
      else
        res.redirect("/hey/" + req.body.username)

  router.get '/signup', (req, res) ->
    res.render 'signup'

  router.get '/login', (req, res) ->
    res.render 'login'

  router.post '/login', (req, res) ->
    user.get req.body.username, (err, data) ->
      res.redirect '/login' if err

      if data.pwd!=req.body.password
        res.redirect '/login'
      else
        req.session.loggedIn= true
        req.session.username= data.username
        res.redirect("/hey/" + req.body.username)

  router.get '/logout', (req, res) ->
    delete req.session.loggedIn
    delete req.session.username
    res.redirect '/login'

  router