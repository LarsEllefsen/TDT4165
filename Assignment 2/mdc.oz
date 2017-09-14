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
        if Lexeme == "p" orelse Lexeme == "f" orelse Lexeme == "i"
        orelse Lexeme == "^" then
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

    fun {Interpret Tokens}
    %Kode her
      fun {Iterate Stack Tokens}
        case Tokens of nil then Stack
        %Check if it is an integer
        [] int(Integer)|Tokens then
          {Iterate Integer|Stack Tokens}
        [] op(Lexeme)|Tokens then
          Int1|Int2|Rest = Stack
          Operator = try Number.Lexeme
                     catch _ then Int.'div' end in
          {Iterate {Operator Int2 Int1}|Rest Tokens}
        [] cmd(p)|Tokens then
            Stack
        [] cmd(i)|Tokens then
          Top|Rest = Stack in
            {Iterate Top*~1|Rest Tokens}
        [] cmd('^')|Tokens then
          Top|Rest = Stack in
            {Iterate {Float.'/' 1.0 {IntToFloat Top}}|Rest Tokens}
            %Stack
        end
      end
      in
        try
          {Iterate nil Tokens}
        catch _ then
          raise "stack empty" end
        end
      end



  %{System.print {Lex "1 2 3 +"}}
  %{System.print {Tokenize ["1" "2" "3" "^" "i"]}}
  %{System.print {Interpret {Tokenize {Lex "2 3 4 5 6.0 ^"}}}}
  {System.print {Interpret [int(1) int(2) int(3) cmd('^')]}}
  {Exit 0}
end
