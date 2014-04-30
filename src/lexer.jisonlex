ident           ^([$A-Za-z_\x7f-\uffff][$\w\x7f-\uffff]*)([^\n\S]*:(?!:))?
script_param    ^\(([$A-Za-z_\x7f-\uffff][$\w\x7f-\uffff]*)([^\n\S]*:(?!:))?\)

%s js
%s attr

%%

\"[^\"]*\" %{
  yytext = yytext.substr(1, yyleng - 2);
  return 'STRING'
%}

"--".*(\r|\n) %{ 
  yytext = yytext.substr(2, yyleng - 3).trim();
  return 'COMMENT';
%}

<js>(.|\n|\r)*?"end" %{ 
  this.popState();
  
  yytext = yytext.substr(0, yyleng - 3).trim();
  return 'SCRIPT';
%}

\s+             { /* skip whitespace */ }
"object"        { return 'OBJECT'; }
"property"      { return 'PROPERTY'; }
"prop"          { return 'PROPERTY'; }
"array"         { return 'ARRAY'; }
"as"            { return 'AS'; }
"end"           { return 'END'; }
<attr>"name"    { return 'ATTRIBUTE'; }
{ident}         { return 'IDENTIFIER'; } 
{script_param}  { this.begin('js'); return 'SCRIPT_PARAM'; }
"@"             { return 'GLOBAL_GLYPH'; }
"."             { return 'DOT'; }
","             { return 'COMMA'; }
"="             { return 'EQUALS'; }
"["             { return 'OPEN_BRACKET'; }
"]"             { return 'CLOSE_BRACKET'; }
"("             { this.begin('attr'); return 'OPEN_PARENTHESE'; }
")"             { this.popState(); return 'CLOSE_PARENTHESE'; }
<<EOF>>         { return 'EOF'; }