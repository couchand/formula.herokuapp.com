# nodes tests

n = require '../src/nodes'
assert = require 'assert'

describe 'IntegerLiteral', ->
  describe '.', ->
    describe 'constructor', ->
      it 'builds integer', ->
        f = new n.IntegerLiteral '5'
        assert.equal f.value, 5

describe 'DecimalLiteral', ->
  describe '.', ->
    describe 'constructor', ->
      it 'builds decimals', ->
        f = new n.DecimalLiteral '3', '2'
        assert.equal f.value, 3.2

describe 'StringLiteral', ->
  describe '.', ->
    describe 'constructor', ->
      it 'builds strings', ->
        f = new n.StringLiteral 'foobar'
        assert.equal f.value, 'foobar'

describe 'Reference', ->
  describe '.', ->
    describe 'constructor', ->
      it 'builds references', ->
        f = new n.Reference [
            'relationship__r'
            'field__c'
          ]
        assert.equal f.name, 'relationship__r.field__c'

describe 'Parens', ->
  describe '.', ->
    describe 'constructor', ->
      it 'builds parens', ->
        f = new n.Parens new n.IntegerLiteral '5'
        assert.equal f.formula.value, 5

describe 'FunctionCall', ->
  describe '.', ->
    describe 'constructor', ->
      it 'builds function calls', ->
        f = new n.FunctionCall 'today', []
        assert.equal f.name, 'today'
        assert.equal f.parameters.length, 0

      it 'builds function params', ->
        f = new n.FunctionCall 'foo', [new n.IntegerLiteral 5]
        assert.equal f.parameters.length, 1
        assert.equal f.parameters[0].value, 5

describe 'InfixExpression', ->
  describe '.', ->
    describe 'constructor', ->
      it 'builds infix expressions', ->
        f = new n.InfixExpression '+', new n.IntegerLiteral(5), new n.IntegerLiteral(3)
        assert.equal f.operator, '+'
        assert.equal f.left.value, 5
        assert.equal f.right.value, 3
