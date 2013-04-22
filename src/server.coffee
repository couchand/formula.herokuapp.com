# server

tester = require './tester'
express = require 'express'

app = express()
app.use express.logger()

app.get '/', (req, res) ->
  formula = req.query.formula
  data = req.query.data
  unless formula?
    res.send "Formula required!"
    return
  if not data?
    res.send tester.getTemplate formula
  else
    tester.test formula, data, (results) ->
      res.send JSON.stringify results

port = process.env.PORT or 5000
app.listen port, ->
  console.log "listening on #{port}"
