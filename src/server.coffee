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
    res.send tester.getTemplate formula
  else
    tester.test formula, data, (results) ->
      res.json results

port = process.env.PORT or 5000
app.listen port, ->
  console.log "listening on #{port}"
