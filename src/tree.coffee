# json tree for d3 for formulas

FormulaVisitor = require './visitor'

class TreeBuilder extends FormulaVisitor
  visitLiteral: (node) ->
    { name: node.value }
  visitReference: (node) ->
    { name: node.name }
  visitParens: (node) ->
    { name: '(_)', children: [node.formula.visit @] }
  visitInfixExpression: (node) ->
    super node, (a, b) ->
      { name: node.operator, children: [a, b] }
  visitFunctionCall: (node) ->
    { name: "#{node.name}()", children: (param.visit @ for param in node.parameters) }

module.exports = ( formula ) ->
  formula.visit new TreeBuilder()
