# pretty-printer for formulas

FormulaVisitor = require './visitor'

class Printer extends FormulaVisitor
  constructor: (@indent, @tab) ->
    @indent ?= 0
    @tab ?= '    '
  prefix: ->
    (@tab for [0...@indent]).join('')

  visitLiteral: (node) ->
    node.value
  visitStringLiteral: (node) ->
    "'#{node.value}'"
  visitReference: (node) ->
    node.name
  visitParens: (node) ->
    "( #{ node.formula.visit @ } )"
  visitInfixExpression: (node) ->
    super node, (a, b) -> "#{a} #{node.operator} #{b}"
  visitFunctionCall: (node) ->
    return "#{node.name}()" if node.parameters.length is 0
    @indent += 1
    params = ("#{@prefix()}#{param.visit @}" for param in node.parameters)
    @indent -= 1
    "#{node.name}(\n#{params.join ',\n'}\n#{@prefix()})"

module.exports = ( formula, indent, tab ) ->
  formula.visit new Printer indent, tab
