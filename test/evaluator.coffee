# evaluator tests

n = require '../src/nodes'
e = require '../src/evaluator'
assert = require 'assert'

describe 'Evaluator', ->
  describe '#', ->
    describe 'visitIntegerLiteral', ->
      it 'evaluates', ->
        five = new n.IntegerLiteral '5'
        assert.equal e.evaluate(five), 5

    describe 'visitDecimalLiteral', ->
      it 'evaluates', ->
        fiveTwo = new n.DecimalLiteral '5', '2'
        assert.equal e.evaluate(fiveTwo), 5.2

    describe 'visitStringLiteral', ->
      it 'evaluates', ->
        foobar = new n.StringLiteral 'foobar'
        assert.equal e.evaluate(foobar), 'foobar'

    describe 'visitParens', ->
      it 'evaluates', ->
        parenFive = new n.Parens new n.IntegerLiteral '5'
        assert.equal e.evaluate(parenFive), 5

    describe 'visitReference', ->
      it 'evaluates', ->
        foobar = new n.Reference ['foo', 'bar']
        data = { 'foo.bar': 5 }
        assert.equal e.evaluate(foobar, data), 5
