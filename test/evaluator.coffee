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
