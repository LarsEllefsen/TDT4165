functor
import
  Application(exit:Exit)
  System
define

%4A
  local A = 1 B = 3 C = ~9 D = 39 in
    {System.showInfo A+B+C+D}
  end

%4B
  local A=10 in
    if A==1 then
      {System.showInfo "A is equal to 1"}
    else
      {System.showInfo "A is not equal to 0"}
      if A<0 then
        {System.showInfo "A is zero!"}
      elseif A==10 then
        {System.showInfo "A is 10!"}
      else
        {System.showInfo "I dont know what A is"}
      end
    end
  end

%4C
  proc {Append List1 List2 Result}
    case List1 of nil then %Pattern Matching
      List2=Result %Variable-to-variable unification
    else
      case List1 of '|'(H T) then %Pattern Matching
        Result=H|{Append T List2} %Variable-to-variable unification
      else
        skip %Empty statement
      end
    end
  end

%4D
  proc {Max X Y Result}
    local T in %Variable creation
      T = 0 %Value Creation
      if X == T then %COnditional (1)
        Y=Result %Variable-to-variable binding
      else %Conditional (2)
        if Y == T then %Conditional (1)
          X=Result %Variable-to-variable binding
        else %Conditional (2)
          Result = 1+{Max X-1 Y-1}
        end
      end
    end
  end

%8A
local IL = 1|IL in
  {System.show IL}
end

%{System.show {Append [1 2 3] [4 5 6 7]}}
{System.show {Max 10 5}}

{Exit 0}
end
