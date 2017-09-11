declare

\insert 'mdc-lexemize.oz'
\insert 'mdc-tokenize.oz'
\insert 'mdc-interpret.oz'

proc {Test Input}
   Lexemes Tokens in
   {Show test(input:Input lexemes:Lexemes tokens:Tokens)}
   try
      Lexemes = {Lexemize Input}
      Tokens = {Tokenize Lexemes}
      {Interpret Tokens}
   catch Exception then
      {Show Exception}
   end
end

{Test "1 2 + pas"}
{Test "1 2 f * f 3 4 + / p"}
{Test "12 f* f34 +/p"}
{Test "1 +"}