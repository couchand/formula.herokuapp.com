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
    { $$ = { expression: 'multiply', left: $expr3, right: $expr4 }; }
  | expr3 '/' expr4
    { $$ = { expression: 'divide', left: $expr3, right: $expr4 }; }
  ;

add_expr
  : expr2 '+' expr3
    { $$ = { expression: 'add', left: $expr2, right: $expr3 }; }
  | expr2 '-' expr3
    { $$ = { expression: 'subtract', left: $expr2, right: $expr3 }; }
  | expr2 '&' expr3
    { $$ = { expression: 'concat', left: $expr2, right: $expr3 }; }
  ;

and_expr
  : expr1 '&&' expr2
    { $$ = { expression: 'conjunction', left: $expr1, right: $expr2 }; }
  ;

or_expr
  : expr0 '||' expr1
    { $$ = { expression: 'disjunction', left: $expr0, right: $expr1 }; }
  ;

comp_expr
  : expr comparator expr0
    { $$ = { expression: 'comparison', comparator: $comparator, left: $expr, right: $expr0 }; }
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
    { $$ = { expression: 'integer', value: $int_literal }; }
  | dec_literal
  | quoted_string
  ;

int_literal
  : NUM
  ;

dec_literal
  : int_literal '.' int_literal
    { $$ = { expression: 'decimal', whole: $int_literal1, part: $int_literal2 }; }
  ;

quoted_string
  : str_literal
    { $$ = { expression: 'string', string: $str_literal.substring(1,$str_literal.length-1) }; }
  ;

str_literal
  : STRING
  ;
