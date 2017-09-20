functor
import
    System
define

  fun {Lex Input}
    {String.tokens Input & }
  end

  fun {ConvertToRecord Lexeme}
    if {String.isInt Lexeme} then
      number({String.toInt Lexeme})
    elseif Lexeme =="p" then
      cmd(Lexeme)
    elseif Lexeme =="d" then
      cmd(Lexeme)
    elseif Lexeme =="i" then
      cmd(Lexeme)
    elseif Lexeme =="^" then
      cmd(Lexeme)
    else
      operator(Lexeme)
    end
  end

  fun {Tokenize Lexemes}
    {Map Lexemes ConvertToRecord}
  end

  fun {IsLowerOperator Operator}
    if Operator == operator("+") then
      true
    elseif Operator == operator("-") then
      true
    else
      false
    end
  end

  fun {IsOperator Token}
    {Record.label Token} == operator
  end

  fun {ShuntInternal Tokens OperatorStack OutputStack}
    case Tokens of Head|Tail then
      if {IsOperator Head} then
        {ShuntInternal Tail Head|OperatorStack OutputStack}
      else
        {ShuntInternal Tail OperatorStack Head|OutputStack}
      end
    [] nil then
      {List.flatten {List.reverse OutputStack}|{SortOperators OperatorStack}}
    end
  end

  fun {IsHigherOperator Operator}
    {IsLowerOperator Operator} == false
  end

  fun {OpLeq FirstOperator SecondOperator}
    if {IsHigherOperator FirstOperator} then
      {IsHigherOperator SecondOperator}
    else
      true
    end
  end

  fun {SortOperators Tokens}
    {List.reverse {List.sort Tokens OpLeq }}
  end

  fun {Shunt Tokens}
    {ShuntInternal Tokens nil nil}
  end

  {System.print {Shunt {Tokenize {Lex "3 - 10 * 9 + 3"}}}}
end
