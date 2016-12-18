metrics = require "../metrics"

module.exports = (router) ->
  router.get "/" (req,res) ->
    metrics.save req.body.x req.body.y

  router