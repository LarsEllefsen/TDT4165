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
    fun {Iterate Stack Tokens}
      case Tokens of nil then Stack
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

  %Hacky løsning, men fy faen ingenting annet funket!
  fun {ShuntInternal Tokens OpStack OutStack}
		case OpStack of Pushed|Top|Tail then
			if {OpLeq Pushed Top} then
				{ShuntInternal Tokens Pushed|Tail Top|OutStack}
			else
				local NewOutStack NewOpStack NewTail in
					case Tokens of Head|Tail then

						case Head of int(Integer) then
							NewOpStack = OpStack
							NewOutStack = Head|OutStack

						[] op(Operator) then
								NewOpStack = Head|OpStack
								NewOutStack = OutStack
						end
						{ShuntInternal Tail NewOpStack NewOutStack}
					else
						% 3e)
						{Reverse {Append {Reverse OpStack} OutStack}}
					end
				end
			end
		else
			local NewOutStack NewOpStack NewTail in
				case Tokens of Head|Tail then

					case Head of int(Integer) then
						NewOpStack = OpStack
						NewOutStack = Head|OutStack

					[] op(Operator) then
							NewOpStack = Head|OpStack
							NewOutStack = OutStack
					end
					{ShuntInternal Tail NewOpStack NewOutStack}
				else
					{Reverse {Append {Reverse OpStack} OutStack}}
				end
			end
		end
	end


  fun {SortOperators Tokens}
  {List.reverse {List.sort Tokens OpLeq }}
end

  fun {Precedence Operator}
    case Operator of op(X) then
      if X == '+' orelse X == '-' then
        1
      else
        2
      end
    end
  end

  fun {OpLeq Pushing Top}
    if {Precedence Top} >= {Precedence Pushing} then
      true
    else
      false
    end
  end

  fun {Shunt Tokens}
    {ShuntInternal Tokens nil nil}
  end



  %{System.print {OpLeq op('*') op('+')}}
  %{System.print {ShuntInternal [int(3) op('-') int(10) op('*') int(9) op('+') int(3)] nil nil}}
  %{System.print {Lex "1 2 3 +"}}
  %{System.print {Tokenize ["3" "-" "10" "*" "9" "+" "4"]}}
  %{System.print {Interpret {Tokenize {Lex "2 3 4 5 6.0 ^"}}}}
  %{System.print {Interpret [int(1) int(2) int(3) cmd('^')]}}
  {System.show {Interpret {Shunt {Tokenize {Lex "3 - 10 * 9 + 4"}}}}}
  {Exit 0}
end
