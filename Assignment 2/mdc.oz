functor
import
  Application(exit:Exit)
  System
define
  \insert List.oz

  fun {Lex Input}
      {String.tokens Input & }
  end

  fun {Tokenize Lexemes}
    case Lexemes of nil then nil
    [] Lexeme | Lexemes then
      Token in
      try
        if Lexeme == "p" orelse Lexeme == "f" then
          Token = cmd({String.toAtom Lexeme})
        elseif Lexeme == "+"
        orelse Lexeme == "-"
        orelse Lexeme == "*"
        orelse Lexeme == "/"
        then
          Token = op({String.toAtom Lexeme})
        else
          Token = int({String.toInt Lexeme})
        end
          catch _ then
        raise tokenizer(lexeme:Lexeme) end
          end
          Token|{Tokenize Lexemes}
        end
      end





  %{System.print {Lex "1 2 + 3 *"}}
  {System.print {Tokenize ["1" "18" "-" "3" "*"]}}
  {Exit 0}
end
