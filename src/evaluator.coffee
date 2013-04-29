# force formula evaluator

class Evaluator
  constructor: (@data) ->
  visitLiteral: (node) ->
    node.value

  visitIntegerLiteral: (node) ->
    @visitLiteral node
  visitDecimalLiteral: (node) ->
    @visitLiteral node
  visitStringLiteral: (node) ->
    @visitLiteral node
  visitParens: (node) ->
    node.formula.visit @
  visitReference: (node) ->
    @data[node.name]
  visitComparison: (node) ->
    left = node.left.visit @
    right = node.right.visit @
    switch node.comparator
      when '=', '=='
        left is right
      when '!=', '<>'
        left isnt right
      when '<'
        left < right
      when '>'
        left > right
      when '<='
        left <= right
      when '>='
        left >= right

class Unbound
  constructor: ->
  visitLiteral: ->
    []

  visitIntegerLiteral: (node) ->
    @visitLiteral node
  visitDecimalLiteral: (node) ->
    @visitLiteral node
  visitStringLiteral: (node) ->
    @visitLiteral node
  visitParens: (node) ->
    node.formula.visit @
  visitReference: (node) ->
    [node.name]
  visitComparison: (node) ->
    refs = []
    for ref in node.left.visit @
      refs.push ref if -1 is refs.indexOf ref
    for ref in node.right.visit @
      refs.push ref if -1 is refs.indexOf ref
    refs

evaluate = (f, data) ->
  f.visit new Evaluator data

unbound = (f) ->
  f.visit new Unbound

module.exports = {
  evaluate: evaluate
  unbound: unbound
}
