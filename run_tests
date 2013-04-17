#!/usr/local/bin/node
var p = require('./dst/parser');

function assertEqual( a, b ) {
    if ( a != b ) {
        throw "Expected " + b + " to equal " + a;
    }
}

assertEqual( '5', p.parse('   5   ') );

var decimal = p.parse('3.2');
assertEqual( 'decimal', decimal.expression );
assertEqual( '3', decimal.whole );
assertEqual( '2', decimal.part );

var str = p.parse('"foobar"');
assertEqual( 'string', str.expression );
assertEqual( 'foobar', str.string );

var sstr = p.parse("'foobar'");
assertEqual( 'string', sstr.expression );
assertEqual( 'foobar', sstr.string );

var today = p.parse(' today  (  ) ');
assertEqual( 'today', today.function );
assertEqual( 0, today.parameters.length );

assertEqual( '5', p.parse(' (  5  )  ').formula );

var sum = p.parse('   sum (  3 ,  1 ,  8  ) ');
assertEqual( 'function', sum.expression );
assertEqual( 3, sum.parameters.length );
assertEqual( '3', sum.parameters[0] );
assertEqual( '1', sum.parameters[1] );
assertEqual( '8', sum.parameters[2] );

var inverse = p.parse('   not  ( today \n\n(   )\n)\n');
assertEqual( 'function', inverse.expression );
assertEqual( 'not', inverse.function );
assertEqual( 1, inverse.parameters.length );
assertEqual( 'function', inverse.parameters[0].expression );
assertEqual( 'today', inverse.parameters[0].function );

var field = p.parse('   relationship__r  . field__c ');
assertEqual( 'reference', field.expression );
assertEqual( 'relationship__r', field.name[0] );
assertEqual( 'field__c', field.name[1] );

assertEqual( '$User', p.parse('$User.Name').name[0] );

var expr = p.parse('2+\n7*5');
assertEqual( 'add', expr.expression );
assertEqual( '2', expr.left );
assertEqual( 'multiply', expr.right.expression );
assertEqual( '7', expr.right.left );
assertEqual( '5', expr.right.right );

var order = p.parse('1<2||3&&4+5*6^7');
assertEqual( 'comparison', order.expression );
assertEqual( 'disjunction', order.right.expression );
assertEqual( 'conjunction', order.right.right.expression );
assertEqual( 'add', order.right.right.right.expression );
assertEqual( 'multiply', order.right.right.right.right.expression );
assertEqual( 'exponent', order.right.right.right.right.right.expression );

var nest = p.parse('2+today()');
assertEqual( 'add', nest.expression );
assertEqual( '2', nest.left );
assertEqual( 'today', nest.right.function );
