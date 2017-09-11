% parser for the mdc language
% input: a sequence of characters
% output: a list of tokens
fun {Parse Input}
   % first lexemize, then tokenize the input
   try
      {Tokenize {Lexemize Input}}
   catch Exception then
      raise parser(Exception) end
   end
end