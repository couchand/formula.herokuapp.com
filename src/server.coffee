# server

tester = require './tester'
express = require 'express'

app = express()
app.use express.logger()

app.get '/', (req, res) ->
  res.sendfile './example/test.html'

app.get '/prettyprint.html', (req, res) ->
  res.sendfile './example/prettyprint.html'

app.get '/evaluate.html', (req, res) ->
  res.sendfile './example/evaluate.html'

app.get '/dst/parser.js', (req, res) ->
  res.sendfile './dst/parser.js'

app.get '/dst/evaluator.js', (req, res) ->
  res.sendfile './dst/evaluator.js'

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
