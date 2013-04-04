Force.com Formula Parser
========================

Parse Force.com formula syntax.

 * quick start
 * documentation
 * dependencies
 * more information

quick start
-----------

fire up your browser and load `example/prettyprint.html`.
type in some formula syntax and click 'pretty print!'.

documentation
-------------

parses formula syntax and returns a JSON representation
of the parse tree.  leaf nodes are just their text value,
and inner nodes have an `expression` property which
describes what type of node they are.  each type of inner
node has various other properties to complete the description.

 * `function`: function call
   * `function`: text name
   * `parameters`: array of nodes
 * `reference`: field reference
   * `name`: array of text reference parts
 * `add`: arithmetic expressions
 * `subtract`
 * `multiply`
 * `divide`
 * `concat`: string expression
 * `conjunction`: logical expressions
 * `disjunction`
   * `left`: left side of operand
   * `right`: right side of operand
 * `comparison`: comparison expression
   * `comparator`: comparison operator
   * `left`: left side of comparison
   * `right`: right side of comparison
 * `parens`: parenthesized expression
   * `formula`: nested formula

dependencies
------------

run
 * none

build
 * jison

more information
----------------

 * <http://wiki.developerforce.com/page/An_Introduction_to_Formulas>
 * <https://na3.salesforce.com/help/doc/en/salesforce_formulas_cheatsheet.pdf>
