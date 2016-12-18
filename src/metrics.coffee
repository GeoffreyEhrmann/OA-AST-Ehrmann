db = require('./db')("#{__dirname}/../db/metrics")

module.exports =
  
  put: (id, metrics, callback) ->
    if !metrics.length
      callback("not an array")
    
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback

    for metric in metrics
      {id, value} = metric
      ws.write
        key: "metric:#{id}"
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
      [_, _id, x] = data.key.split ':'
      metrics.push
        id: _id
        x: x
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
        key = "metric:#{metric.id}"
        toDel.push {type: 'del', key: key}
      db.batch toDel, (err) ->
        callback err