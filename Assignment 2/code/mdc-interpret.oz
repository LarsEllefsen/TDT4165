proc {Interpret Tokens}
   Commands = cmd(p:proc {$ Top|_} {Browse Top} end 
		  f:proc {$ Stack} {ForAll Stack Browse} end)
   Operations = op('+':Number.'+'
		   '-':Number.'-'
		   '*':Number.'*'
		   '/':Int.'div')
   proc {Iterate Stack Tokens}
      case Tokens
      of nil then
	 skip
      [] int(Integer)|Tokens then
	 {Iterate Integer|Stack Tokens}
      [] cmd(Command)|Tokens then
	 {Commands.Command Stack}
	 {Iterate Stack Tokens}
      [] op(Operator)|Tokens then
	 Top|NextToTop|Rest = Stack in
	 {Iterate {Operations.Operator NextToTop Top}|Rest Tokens}
      end
   end
in
   try
      {Iterate nil Tokens}
   catch _ then
      raise "stack empty" end
   end
end