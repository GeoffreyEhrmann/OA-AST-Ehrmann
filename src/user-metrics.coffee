db = require('./db')("#{__dirname}/../db/user-metrics")

module.exports =
  
  get: (username, callback) ->
    metricsId = []

    rs = db.createReadStream()

    rs.on 'data', (data) ->
      [_, _username, _userMetricId] = data.key.split ':'
      if data.value and _username is username
        metricsId.push _userMetricId
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, metricsId
 

  save: (username, metricsId, callback) ->
    if !metricsId.length
      callback 'not an array'

    ws = db.createWriteStream()
    ws.on 'close', callback
    ws.on 'error', callback


    for metricId in metricsId
      ws.write
        key: "user-metric:#{username}:#{metricId}"
        value: true
    ws.end()
  

  remove: (username, metricId, callback) ->
    db.del "user-metric:#{username}:#{metricId}" , (err) ->
      callback(err)