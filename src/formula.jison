/* force dot com formula parser */

%lex
%%

\s+                         { /* ignore */         }
"("                         { return '(';          }
")"                         { return ')';          }
"+"                         { return '+';          }
"-"                         { return '-';          }
"*"                         { return '*';          }
"/"                         { return '/';          }
"^"                         { return '^';          }
"=="                        { return '==';         }
"="                         { return '=';          }
"<>"                        { return '<>';         }
"!="                        { return '!=';         }
"<="                        { return '<=';         }
">="                        { return '>=';         }
"<"                         { return '<';          }
">"                         { return '>';          }
"&&"                        { return '&&';         }
"||"                        { return '||';         }
"&"                         { return '&';          }
"."                         { return '.';          }
","                         { return ',';          }
\$?[a-zA-Z][_a-zA-Z0-9]*    { return 'IDENTIFIER'; }
[0-9]+                      { return 'NUM';        }
'"'[^"]*'"'                 { return 'STRING';     }
"'"[^']*"'"                 { return 'STRING';     }
<<EOF>>                     { return 'EOF';        }

/lex

%%

root
  : formula EOF
    { return $formula; }
  ;

formula
  : expr
  ;

function_call
  : identifier '(' ')'
    { $$ = new node.FunctionCall( $identifier, [] ); }
  | identifier '(' parameters ')'
    { $$ = new node.FunctionCall( $identifier, $parameters ); }
  ;

parameters
  : parameter
    { $$ = [$parameter]; }
  | parameters ',' parameter
    { $$ = $parameters; $$.push( $parameter ); }
  ;

parameter
  : formula
  ;

expr
  : comp_expr
  | expr0
  ;

expr0
  : or_expr
  | expr1
  ;

expr1
  : and_expr
  | expr2
  ;

expr2
  : add_expr
  | expr3
  ;

expr3
  : mult_expr
  | expr4
  ;

expr4
  : exp_expr
  | primary
  ;

exp_expr
  : expr4 '^' primary
    { $$ = { expression: 'exponent', left: $expr4, right: $primary }; }
  ;

mult_expr
  : expr3 '*' expr4
    { $$ = new node.Multiplication( $expr3, $expr4 ); }
  | expr3 '/' expr4
    { $$ = new node.Division( $expr3, $expr4 ); }
  ;

add_expr
  : expr2 '+' expr3
    { $$ = new node.Addition( $expr2, $expr3 ); }
  | expr2 '-' expr3
    { $$ = new node.Subtraction( $expr2, $expr3 ); }
  | expr2 '&' expr3
    { $$ = new node.Concatenation( $expr2, $expr3 ); }
  ;

and_expr
  : expr1 '&&' expr2
    { $$ = new node.Conjunction( $expr1, $expr2 ); }
  ;

or_expr
  : expr0 '||' expr1
    { $$ = new node.Disjunction( $expr0, $expr1 ); }
  ;

comp_expr
  : expr comparator expr0
    { $$ = new node.Comparison( $comparator, $expr, $expr0 ); }
  ;

comparator
  : '=='
  | '='
  | '<>'
  | '!='
  | '<='
  | '<'
  | '>='
  | '>'
  ;

primary
  : literal
  | function_call
  | reference
  | '(' formula ')'
    { $$ = new node.Parens( $formula ); }
  ;

reference
  : identifiers
    { $$ = new node.Reference( $identifiers ); }
  ;

identifiers
  : identifier
    { $$ = [$identifier]; }
  | identifiers '.' identifier
    { $$ = $identifiers; $$.push( $identifier ); }
  ;

identifier
  : IDENTIFIER
  ;

literal
  : int_literal
    { $$ = new node.IntegerLiteral( $int_literal ); }
  | dec_literal
  | quoted_string
  ;

int_literal
  : NUM
  ;

dec_literal
  : int_literal '.' int_literal
    { $$ = new node.DecimalLiteral( $int_literal1, $int_literal2 ); }
  ;

quoted_string
  : str_literal
    { $$ = new node.StringLiteral( $str_literal.substring(1,$str_literal.length-1) ); }
  ;

str_literal
  : STRING
  ;
