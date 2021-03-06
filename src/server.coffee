# server

tester = require '../force-formula/src/tester'
express = require 'express'

app = express()
app.use express.logger()

app.get '/', (req, res) ->
  res.sendfile './example/test.html'

app.get '/test.html', (req, res) ->
  res.sendfile './example/test.html'

app.get '/prettyprint.html', (req, res) ->
  res.sendfile './example/prettyprint.html'

app.get '/tree.html', (req, res) ->
  res.sendfile './example/tree.html'

app.get '/test.js', (req, res) ->
  res.sendfile './example/test.js'

app.get '/drawtree.js', (req, res) ->
  res.sendfile "./example/drawtree.js"

app.get '/persist.js', (req, res) ->
  res.sendfile "./example/persist.js"

app.get '/validate.js', (req, res) ->
  res.sendfile "./example/validate.js"

app.get /\/lib\/(.+)/, (req, res) ->
  res.sendfile "./lib/#{req.params[0]}"

app.get /\/(\w+)\.js/, (req, res) ->
  res.sendfile "./force-formula/dst/#{req.params[0]}.js"

app.get /\/(\w+)\.css/, (req, res) ->
  res.sendfile "./example/#{req.params[0]}.css"

app.get '/test', (req, res) ->
  formula = req.query.formula
  data = req.query.data
  unless formula?
    res.send "Formula required!"
    return
  if not data?
    res.json tester.getUnbound formula
  else
    tester.testJson formula, data, (results) ->
      res.json results

port = process.env.PORT or 5000
app.listen port, ->
  console.log "listening on #{port}"
