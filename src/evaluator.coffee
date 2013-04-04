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
      else
        Builder = Literal
    new Builder node

factory = new Factory()

class InfixExpression
  constructor: (node) ->
    @left = factory.build node.left
    @right = factory.build node.right

class Addition extends InfixExpression
  evaluate: (data) ->
    @left.evaluate data + @right.evaluate data

class Subtraction extends InfixExpression
  evaluate: (data) ->
    @left.evaluate data - @right.evaluate data

class Multiplication extends InfixExpression
  evaluate: (data) ->
    @left.evaluate data * @right.evaluate data

class Division extends InfixExpression
  evaluate: (data) ->
    @left.evaluate data / @right.evaluate data

class Concatenation extends InfixExpression
  evaluate: (data) ->
    @left.evaluate data + @right.evaluate data

class Conjunction extends InfixExpression
  evaluate: (data) ->
    @left.evaluate data && @right.evaluate data

class Disjunction extends InfixExpression
  evaluate: (data) ->
    @left.evaluate data || @right.evaluate data

class Comparison extends InfixExpression
  constructor: (node) ->
    super node
    @comparator = new Comparator node.comparator

  evaluate: (data) ->
    @comparator.compare @left.evaluate(data), @right.evaluate(data)

class Comparator
  constructor: (@comparator) ->
  compare: (left, right) ->
    switch comparator
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

evaluate = (formula, data) ->
  f = factory.build formula
  f.evaluate data

module.exports = evaluate
