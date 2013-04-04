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
    { $$ = { function: $identifier, parameters: [] }; }
  | identifier '(' parameters ')'
    { $$ = { function: $identifier, parameters: $parameters }; }
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
  : exp_expr
  | expr0
  ;

expr0
  : mult_expr
  | expr1
  ;

expr1
  : add_expr
  | expr2
  ;

expr2
  : and_expr
  | expr3
  ;

expr3
  : or_expr
  | expr4
  ;

expr4
  : comp_expr
  | primary
  ;

exp_expr
  : expr '^' expr0
    { $$ = { base: $expr, pow: $expr0 }; }
  ;

mult_expr
  : expr0 '*' expr1
    { $$ = { factors: [$expr0, $expr1] }; }
  | expr0 '/' expr1
    { $$ = { dividend: $expr0, divisor: $expr1 }; }
  ;

add_expr
  : expr1 '+' expr2
    { $$ = { terms: [$expr1, $expr2] }; }
  | expr1 '-' expr2
    { $$ = { differee: $expr1, differant: $expr2 }; }
  | expr1 '&' expr2
    { $$ = { concat: [$expr1, $expr2] }; }
  ;

and_expr
  : expr2 '&&' expr3
    { $$ = { conjunction: [$expr2, $expr3] }; }
  ;

or_expr
  : expr3 '||' expr4
    { $$ = { disjunction: [$expr3, $expr4] }; }
  ;

comp_expr
  : expr4 comparator primary
    { $$ = { comparator: $comparator, left: $expr4, right: $primary }; }
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
    { $$ = { formula: $formula }; }
  ;

reference
  : identifier
    { $$ = [$identifier]; }
  | reference '.' identifier
    { $$ = $reference; $$.push( $identifier ); }
  ;

identifier
  : IDENTIFIER
  ;

literal
  : NUM
  ;
