# evaluator tests

e = require '../src/evaluator'
assert = require 'assert'

describe 'evaluator', ->
  describe '.', ->
    describe 'build', ->
      it 'builds numbers', ->
        f = e.build {
          expression: 'integer'
          value: 5
        }
        assert.equal f.value, 5
