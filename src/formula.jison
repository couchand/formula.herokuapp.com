/* force dot com formula parser */

%lex
%%

\s*                     { /* ignore */         }
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

%%

root
  : formula
    { return $formula; }
  ;

formula
  : literal
    { return $literal; }
  ;

literal
  : NUM
  ;
