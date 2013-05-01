# apex compiler tests

n = require '../src/nodes'
apex = require '../src/apex'
assert = require 'assert'

describe 'ApexCompiler', ->
  describe '#', ->
    describe 'visitIntegerLiteral', ->
      it 'compiles', ->
        five = new n.IntegerLiteral '5'
        assert.equal apex(five), '5'

    describe 'visitStringLiteral', ->
      it 'compiles', ->
        foobar = new n.StringLiteral 'foobar'
        assert.equal apex(foobar), "'foobar'"

    describe 'visitReference', ->
      it 'compiles plain references', ->
        accountName = new n.Reference ['Account', 'Name']
        assert.equal apex(accountName), 'Account.Name'

      it 'compiles references with context', ->
        name = new n.Reference ['Name']
        assert.equal apex(name, 'Account'), 'Account.Name'

      it 'compiles globals with context', ->
        userProfile = new n.Reference ['$UserInfo','ProfileId']
        assert.equal apex(userProfile, 'Account'), '$UserInfo.ProfileId'

    describe 'visitParens', ->
      it 'compiles', ->
        five = new n.Parens new n.IntegerLiteral '5'
        assert.equal apex(five), '( 5 )'

    describe 'visitInfixExpression', ->
      it 'compiles', ->
        fivePlusThree = new n.InfixExpression '+', new n.IntegerLiteral('5'), new n.IntegerLiteral('3')
        assert.equal apex(fivePlusThree), '5 + 3'
