db = require('./db')("#{__dirname}/../db/metrics")

module.exports =
  
  put: (id, metrics, callback) ->
    if !metrics.length
      callback("not an array")
    
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback

    for metric in metrics
      {timestamp, value} = metric
      ws.write
        key: "metric:#{id}:#{timestamp}"
        value: value
    ws.end()

 

  get: (id, callback) ->
    metrics = []
    if id
      options =
        gte: "metric:#{id}"
        lt: "metric:#{parseInt(id) + 1}"
    else
      options = {}

    rs = db.createReadStream options

    rs.on 'data', (data) ->
      [_, _id, timestamp] = data.key.split ':'
      metrics.push
        id: _id
        timestamp: timestamp
        value: data.value
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, metrics
  


  remove: (id, callback) ->
    this.get id, (err, metrics) ->
      if !metrics.length
        callback false
        return
      
      toDel = []
      for metric in metrics
        key = "metric:#{metric.id}:#{metric.timestamp}"
        toDel.push {type: 'del', key: key}
      db.batch toDel, (err) ->
        callback err