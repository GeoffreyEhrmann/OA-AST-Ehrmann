metrics = require '../metrics'
userMetrics = require '../user-metrics'

module.exports = (router) ->
  authCheck = (req, res, next) ->
    unless req.session.loggedIn == true
      res.redirect '/login'
    else
      next()
  router.get "/", authCheck, (req, res) ->
    res.redirect '/hello/' + req.session.username

  router.get "/metrics(/:id)?", authCheck, (req, res) ->
    #console.log(req)
    metrics.get req.params.id, (err, value) ->
      res.status(404).send(err) if err
      userMetrics.get req.session.username, (err, metricsId) ->
        console.log metricsId
        selected = []
        #select only values that user has access to
        for val in value
          if metricsId.indexOf(val.id) isnt -1
            selected.push(val)
        if err
          res.status(404).send(err)
        else
          #sorting by timestamp in order to display well
          selected.sort (a,b) ->
            if (a.timestamp < b.timestamp) then -1
            else 1
          res.status(200).json selected

  router.post "/metrics/:id", authCheck, (req, res) ->
    metrics.put req.params.id, req.body, (err) ->
    if err
      res.status(404).send(err)
    else
      res.status(200).send()

  router.delete "/metrics/:id", authCheck, (req,res) ->
    userMetrics.get req.session.username, (err, metricsId) ->
    res.status(404).send() if err

    if metricsId.indexOf(req.params.id) isnt -1
      metrics.remove req.params.id, (err) ->
        if err
          res.status(404).send(err)
        else
          res.status(200).send()
    else
      res.status(401).send()

  router.get "/user-metric", authCheck, (req,res) ->
    userMetrics.get req.session.username, (err, metricsId) ->
      if err
        res.status(404).send(err)
      else
        res.status(200).json metricsId

  router.post "/user-metric", authCheck, (req, res) ->
    userMetrics.save req.session.username, req.body, (err)->
    if err
        res.status(404).send(err)
    else
        res.status(200).send()

  router.delete "/user-metric/:id", authCheck, (req,res) ->
    userMetrics.remove req.session.username, req.params.id, (err) ->
      if err
        res.status(404).send(err)
      else
        res.status(200).send()

  router