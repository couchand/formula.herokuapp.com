// parser tests

var p = require('../dst/parser');
var assert = require('assert');

describe('parser', function() {
    it('parses numbers', function() {
        assert.equal( '5', p.parse('5') );
    });

    it('ignores whitespace', function() {
        assert.equal( '5', p.parse('   5   ') );
    });

    it('parses decimals', function() {
        var decimal = p.parse('3.2');
        assert.equal( 'decimal', decimal.expression );
        assert.equal( '3', decimal.whole );
        assert.equal( '2', decimal.part );
    });

    it('parses double-quote strings', function() {
        var str = p.parse('"foobar"');
        assert.equal( 'string', str.expression );
        assert.equal( 'foobar', str.string );
    });

    it('parses single-quote strings', function() {
        var sstr = p.parse("'foobar'");
        assert.equal( 'string', sstr.expression );
        assert.equal( 'foobar', sstr.string );
    });

    it('parses functions', function() {
        var today = p.parse(' today  (  ) ');
        assert.equal( 'today', today.function );
        assert.equal( 0, today.parameters.length );
    });

    it('parses parens', function() {
        assert.equal( '5', p.parse(' (  5  )  ').formula );
    });

    it('parses function parameters', function() {
        var sum = p.parse('   sum (  3 ,  1 ,  8  ) ');
        assert.equal( 'function', sum.expression );
        assert.equal( 3, sum.parameters.length );
        assert.equal( '3', sum.parameters[0] );
        assert.equal( '1', sum.parameters[1] );
        assert.equal( '8', sum.parameters[2] );
    });

    it('parses nested functions', function() {
        var inverse = p.parse('not(today())');
        assert.equal( 'function', inverse.expression );
        assert.equal( 'not', inverse.function );
        assert.equal( 1, inverse.parameters.length );
        assert.equal( 'function', inverse.parameters[0].expression );
        assert.equal( 'today', inverse.parameters[0].function );
    });

    it('ignores whitespace in functions', function() {
        var inverse = p.parse('   not  ( today \n\n(   )\n)\n');
        assert.equal( 'function', inverse.expression );
        assert.equal( 'not', inverse.function );
        assert.equal( 1, inverse.parameters.length );
        assert.equal( 'function', inverse.parameters[0].expression );
        assert.equal( 'today', inverse.parameters[0].function );
    });

    it('parses references', function() {
        var field = p.parse('   relationship__r  . field__c ');
        assert.equal( 'reference', field.expression );
        assert.equal( 'relationship__r', field.name[0] );
        assert.equal( 'field__c', field.name[1] );
    });

    it('parses global variables', function() {
        assert.equal( '$User', p.parse('$User.Name').name[0] );
    });

    it('parses math syntax', function() {
        var expr = p.parse('2+\n7*5');
        assert.equal( 'add', expr.expression );
        assert.equal( '2', expr.left );
        assert.equal( 'multiply', expr.right.expression );
        assert.equal( '7', expr.right.left );
        assert.equal( '5', expr.right.right );
    });

    it('parses order of operations correctly', function() {
        var order = p.parse('1<2||3&&4+5*6^7');
        assert.equal( 'comparison', order.expression );
        assert.equal( 'disjunction', order.right.expression );
        assert.equal( 'conjunction', order.right.right.expression );
        assert.equal( 'add', order.right.right.right.expression );
        assert.equal( 'multiply', order.right.right.right.right.expression );
        assert.equal( 'exponent', order.right.right.right.right.right.expression );
    });

    it('parses functions in math', function() {
        var nest = p.parse('2+today()');
        assert.equal( 'add', nest.expression );
        assert.equal( '2', nest.left );
        assert.equal( 'today', nest.right.function );
    });
});
