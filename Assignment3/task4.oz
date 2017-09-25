functor
import
  Application(exit:Exit)
  System
define

%A
  local A = 1 B = 3 C = ~9 D = 39 in
    {System.showInfo A+B+C+D}
  end

%B
  local A=10 in
    if A==1 then
      {System.showInfo "A is equal to 1"}
    elseif A<0 then
      {System.showInfo "A is zero!"}
    elseif A==10 then
      {System.showInfo "A is 10"}
    else
      {System.showInfo "I dont know what A is"}
    end
  end



{Exit 0}
end
