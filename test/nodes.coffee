# evaluator tests

n = require '../src/nodes'
assert = require 'assert'

describe 'evaluator', ->
  describe '.', ->
    describe 'build', ->
      it 'builds integer', ->
        f = new n.IntegerLiteral '5'
        assert.equal f.value, 5

      it 'builds decimals', ->
        f = new n.DecimalLiteral '3', '2'
        assert.equal f.value, 3.2

      it 'builds strings', ->
        f = new n.StringLiteral 'foobar'
        assert.equal f.value, 'foobar'

      it 'builds references', ->
        f = new n.Reference [
            'relationship__r'
            'field__c'
          ]
        assert.equal f.name, 'relationship__r.field__c'

      it 'builds parens', ->
        f = new n.Parens new n.IntegerLiteral '5'
        assert.equal f.formula.value, 5

      it 'builds function calls', ->
        f = new n.FunctionCall 'today', []
        assert.equal f.name, 'today'
        assert.equal f.parameters.length, 0

      it 'builds function params', ->
        f = new n.FunctionCall 'foo', [new n.IntegerLiteral 5]
        assert.equal f.parameters.length, 1
        assert.equal f.parameters[0].value, 5

      it 'builds infix expressions', ->
        f = new n.Addition new n.IntegerLiteral(5), new n.IntegerLiteral(3)
        assert.equal f.left.value, 5
        assert.equal f.right.value, 3
