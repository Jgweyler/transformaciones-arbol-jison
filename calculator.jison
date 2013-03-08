/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"PI"                  return 'PI'
"E"                   return 'E'
\b[A-Za-z_]\w*\b      return 'ID'
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"!"                   return '!'
"%"                   return '%'
"="                   return '='
"("                   return '('
")"                   return ')'
";"                   return ';'
.                     return 'INVALID'

/lex

%{
var symbol_table = {};
%}


/* operator associations and precedence */

%right '='
%left '+' '-'
%left '*' '/'
%left '^'
%right '!'
%right '%'
%left UMINUS

%start prog

%% /* language grammar */
prog
    : expressions 
        { 
          $$ = $1; 
          console.log($$);
          return symbol_table;
        }
    ;

expressions
    : e 
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          $$ = [ $1 ]; }
    | expressions ';' e
        { $$ = $1.slice();
          $$.push($3); 
          console.log($$);
        }
    ;

e
    : ID '=' e
        { symbol_table[$1] = $3; }
    | e '+' e
        {$$ = $1+$3;}
    | e '-' e
        {$$ = $1-$3;}
    | e '*' e
        {$$ = $1*$3;}
    | e '/' e
        {$$ = $1/$3;}
    | e '^' e
        {$$ = Math.pow($1, $3);}
    | e '!'
        {{
          $$ = (function fact (n) { return n==0 ? 1 : fact(n-1) * n })($1);
        }}
    | e '%'
        {$$ = $1/100;}
    | '-' e %prec UMINUS
        {$$ = -$2;}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = Number(yytext);}
    | E
        {$$ = Math.E;}
    | PI
        {$$ = Math.PI;}
    | ID 
        { $$ = symbol_table[yytext]}
    ;

