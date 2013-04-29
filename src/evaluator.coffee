# force formula evaluator

class Evaluator
  constructor: (@data) ->

  visitIntegerLiteral: (node) ->
    node.value
  visitDecimalLiteral: (node) ->
    node.value
  visitStringLiteral: (node) ->
    node.value
  visitParens: (node) ->
    node.formula.visit @

class Unbound
  constructor: ->

  visitIntegerLiteral: (node) ->
    []
  visitDecimalLiteral: (node) ->
    []
  visitStringLiteral: (node) ->
    []
  visitParens: (node) ->
    node.formula.visit @

evaluate = (f, data) ->
  f.visit new Evaluator data

unbound = (f) ->
  f.visit new Unbound

module.exports = {
  evaluate: evaluate
  unbound: unbound
}
