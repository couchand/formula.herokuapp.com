# force formula evaluator

class Factory
  build: (node) ->
    switch node.expression
      when 'add'
        Builder = Addition
      when 'subtract'
        Builder = Subtraction
      when 'multiply'
        Builder = Multiplication
      when 'divide'
        Builder = Division
      when 'concat'
        Builder = Concatenation
      when 'conjunction'
        Builder = Conjunction
      when 'disjunction'
        Builder = Disjunction
      when 'comparison'
        Builder = Comparison
      when 'parens'
        Builder = Parens
      when 'string'
        Builder = String
      when 'decimal'
        Builder = Decimal
      when 'integer'
        Builder = Integer
      else
        throw 'unknown node type'
    new Builder node

factory = new Factory()

class InfixExpression
  constructor: (node, @operator) ->
    @left = factory.build node.left
    @right = factory.build node.right

  evaluate: (data) ->
    @operator @left.evaluate(data), @right.evaluate(data)

class Addition extends InfixExpression
  constructor: (node) ->
    super node, (left,  right) ->
      left + right

class Subtraction extends InfixExpression
  constructor: (node) ->
    super node, (left,  right) ->
      left - right

class Multiplication extends InfixExpression
  constructor: (node) ->
    super node, (left,  right) ->
      left * right

class Division extends InfixExpression
  constructor: (node) ->
    super node, (left,  right) ->
      left / right

class Concatenation extends InfixExpression
  constructor: (node) ->
    super node, (left,  right) ->
      left + right

class Conjunction extends InfixExpression
  constructor: (node) ->
    super node, (left,  right) ->
      left && right

class Disjunction extends InfixExpression
  constructor: (node) ->
    super node, (left,  right) ->
      left || right

class Comparison extends InfixExpression
  constructor: (node) ->
    super node
    @comparator = new Comparator node.comparator

  evaluate: (data) ->
    @comparator.compare @left.evaluate(data), @right.evaluate(data)

class Comparator
  constructor: (@comparator) ->
  compare: (left, right) ->
    switch @comparator
      when '=', '=='
        left == right
      when '!=', '<>'
        left != right
      when '<'
        left < right
      when '>'
        left > right
      when '<='
        left <= right
      when '>='
        left >= right

class Parens
  constructor: (node) ->
    @formula = factory.build node.formula
  evaluate: (data) ->
    @formula.evaluate data

class Decimal
  constructor: (node) ->
    @value = parseFloat( node.whole + '.' + node.part )
  evaluate: (data) ->
    @value

class Integer
  constructor: (node) ->
    @value = parseInt node.value
  evaluate: (data) ->
    @value

evaluate = (formula, data) ->
  f = factory.build formula
  console.log(f)
  f.evaluate data

module.exports = evaluate
