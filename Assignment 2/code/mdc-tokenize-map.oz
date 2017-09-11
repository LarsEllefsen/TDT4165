fun {Tokenize Lexemes}
   Commands = ["p" "f"]
   Operators = ["+" "-" "*" "/"]
in
   {Map Lexemes
    fun {$ Lexeme}
       if {Member Lexeme Commands} then
	  cmd({String.toAtom Lexeme})
       elseif {Member Lexeme Operators} then
	  op({String.toAtom Lexeme})
       else
	  try int({String.toInt Lexeme})
	  catch _ then raise "invalid lexeme '"#Lexeme#"'" end
	  end
       end
    end}
end