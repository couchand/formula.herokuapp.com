# test formula against csv

csv = require 'csv'
parser = require '../dst/parser'
evaluator = require './evaluator'

getTemplate = (formula_src) ->
  formula = parser.parse formula_src
  tree = evaluator.build formula
  lets = tree.unbound()
  lets.push 'expected'
  lets.push 'message'
  lets.join ','

test = (formula_src, csv_src, report) ->
  formula = parser.parse formula_src
  failures = []
  csv().from(csv_src, columns: true).transform((data) ->
    data.actual = evaluator.evaluate formula, data
    data
  ).on('record', (data, index) ->
    message = "Row #{index+1}:  expected #{data.actual} to equal #{data.expected}.  #{data.message}."
    failures.push(message) if data.actual isnt data.expected
  ).on('end', ->
    report failures
  )

module.exports = {
  getTemplate: getTemplate
  test: test
}
