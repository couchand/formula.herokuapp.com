# force formula evaluator

FormulaVisitor = require './visitor'

class Evaluator extends FormulaVisitor
  constructor: (@data) ->
  visitLiteral: (node) ->
    node.value

  visitReference: (node) ->
    @data[node.name]
  visitInfixExpression: (node) ->
    super node, getOperator node.operator
  visitFunctionCall: (node) ->
    vals = (param.visit @ for param in node.parameters)
    func = funcs[node.name]
    func vals

getOperator = (operator) ->
  switch operator
    when '+'
      (a, b) -> a + b
    when '-'
      (a, b) -> a - b
    when '*'
      (a, b) -> a * b
    when '/'
      (a, b) -> a / b
    when '^'
      (a, b) -> Math.pow a, b
    when '&'
      (a, b) -> a + b
    when '&&'
      (a, b) -> a and b
    when '||'
      (a, b) -> a or b
    when '=', '=='
      (left, right) -> left is right
    when '!=', '<>'
      (left, right) -> left isnt right
    when '<'
      (left, right) -> left < right
    when '>'
      (left, right) -> left > right
    when '<='
      (left, right) -> left <= right
    when '>='
      (left, right) -> left >= right

funcs = {
  'and': (p) -> p.reduce (a, b) -> a and b
  'or': (p) -> p.reduce (a, b) -> a or b
  'not': (p) -> !p[0]
  'if': (p) -> if p[0] then p[1] else p[2]
  'case': (p) ->
    elseIndex = p.length - 1
    for i in [1...elseIndex] when i % 2 is 1
      return p[i+1] if p[i] is p[0]
    return p[elseIndex]

  'ispickval': (p) -> p[0] is p[1]
  'isnumber': (p) -> p[0] is '' + parseFloat p[0]

  'isnull': (p) -> !p[0]?
  'isblank': (p) -> !p[0]? or p[0] is ''
  'nullvalue': (p) -> if p[0]? then p[0] else p[1]
  'blankvalue': (p) -> if p[0]? and p[0] isnt '' then p[0] else p[1]

  'abs': (p) -> Math.abs p[0]
  'ceiling': (p) -> Math.ceil p[0]
  'exp': (p) -> Math.exp p[0]
  'floor': (p) -> Math.floor p[0]
  'ln': (p) -> Math.log p[0]
  'max': (p) -> Math.max.apply null, p
  'min': (p) -> Math.min.apply null, p
  'mod': (p) -> p[0] % p[1]
  'round': (p) -> Math.round p[0]
  'sqrt': (p) -> Math.sqrt p[0]

  'begins': (p) -> p[0].startsWith p[1]
  'br': (p) -> '\n'
  'find': (p) -> p[1].indexOf p[0]
  'hyperlink': (p) -> "<a href='#{p[0]}'>#{p[1]}</a>"
  'left': (p) -> p[0].substr 0, p[1]
  'len': (p) -> p[0].length
  'lower': (p) -> p[0].toLowerCase()
  'mid': (p) -> p[0].substr p[1], p[2]
  'text': (p) -> '' + p[0]
  'trim': (p) -> p[0].trim()
  'right': (p) -> p[0].substr -p[1]
  'replace': (p) -> p[0].replace p[1], p[2]
  'upper': (p) -> p[0].toUpperCase()
  'urlencode': (p) -> encodeURI p[0]
  'value': (p) -> parseFloat p[0]
}

class Unbound extends FormulaVisitor
  visitLiteral: ->
    []
  visitInfixExpression: (node) ->
    super node, (left, right) ->
      refs = []
      for ref in left
        refs.push ref if -1 is refs.indexOf ref
      for ref in right
        refs.push ref if -1 is refs.indexOf ref
      refs

  visitReference: (node) ->
    [node.name]
  visitFunctionCall: (node) ->
    refs = []
    for param in node.parameters
      for ref in param.visit @
        refs.push ref if -1 is refs.indexOf ref
    func = node.name + '()'
    refs.push func if not funcs[node.name]? and -1 is refs.indexOf func
    refs

evaluate = (f, data) ->
  f.visit new Evaluator data

unbound = (f) ->
  f.visit new Unbound

module.exports = {
  evaluate: evaluate
  unbound: unbound
}
