% tokenizer for the mdc language
% input: a list of lexemes
% output: a list of tokens
% raises an exception on an unrecognized lexeme
% (should be the lexer's responsibility, eh?)
fun {Tokenize Lexemes}
   % if Lexemes is...
   case Lexemes
   of nil then
      % an empty list, return an empty list
      nil
   [] Lexeme|Lexemes then
      % a list of at least one lexeme, classify the lexeme,
      Token in
      try 
	 if Lexeme == "p" orelse Lexeme == "f"
	 then Token = cmd({String.toAtom Lexeme})
	 elseif Lexeme == "+"
	    orelse Lexeme == "-"
	    orelse Lexeme == "*"
	    orelse Lexeme == "/"
	 then Token = op({String.toAtom Lexeme})
	 else Token = int({String.toInt Lexeme})
	 end
      catch _ then 
	 raise tokenizer(lexeme:Lexeme) end
      end
      % and return the token together with the rest of lexemes
      % tokenized recursively
      Token|{Tokenize Lexemes}
   end
end