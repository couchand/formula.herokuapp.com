# formula visitor abstract base class

class FormulaVisitor
  constructor: ->
  visitIntegerLiteral: (node) ->
    @visitLiteral node
  visitDecimalLiteral: (node) ->
    @visitLiteral node
  visitStringLiteral: (node) ->
    @visitLiteral node
  visitParens: (node) ->
    node.formula.visit @
  visitInfixExpression: (node, fn) ->
    left = node.left.visit @
    right = node.right.visit @
    fn left, right

module.exports = FormulaVisitor
