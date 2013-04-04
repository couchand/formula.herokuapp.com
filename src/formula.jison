/* force dot com formula parser */

%lex
%%

\s+                     { /* ignore */         }
"("                     { return '(';          }
")"                     { return ')';          }
"+"                     { return '+';          }
"-"                     { return '-';          }
"*"                     { return '*';          }
"/"                     { return '/';          }
"^"                     { return '^';          }
"=="                    { return '==';         }
"="                     { return '=';          }
"<>"                    { return '<>';         }
"!="                    { return '!=';         }
"<="                    { return '<=';         }
">="                    { return '>=';         }
"<"                     { return '<';          }
">"                     { return '>';          }
"&&"                    { return '&&';         }
"||"                    { return '||';         }
"&"                     { return '&';          }
"."                     { return '.';          }
","                     { return ',';          }
[a-zA-Z][a-zA-Z0-9]+    { return 'IDENTIFIER'; }
[0-9]+                  { return 'NUM';        }
<<EOF>>                 { return 'EOF';        }

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
  : function '(' ')'
    { $$ = { function: $function, parameters: [] }; }
  | function '(' parameters ')'
    { $$ = { function: $function, parameters: $parameters }; }
  ;

function
  : IDENTIFIER
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
  : literal
  | '(' formula ')'
    { $$ = { formula: $formula }; }
  ;

literal
  : NUM
  ;
