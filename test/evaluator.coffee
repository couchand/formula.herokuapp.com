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

    describe 'visitAddition', ->
      it 'evaluates', ->
        fivePlusThree = new n.Addition new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.evaluate(fivePlusThree), 8

    describe 'visitSubtraction', ->
      it 'evaluates', ->
        fiveMinusThree = new n.Subtraction new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.evaluate(fiveMinusThree), 2

    describe 'visitMultiplication', ->
      it 'evaluates', ->
        fiveTimesThree = new n.Multiplication new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.evaluate(fiveTimesThree), 15

    describe 'visitDivision', ->
      it 'evaluates', ->
        fourOverTwo = new n.Division new n.IntegerLiteral('4'), new n.IntegerLiteral('2')
        assert.equal e.evaluate(fourOverTwo), 2

    describe 'visitConcatenation', ->
      it 'evaluates', ->
        aThenB = new n.Concatenation new n.StringLiteral('a'), new n.StringLiteral('b')
        assert.equal e.evaluate(aThenB), 'ab'

    describe 'visitConjunction', ->
      it 'evaluates', ->
        oneAndZero = new n.Conjunction new n.IntegerLiteral('1'), new n.IntegerLiteral('0')
        assert.equal e.evaluate(oneAndZero), false

    describe 'visitDisjunction', ->
      it 'evaluates', ->
        oneOrZero = new n.Disjunction new n.IntegerLiteral('1'), new n.IntegerLiteral('0')
        assert.equal e.evaluate(oneOrZero), true

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

    describe 'visitAddition', ->
      it 'unbounds', ->
        fivePlusThree = new n.Addition new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.unbound(fivePlusThree).length, 0

    describe 'visitSubtraction', ->
      it 'unbounds', ->
        fiveMinusThree = new n.Subtraction new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.unbound(fiveMinusThree).length, 0

    describe 'visitMultiplication', ->
      it 'unbounds', ->
        fiveTimesThree = new n.Multiplication new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.unbound(fiveTimesThree).length, 0

    describe 'visitDivision', ->
      it 'unbounds', ->
        fiveOverThree = new n.Division new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.unbound(fiveOverThree).length, 0

    describe 'visitConcatenation', ->
      it 'unbounds', ->
        aThenB = new n.Concatenation new n.StringLiteral('a'), new n.StringLiteral('b')
        assert.equal e.unbound(aThenB).length, 0

    describe 'visitConjunction', ->
      it 'unbounds', ->
        oneAndZero = new n.Conjunction new n.IntegerLiteral('1'), new n.IntegerLiteral('0')
        assert.equal e.unbound(oneAndZero).length, 0

    describe 'visitDisjunction', ->
      it 'unbounds', ->
        oneOrZero = new n.Disjunction new n.IntegerLiteral('1'), new n.IntegerLiteral('0')
        assert.equal e.unbound(oneOrZero).length, 0
