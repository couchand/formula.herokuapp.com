# build parser and examples

dst/parser.js: src/formula.jison
	jison -o ./dst/parser.js ./src/formula.jison

dst/nodes.js: dst/parser.js src/nodes.coffee
	coffee -c -o ./dst/ ./src/nodes.coffee

dst/printer.js: dst/parser.js dst/nodes.js src/visitor.coffee src/printer.coffee src/elideRequire.patch
	coffee -c -o ./dst/ -j printer ./src/visitor.coffee ./src/printer.coffee
	patch ./dst/printer.js ./src/elideRequire.patch

dst/tree.js: dst/parser.js dst/nodes.js src/visitor.coffee src/tree.coffee src/elideRequire.patch
	coffee -c -o ./dst/ -j tree ./src/visitor.coffee ./src/tree.coffee
	patch ./dst/tree.js ./src/elideRequire.patch

dst/evaluator.js: src/evaluator.coffee
	coffee -c -o ./dst/ ./src/evaluator.coffee

dst/server.js: src/server.coffee
	coffee -c -o ./dst/ ./src/server.coffee

dst/tester.js: src/tester.coffee
	coffee -c -o ./dst/ ./src/tester.coffee

dst/visitor.js: src/visitor.coffee
	coffee -c -o ./dst/ ./src/visitor.coffee

dst/apex.js: src/apex.coffee
	coffee -c -o ./dst/ ./src/apex.coffee

parser: dst/parser.js
examples: dst/printer.js dst/tree.js
server: dst/evaluator.js dst/server.js dst/tester.js dst/visitor.js
other: dst/apex.js
all: parser examples server other
