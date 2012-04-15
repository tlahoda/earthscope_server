express = require 'express'
app = module.exports = express.createServer()

request = require 'request'

stations = new Array()

loadStationData= (s, t) ->
  d = s[0].split '\t'
  console.log 'http://www.iris.edu/ws/timeseries/query?net=%s&sta=%s&loc=--&cha=BHZ&start=' + t + '&duration=7200&output=ascii1&bp=0.001-0.015&divscale=100&decimate=0.5', d[1], d[2]
  request 'http://www.iris.edu/ws/timeseries/query?net=' + d[1] + '&sta=' + d[2] + '&loc=--&cha=BHZ&start=' + t + '&duration=7200&output=ascii1&bp=0.001-0.015&divscale=100&decimate=0.5', (error, res, body) ->
    if !error && res.statusCode == 200
      wave = body.split '\n'
      console.log wave[0]
      wave.shift()
      wave.pop()
      samples = new Array()
      for sample in wave
        samples.push sample
      stations.push {net: d[1], sta: d[2], loc: [d[4], d[5]], samples: samples}
    else
      stations.push {net: d[1], sta: d[2], loc: [d[4], d[5]]}
    s.shift()
    if s.length > 0
      loadStationData s, t

request 'http://www.iris.edu/earthscope/usarray/ALL-OpStationList.txt', (error, res, body) ->
  if !error && res.statusCode == 200
    stats = body.split '\n'
    stats.shift()
    stats.pop()
    loadStationData stats.slice(0, 2), '2012.102T08:50:00'
    #loadStationData stats, '2011.235T05:45:00'
    #loadStationData stats, '2011.235T17:50:00'

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session
    secret: 'nafinsoreo23'
  app.use require('stylus').middleware
    src: __dirname + '/public'
  app.use app.router
  app.use express.static __dirname + '/public'

app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true,
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.render 'index',
    title: 'Appolition LLC',
    content_page: '/home'

app.get '/stations', (req, res) ->
  res.json stations, { 'Access-Control-Allow-Origin': '*' }

app.get '/earthscope', (req, res) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.partial 'earthscope', { title: 'EarthScope', content_page: '/earthscope' }

app.listen 5000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

