# server

express = require 'express'

app = express()
app.use express.logger()

app.get '/', (req, res) ->
  res.send 'Hello, world!'

port = process.env.PORT or 5000
app.listen port, ->
  console.log "listening on #{port}"
