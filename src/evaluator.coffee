# force formula evaluator

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

class Evaluator extends FormulaVisitor
  constructor: (@data) ->
  visitLiteral: (node) ->
    node.value

  visitReference: (node) ->
    @data[node.name]
  visitComparison: (node) ->
    @visitInfixExpression node, getComparator node.comparator
  visitAddition: (node) ->
    @visitInfixExpression node, (a, b) -> a + b
  visitSubtraction: (node) ->
    @visitInfixExpression node, (a, b) -> a - b
  visitMultiplication: (node) ->
    @visitInfixExpression node, (a, b) -> a * b
  visitDivision: (node) ->
    @visitInfixExpression node, (a, b) -> a / b
  visitConcatenation: (node) ->
    @visitInfixExpression node, (a, b) -> a + b
  visitConjunction: (node) ->
    @visitInfixExpression node, (a, b) -> a and b
  visitDisjunction: (node) ->
    @visitInfixExpression node, (a, b) -> a or b

getComparator = (comparator) ->
  switch comparator
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
  visitComparison: (node) ->
    @visitInfixExpression node
  visitAddition: (node) ->
    @visitInfixExpression node
  visitSubtraction: (node) ->
    @visitInfixExpression node
  visitMultiplication: (node) ->
    @visitInfixExpression node
  visitDivision: (node) ->
    @visitInfixExpression node
  visitConcatenation: (node) ->
    @visitInfixExpression node
  visitConjunction: (node) ->
    @visitInfixExpression node
  visitDisjunction: (node) ->
    @visitInfixExpression node

evaluate = (f, data) ->
  f.visit new Evaluator data

unbound = (f) ->
  f.visit new Unbound

module.exports = {
  evaluate: evaluate
  unbound: unbound
}
