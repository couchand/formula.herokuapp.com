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
  : function_call
  | expr
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
  : primary
  ;

primary
  : literal
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
