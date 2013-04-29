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

    describe 'visitComparison', ->
      it 'evaluates equals', ->
        equals = new n.Comparison '=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), true

        equals = new n.Comparison '=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), false

      it 'evaluates double equals', ->
        equals = new n.Comparison '==', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), true

        equals = new n.Comparison '==', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), false

      it 'evaluates not equals', ->
        equals = new n.Comparison '!=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), true

        equals = new n.Comparison '!=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), false

      it 'evaluates weird not equals', ->
        equals = new n.Comparison '<>', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), true

        equals = new n.Comparison '<>', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), false

      it 'evaluates less than', ->
        equals = new n.Comparison '<', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), true

        equals = new n.Comparison '<', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), false

      it 'evaluates greater than', ->
        equals = new n.Comparison '>', new n.IntegerLiteral('5'), new n.IntegerLiteral('4')
        assert.equal e.evaluate(equals), true

        equals = new n.Comparison '>', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), false

      it 'evaluates less than or equals', ->
        equals = new n.Comparison '<=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), true

        equals = new n.Comparison '<=', new n.IntegerLiteral('5'), new n.IntegerLiteral('4')
        assert.equal e.evaluate(equals), false

      it 'evaluates greater than or equals', ->
        equals = new n.Comparison '>=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), true

        equals = new n.Comparison '>=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), false

describe 'Comparator', ->
  describe '#', ->
    describe 'visitIntegerLiteral', ->
      it 'unbounds', ->
        five = new n.IntegerLiteral '5'
        assert.equal e.unbound(five).length, 0

    describe 'visitDecimalLiteral', ->
      it 'unbounds', ->
        fiveTwo = new n.DecimalLiteral '5', '2'
        assert.equal e.unbound(fiveTwo).length, 0

    describe 'visitStringLiteral', ->
      it 'unbounds', ->
        foobar = new n.StringLiteral 'foobar'
        assert.equal e.unbound(foobar).length, 0

    describe 'visitParens', ->
      it 'unbounds', ->
        parenFive = new n.Parens new n.IntegerLiteral '5'
        assert.equal e.unbound(parenFive).length, 0

    describe 'visitReference', ->
      it 'unbounds', ->
        foobar = new n.Reference ['foo', 'bar']
        assert.equal e.unbound(foobar)[0], 'foo.bar'

    describe 'visitComparison', ->
      it 'unbounds equals', ->
        equals = new n.Comparison '=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

        equals = new n.Comparison '=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds double equals', ->
        equals = new n.Comparison '==', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

        equals = new n.Comparison '==', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds not equals', ->
        equals = new n.Comparison '!=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0

        equals = new n.Comparison '!=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds weird not equals', ->
        equals = new n.Comparison '<>', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0

        equals = new n.Comparison '<>', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds less than', ->
        equals = new n.Comparison '<', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0

        equals = new n.Comparison '<', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds greater than', ->
        equals = new n.Comparison '>', new n.IntegerLiteral('5'), new n.IntegerLiteral('4')
        assert.equal e.unbound(equals).length, 0

        equals = new n.Comparison '>', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds less than or equals', ->
        equals = new n.Comparison '<=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

        equals = new n.Comparison '<=', new n.IntegerLiteral('5'), new n.IntegerLiteral('4')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds greater than or equals', ->
        equals = new n.Comparison '>=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

        equals = new n.Comparison '>=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0
