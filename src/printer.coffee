# pretty-printer for formulas

FormulaVisitor = require './visitor'

class Printer extends FormulaVisitor
  constructor: (@indent, @tab) ->
    @indent ?= 0
    @tab ?= '    '
  prefix: ->
    (@tab for [0...@indent]).join('')

  visitFunctionCall: (node) ->
    return "#{node.name}()" if node.parameters.length is 0
    @indent += 1
    params = ("#{@prefix()}#{param.visit @}" for param in node.parameters)
    @indent -= 1
    "#{node.name}(\n#{params.join ',\n'}\n#{@prefix()})"
  visitReference: (node) ->
    node.name
  visitParens: (node) ->
    "( #{ node.formula.visit @ } )"
  visitAddition: (node) ->
    @visitInfixExpression node, (a, b) -> "#{a} + #{b}"
  visitSubtraction: (node) ->
    @visitInfixExpression node, (a, b) -> "#{a} - #{b}"
  visitMultiplication: (node) ->
    @visitInfixExpression node, (a, b) -> "#{a} * #{b}"
  visitDivision: (node) ->
    @visitInfixExpression node, (a, b) -> "#{a} / #{b}"
  visitExponentiation: (node) ->
    @visitInfixExpression node, (a, b) -> "#{a} ^ #{b}"
  visitConcatenation: (node) ->
    @visitInfixExpression node, (a, b) -> "#{a} & #{b}"
  visitConjunction: (node) ->
    @visitInfixExpression node, (a, b) -> "#{a} && #{b}"
  visitDisjunction: (node) ->
    @visitInfixExpression node, (a, b) -> "#{a} || #{b}"
  visitComparison: (node) ->
    @visitInfixExpression node, (a, b) -> "#{a} #{node.comparator} #{b}"
  visitLiteral: (node) ->
    node.value
  visitStringLiteral: (node) ->
    "'#{node.value}'"

module.exports = ( formula, indent, tab ) ->
  formula.visit new Printer indent, tab
