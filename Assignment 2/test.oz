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

    fun {Interpret Tokens}
    %Kode her?
      proc {Iterate Stack Tokens}
        case Tokens of nil then skip
        %Check if its an operator
        [] op(Operator)|Tokens then
          %Check what operator it is
          if Operator == '+'
          orelse Operator == '-'
          orelse Operator == '*'
          then
            Top|Second|Rest = Stack in
              {Iterate {Number.Operator Second Top}|Rest Tokens}
          elseif Operator == '/' then
            Top|Second|Rest = Stack in
              {Iterate {Int.'div' Second Top}|Rest Tokens}
          end
        %Check if it is an integer
        [] int(Integer)|Tokens then
          %Push Integer to stack, recursively
          {Iterate Integer|Stack Tokens}
        %[] cmd(Command)|Tokens then end
          %{System.print Command}
        end
      end
      in
        try
          {Iterate nil Tokens}
        catch _ then
          raise "stack empty" end
        end
      end
