# evaluator tests

e = require '../src/evaluator'
assert = require 'assert'

describe 'evaluator', ->
  describe '.', ->
    describe 'build', ->
      it 'builds integer', ->
        f = e.build {
          expression: 'integer'
          value: 5
        }
        assert.equal f.value, 5

      it 'builds decimals', ->
        f = e.build {
          expression: 'decimal'
          whole: 3
          part: 2
        }
        assert.equal f.value, 3.2

      it 'builds strings', ->
        f = e.build {
          expression: 'string'
          string: 'foobar'
        }
        assert.equal f.value, 'foobar'

      it 'builds references', ->
        f = e.build {
          expression: 'reference'
          name: [
            'relationship__r'
            'field__c'
          ]
        }
        assert.equal f.name, 'relationship__r.field__c'

      it 'builds parens', ->
        f = e.build {
          expression: 'parens'
          formula: {
            expression: 'integer'
            value: 5
          }
        }
        assert.equal f.formula.value, 5

      it 'builds function calls', ->
        f = e.build {
          expression: 'function'
          function: 'today'
          parameters: []
        }
        assert.equal f.name, 'today'
        assert.equal f.params.length, 0

      it 'builds function params', ->
        f = e.build {
          expression: 'function'
          function: 'foo'
          parameters: [
            {
              expression: 'integer'
              value: 5
            }
          ]
        }
        assert.equal f.params.length, 1
        assert.equal f.params[0].value, 5

      it 'builds infix expressions', ->
        f = e.build {
          expression: 'add'
          left:
            {
              expression: 'integer'
              value: 5
            }
          right:
            {
              expression: 'integer'
              value: 3
            }
        }
        assert.equal f.left.value, 5
        assert.equal f.right.value, 3
