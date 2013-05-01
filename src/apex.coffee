# apex compiler

FormulaVisitor = require './visitor'

class ApexCompiler extends FormulaVisitor
  constructor: (@context) ->

  visitLiteral: (node) ->
    node.value
  visitStringLiteral: (node) ->
    "'#{node.value}'"
  visitReference: (node) ->
    if @context and node.name[0] isnt '$' then "#{@context}.#{node.name}" else node.name
  visitParens: (node) ->
    "( #{ node.formula.visit @ } )"
  visitInfixExpression: (node) ->
    super node, (a, b) -> "#{a} #{node.operator} #{b}"
  visitFunctionCall: (node) ->
    params = (param.visit @ for param in node.parameters)
    "#{node.name}(#{params.join ', '})"

module.exports = ( formula, context ) ->
  formula.visit new ApexCompiler context
