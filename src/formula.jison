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
    { $$ = $function_call; }
  | expr
    { $$ = $expr; }
  ;

function_call
  : function '(' ')'
    { $$ = { function: $function, parameters: [] }; }
  ;

function
  : IDENTIFIER
  ;

expr
  : literal
    { $$ = $literal; }
  | '(' formula ')'
    { $$ = { formula: $formula }; }
  ;

literal
  : NUM
  ;
