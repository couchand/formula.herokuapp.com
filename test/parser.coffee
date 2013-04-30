# parser tests

p = require '../dst/parser'
p.parser.yy = require '../src/nodes'
assert = require 'assert'

describe 'parser', ->
  it 'parses numbers', ->
    assert.equal 5, p.parse('5').value

  it 'ignores whitespace', ->
    assert.equal 5, p.parse('   5   ').value

  it 'parses decimals', ->
    decimal = p.parse('3.2')
    assert.equal 3.2, decimal.value

  it 'parses double-quote strings', ->
    str = p.parse('"foobar"')
    assert.equal 'foobar', str.value

  it 'parses single-quote strings', ->
    sstr = p.parse("'foobar'")
    assert.equal 'foobar', sstr.value

  it 'parses functions', ->
    today = p.parse(' today  (  ) ')
    assert.equal 'today', today.name
    assert.equal 0, today.parameters.length

  it 'parses parens', ->
    assert.equal '5', p.parse(' (  5  )  ').formula.value

  it 'parses function parameters', ->
    sum = p.parse('   sum (  3 ,  1 ,  8  ) ')
    assert.equal 3, sum.parameters.length
    assert.equal '3', sum.parameters[0].value
    assert.equal '1', sum.parameters[1].value
    assert.equal '8', sum.parameters[2].value

  it 'parses nested functions', ->
    inverse = p.parse('not(today())')
    assert.equal 'not', inverse.name
    assert.equal 1, inverse.parameters.length
    assert.equal 'today', inverse.parameters[0].name

  it 'ignores whitespace in functions', ->
    inverse = p.parse('   not  ( today \n\n(   )\n)\n')
    assert.equal 'not', inverse.name
    assert.equal 1, inverse.parameters.length
    assert.equal 'today', inverse.parameters[0].name

  it 'parses references', ->
    field = p.parse('   relationship__r  . field__c ')
    assert.equal 'relationship__r.field__c', field.name

  it 'parses global variables', ->
    assert.equal '$User.Name', p.parse('$User.Name').name

  it 'parses math syntax', ->
    expr = p.parse('2+\n7*5')
    assert.equal '2', expr.left.value
    assert.equal '7', expr.right.left.value
    assert.equal '5', expr.right.right.value

  it 'parses order of operations correctly', ->
    order = p.parse('1<2||3&&4+5*6^7')
    assert.equal 1, order.left.value
    assert.equal 2, order.right.left.value
    assert.equal 3, order.right.right.left.value
    assert.equal 4, order.right.right.right.left.value
    assert.equal 5, order.right.right.right.right.left.value
    assert.equal 6, order.right.right.right.right.right.left.value
    assert.equal 7, order.right.right.right.right.right.right.value

  it 'parses functions in math', ->
    nest = p.parse('2+today()')
    assert.equal '2', nest.left.value
    assert.equal 'today', nest.right.name
