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
    { $$ = { expression: 'function', function: $identifier, parameters: [] }; }
  | identifier '(' parameters ')'
    { $$ = { expression: 'function', function: $identifier, parameters: $parameters }; }
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
    { $$ = { expression: 'exponent', left: $expr, right: $expr0 }; }
  ;

mult_expr
  : expr0 '*' expr1
    { $$ = { expression: 'multiply', left: $expr0, right: $expr1 }; }
  | expr0 '/' expr1
    { $$ = { expression: 'divide', left: $expr0, right: $expr1 }; }
  ;

add_expr
  : expr1 '+' expr2
    { $$ = { expression: 'add', left: $expr1, right: $expr2 }; }
  | expr1 '-' expr2
    { $$ = { expression: 'subtract', left: $expr1, right: $expr2 }; }
  | expr1 '&' expr2
    { $$ = { expression: 'concat', left: $expr1, right: $expr2 }; }
  ;

and_expr
  : expr2 '&&' expr3
    { $$ = { expression: 'conjunction', left: $expr2, right: $expr3 }; }
  ;

or_expr
  : expr3 '||' expr4
    { $$ = { expression: 'disjunction', left: $expr3, right: $expr4 }; }
  ;

comp_expr
  : expr4 comparator primary
    { $$ = { expression: 'comparison', comparator: $comparator, left: $expr4, right: $primary }; }
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
    { $$ = { expression: 'parens', formula: $formula }; }
  ;

reference
  : identifiers
    { $$ = { expression: 'reference', name: $identifiers }; }
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
  | dec_literal
  ;

int_literal
  : NUM
  ;

dec_literal
  : int_literal '.' int_literal
    { $$ = { whole: $int_literal1, part: $int_literal2 }; }
  ;
