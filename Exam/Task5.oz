functor
import
  Application(exit:Exit)
  System
define

fun {Evaluate E}
  case E of int(I) then I
    [] plus(A B) then {Evaluate A}+{Evaluate B}
    [] minus(A B) then {Evaluate A}-{Evaluate B}
    [] times(A B) then {Evaluate A}*{Evaluate B}
    [] divide(A B) then {Evaluate A}div{Evaluate B}
    else 0
  end
end

fun {DivByZeroCheck Record}
  case Record of int(i) then i
  [] divide(X Y) then
    if {Evaluate Y} == 0 then
      true
    else
      false
    end
  else
    {System.show Record.2}
    {DivByZeroCheck Record.2}
  end
end

{System.show {DivByZeroCheck plus(minus(int(1) int(2)) times(int(3) divide(int(4) int(5))))}}

{Exit 0}
end
