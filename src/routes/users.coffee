user = require "../users"

module.exports = (router) ->
  authCheck = (req, res, next) ->
    unless req.session.loggedIn == true
      res.redirect '/login'
    else
      next()
  router.get "/", authCheck, (req, res) ->
    res.redirect '/hello/' + req.session.username

  router.get '/user/:username', authCheck, (req, res) ->
    user.get req.params.username, (err, value) ->
      if err
        res.status(404).send(err)
      else
        res.status(200).json value

  router.delete '/user/:username', authCheck, (req,res) ->
    user.remove req.params.username, (err) ->
      if err
        res.status(404).send(err)
      else
        res.status(200).send()

  router.get "/hello/:name",authCheck, (req, res) ->
    res.render 'hello',
      name: req.params.name

  router