# force formula abstract syntax tree

class InfixExpression
  constructor: (@left, @right, @operator) ->
  evaluate: (data) ->
    @operator @left.evaluate(data), @right.evaluate(data)

  unbound: ->
    refs = []
    for ref in @left.unbound()
      refs.push ref if -1 is refs.indexOf ref
    for ref in @right.unbound()
      refs.push ref if -1 is refs.indexOf ref
    refs

class Addition extends InfixExpression
  visit: (visitor) ->
    visitor.visitAddition @

class Subtraction extends InfixExpression
  constructor: (a, b) ->
    super a, b, (left,  right) ->
      left - right

class Multiplication extends InfixExpression
  constructor: (a, b) ->
    super a, b, (left,  right) ->
      left * right

class Division extends InfixExpression
  constructor: (a, b) ->
    super a, b, (left,  right) ->
      left / right

class Concatenation extends InfixExpression
  constructor: (a, b) ->
    super a, b, (left,  right) ->
      left + right

class Conjunction extends InfixExpression
  constructor: (a, b) ->
    super a, b, (left,  right) ->
      left and right

class Disjunction extends InfixExpression
  constructor: (a, b) ->
    super a, b, (left,  right) ->
      left or right

class Comparison extends InfixExpression
  constructor: (@comparator, a, b) ->
    super a, b
  visit: (visitor) ->
    visitor.visitComparison @

class Parens
  constructor: (@formula) ->
  visit: (visitor) ->
    visitor.visitParens @

class StringLiteral
  constructor: (@value) ->
  visit: (visitor) ->
    visitor.visitStringLiteral @

class DecimalLiteral
  constructor: (whole, part) ->
    @value = parseFloat( whole + '.' + part )
  visit: (visitor) ->
    visitor.visitDecimalLiteral @

class IntegerLiteral
  constructor: (val) ->
    @value = parseInt val
  visit: (visitor) ->
    visitor.visitIntegerLiteral @

class Reference
  constructor: (names) ->
    @name = names.join '.'
  visit: (visitor) ->
    visitor.visitReference @

class FunctionCall
  constructor: (fn, @parameters) ->
    @name = fn.toLowerCase()
    @func = funcs[@name]
  evaluate: (data) ->
    vals = (param.evaluate data for param in @parameters)
    @func vals
  unbound: ->
    refs = []
    for param in @parameters
      for ref in param.unbound()
        refs.push ref if -1 is refs.indexOf ref
    func = @name + '()'
    refs.push func if not @func? and -1 is refs.indexOf func
    refs

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

module.exports = {
  Addition: Addition
  Subtraction: Subtraction
  Multiplication: Multiplication
  Division: Division
  Concatenation: Concatenation
  Conjunction: Conjunction
  Disjunction: Disjunction
  Comparison: Comparison
  Parens: Parens
  StringLiteral: StringLiteral
  IntegerLiteral: IntegerLiteral
  DecimalLiteral: DecimalLiteral
  Reference: Reference
  FunctionCall: FunctionCall
}
