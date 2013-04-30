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
    { $$ = new yy.FunctionCall( $identifier, [] ); }
  | identifier '(' parameters ')'
    { $$ = new yy.FunctionCall( $identifier, $parameters ); }
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
    { $$ = new yy.Exponentiation( $expr4, $primary ); }
  ;

mult_expr
  : expr3 '*' expr4
    { $$ = new yy.Multiplication( $expr3, $expr4 ); }
  | expr3 '/' expr4
    { $$ = new yy.Division( $expr3, $expr4 ); }
  ;

add_expr
  : expr2 '+' expr3
    { $$ = new yy.Addition( $expr2, $expr3 ); }
  | expr2 '-' expr3
    { $$ = new yy.Subtraction( $expr2, $expr3 ); }
  | expr2 '&' expr3
    { $$ = new yy.Concatenation( $expr2, $expr3 ); }
  ;

and_expr
  : expr1 '&&' expr2
    { $$ = new yy.Conjunction( $expr1, $expr2 ); }
  ;

or_expr
  : expr0 '||' expr1
    { $$ = new yy.Disjunction( $expr0, $expr1 ); }
  ;

comp_expr
  : expr comparator expr0
    { $$ = new yy.Comparison( $comparator, $expr, $expr0 ); }
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
    { $$ = new yy.Parens( $formula ); }
  ;

reference
  : identifiers
    { $$ = new yy.Reference( $identifiers ); }
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
    { $$ = new yy.IntegerLiteral( $int_literal ); }
  | dec_literal
  | quoted_string
  ;

int_literal
  : NUM
  ;

dec_literal
  : int_literal '.' int_literal
    { $$ = new yy.DecimalLiteral( $int_literal1, $int_literal2 ); }
  ;

quoted_string
  : str_literal
    { $$ = new yy.StringLiteral( $str_literal.substring(1,$str_literal.length-1) ); }
  ;

str_literal
  : STRING
  ;
