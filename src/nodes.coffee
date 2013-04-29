# force formula abstract syntax tree

class InfixExpression
  constructor: (@left, @right, @operator) ->

class Addition extends InfixExpression
  visit: (visitor) ->
    visitor.visitAddition @

class Subtraction extends InfixExpression
  visit: (visitor) ->
    visitor.visitSubtraction @

class Multiplication extends InfixExpression
  visit: (visitor) ->
    visitor.visitMultiplication @

class Division extends InfixExpression
  visit: (visitor) ->
    visitor.visitDivision @

class Concatenation extends InfixExpression
  visit: (visitor) ->
    visitor.visitConcatenation @

class Conjunction extends InfixExpression
  visit: (visitor) ->
    visitor.visitConjunction @

class Disjunction extends InfixExpression
  visit: (visitor) ->
    visitor.visitDisjunction @

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
  visit: (visitor) ->
    visitor.visitFunctionCall @

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
