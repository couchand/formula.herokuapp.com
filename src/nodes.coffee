# force formula abstract syntax tree

class InfixExpression
  constructor: (@operator, @left, @right) ->
  visit: (visitor) ->
    visitor.visitInfixExpression @

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
  visit: (visitor) ->
    visitor.visitFunctionCall @

module.exports = {
  InfixExpression: InfixExpression
  Parens: Parens
  StringLiteral: StringLiteral
  IntegerLiteral: IntegerLiteral
  DecimalLiteral: DecimalLiteral
  Reference: Reference
  FunctionCall: FunctionCall
}
