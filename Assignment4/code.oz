functor
import
  Application(exit:Exit)
  System
define

%------------------%
%------TASK 1------%
%------------------%
fun lazy {StreamMap S F}
  case S of H|T then
    {F H}|{StreamMap T F}
  end
end

local A = 2|3|4|A X in
  X = {StreamMap A fun {$ X} X*X end}
  if {Nth X 10} > 0 then skip end
  {System.show X}
end

%------------------%
%------TASK 2------%
%------------------%

fun lazy {StreamZip S1 S2 F}
  case S1 of H|T then
    {F H S2.1}|{StreamZip T S2.2 F}
  end
end

local A = 2|3|4|A B = 9|~3|B X in
X = {StreamZip A B fun {$ X Y} X*Y end}
if {Nth X 10} > 0 then skip end
{System.show X}
end

%------------------%
%------TASK 3------%
%------------------%
fun lazy {StreamScale S Factor}
  {StreamMap S fun {$ X} X*Factor end}
end

local A = 2|3|4|A X in
  X = {StreamScale A 5}
  if {Nth X 10} > 0 then skip end
  {System.show X}
end

%------------------%
%------TASK 4------%
%------------------%
fun lazy {StreamAdd S1 S2}
  {StreamZip S1 S2 fun {$ X Y} X+Y end}
end

local A = 2|3|4|A B = 9|~3|B X in
  X = {StreamAdd A B}
  if {Nth X 10} > 0 then skip end
  {System.show X}
end

%------------------%
%------TASK 5------%
%------------------%
fun lazy {StreamIntegrate Init S Dt}
  case S of H|T then
    Init|{StreamIntegrate Init+H*Dt T Dt}
  [] nil then
    0.0
  end
end

local A = 1.0|0.0|A X in
  X = {StreamIntegrate 5.0 A 1.0}
  if {Nth X 10} > 0.0 then skip end
  {System.show X}
end

%------------------%
%------TASK 6------%
%------------------%
fun {MakeRC R C Dt} %Great Again
  fun lazy {$ S V0}
    {StreamAdd {StreamScale S R} {StreamIntegrate V0 {StreamScale S 1.0/C} Dt}}
  end
end

local
  Ones = 1.0|Ones
  RC = {MakeRC 5.0 1.0 0.2}
  V = {RC Ones 2.0}
in
  if {Nth V 5} > 0.0 then skip end {System.show V}
end


{Exit 0}
end
