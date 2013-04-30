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

    describe 'visitInfixExpression', ->
      it 'evaluates equals', ->
        equals = new n.InfixExpression '=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), true

        equals = new n.InfixExpression '=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), false

      it 'evaluates double equals', ->
        equals = new n.InfixExpression '==', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), true

        equals = new n.InfixExpression '==', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), false

      it 'evaluates not equals', ->
        equals = new n.InfixExpression '!=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), true

        equals = new n.InfixExpression '!=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), false

      it 'evaluates weird not equals', ->
        equals = new n.InfixExpression '<>', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), true

        equals = new n.InfixExpression '<>', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), false

      it 'evaluates less than', ->
        equals = new n.InfixExpression '<', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), true

        equals = new n.InfixExpression '<', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), false

      it 'evaluates greater than', ->
        equals = new n.InfixExpression '>', new n.IntegerLiteral('5'), new n.IntegerLiteral('4')
        assert.equal e.evaluate(equals), true

        equals = new n.InfixExpression '>', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), false

      it 'evaluates less than or equals', ->
        equals = new n.InfixExpression '<=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), true

        equals = new n.InfixExpression '<=', new n.IntegerLiteral('5'), new n.IntegerLiteral('4')
        assert.equal e.evaluate(equals), false

      it 'evaluates greater than or equals', ->
        equals = new n.InfixExpression '>=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.evaluate(equals), true

        equals = new n.InfixExpression '>=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.evaluate(equals), false

      it 'evaluates addition', ->
        fivePlusThree = new n.InfixExpression '+', new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.evaluate(fivePlusThree), 8

      it 'evaluates subtraction', ->
        fiveMinusThree = new n.InfixExpression '-', new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.evaluate(fiveMinusThree), 2

      it 'evaluates multiplication', ->
        fiveTimesThree = new n.InfixExpression '*', new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.evaluate(fiveTimesThree), 15

      it 'evaluates division', ->
        fourOverTwo = new n.InfixExpression '/', new n.IntegerLiteral('4'), new n.IntegerLiteral('2')
        assert.equal e.evaluate(fourOverTwo), 2

      it 'evaluates exponentiation', ->
        fiveSquared = new n.InfixExpression '^', new n.IntegerLiteral('5'), new n.IntegerLiteral('2')
        assert.equal e.evaluate(fiveSquared), 25

      it 'evaluates concatenation', ->
        aThenB = new n.InfixExpression '&', new n.StringLiteral('a'), new n.StringLiteral('b')
        assert.equal e.evaluate(aThenB), 'ab'

      it 'evaluates conjunction', ->
        oneAndZero = new n.InfixExpression '&&', new n.IntegerLiteral('1'), new n.IntegerLiteral('0')
        assert.equal e.evaluate(oneAndZero), false

      it 'evaluates disjunction', ->
        oneOrZero = new n.InfixExpression '||', new n.IntegerLiteral('1'), new n.IntegerLiteral('0')
        assert.equal e.evaluate(oneOrZero), true

    describe 'visitFunctionCall', ->
      it 'evaluates', ->
        foobar = new n.FunctionCall 'and', [new n.IntegerLiteral('1'), new n.IntegerLiteral('0')]
        assert.equal e.evaluate(foobar), false

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

    describe 'visitInfixExpression', ->
      it 'unbounds equals', ->
        equals = new n.InfixExpression '=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

        equals = new n.InfixExpression '=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds double equals', ->
        equals = new n.InfixExpression '==', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

        equals = new n.InfixExpression '==', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds not equals', ->
        equals = new n.InfixExpression '!=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0

        equals = new n.InfixExpression '!=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds weird not equals', ->
        equals = new n.InfixExpression '<>', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0

        equals = new n.InfixExpression '<>', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds less than', ->
        equals = new n.InfixExpression '<', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0

        equals = new n.InfixExpression '<', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds greater than', ->
        equals = new n.InfixExpression '>', new n.IntegerLiteral('5'), new n.IntegerLiteral('4')
        assert.equal e.unbound(equals).length, 0

        equals = new n.InfixExpression '>', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds less than or equals', ->
        equals = new n.InfixExpression '<=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

        equals = new n.InfixExpression '<=', new n.IntegerLiteral('5'), new n.IntegerLiteral('4')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds greater than or equals', ->
        equals = new n.InfixExpression '>=', new n.IntegerLiteral('5'), new n.IntegerLiteral('5')
        assert.equal e.unbound(equals).length, 0

        equals = new n.InfixExpression '>=', new n.IntegerLiteral('5'), new n.IntegerLiteral('6')
        assert.equal e.unbound(equals).length, 0

      it 'unbounds addition', ->
        fivePlusThree = new n.InfixExpression '+', new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.unbound(fivePlusThree).length, 0

      it 'unbounds subtraction', ->
        fiveMinusThree = new n.InfixExpression '-', new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.unbound(fiveMinusThree).length, 0

      it 'unbounds multiplication', ->
        fiveTimesThree = new n.InfixExpression '*', new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.unbound(fiveTimesThree).length, 0

      it 'unbounds division', ->
        fiveOverThree = new n.InfixExpression '/', new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal e.unbound(fiveOverThree).length, 0

      it 'unbounds exponentiation', ->
        fiveSquared = new n.InfixExpression '^', new n.IntegerLiteral('5'), new n.IntegerLiteral('2')
        assert.equal e.unbound(fiveSquared).length, 0

      it 'unbounds concatenation', ->
        aThenB = new n.InfixExpression '&', new n.StringLiteral('a'), new n.StringLiteral('b')
        assert.equal e.unbound(aThenB).length, 0

      it 'unbounds conjunction', ->
        oneAndZero = new n.InfixExpression '&&', new n.IntegerLiteral('1'), new n.IntegerLiteral('0')
        assert.equal e.unbound(oneAndZero).length, 0

      it 'unbounds disjunction', ->
        oneOrZero = new n.InfixExpression '||', new n.IntegerLiteral('1'), new n.IntegerLiteral('0')
        assert.equal e.unbound(oneOrZero).length, 0

    describe 'visitFunctionCall', ->
      it 'unbounds', ->
        foobar = new n.FunctionCall 'and', [new n.IntegerLiteral('1'), new n.IntegerLiteral('0')]
        assert.equal e.unbound(foobar).length, 0
