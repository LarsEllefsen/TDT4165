%a
declare
fun {Length List}
   case List of H | T then
      1 + {Length T}
   else
      0
   end
end

%{Browse {Length [1 2 3 4]}}


%b
fun{Take List Count}
   if Count > {Length List} then
      List
   else
      case List of H | T then
	 if Count == 1 then
	    H | nil
	 else
	    H | {Take T Count-1}
	 end
      end
   end
end

{Browse {Take [10 11 12 13 14 150] 5}}

%c

fun {Drop List Count}
   if Count > {Length List} then
      nil
   else
      case List of H | T then
	 if Count == 1 then
	    T
	 else
	    {Drop T Count-1}
	 end
      end
   end
end

%{Browse {Drop [1 2 3 4 5] 1}}

%d
fun {Append List1 List2}
   if List1 == nil then
      List2
   else
      List1.1|{Append List1.2 List2}
   end
end

%{Browse {Append [1 2 3] [74 5 6]}}

%e
fun {Member List Element}
   case List of H|T then
      if H == Element then
	 true
      else
	 {Member T Element}
      end
   else
      false
   end
end

%{Browse {Member [a b c d e gf] d}}

%f
fun {Position List Element}
   case List of H|T then
      if H == Element then
	 1
      else
	 1+{Position T Element}
      end
   end
end

{Browse {Position [1 2 3 4 5 6] 5}}



