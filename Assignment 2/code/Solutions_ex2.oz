functor
import
	Application(exit:Exit)
	System
	OS
define
	% 1) See solutions for exercise 1
	\insert List.oz

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% 2a) Note that '& ' is a single space character. '&' is used to denote characters in oz
	fun {Lex Input}
		{String.tokens Input & }
	end

	% 2b) 2d) 2e) 2f) 2g)
	fun {Tokenize Lexemes}
		case Lexemes of Head|Tail then
			case Head of "+" then
				operator(type: plus)
			[] "-" then
				operator(type: minus)
			[] "*" then
				operator(type: multiply)
			[] "/" then
				operator(type: divide)
			[] "i" then
				operator(type: negate)
			[] "^" then
				operator(type: inverse)
			[] "p" then
				command(print)
			[] "d" then
				command(duplicate)
			else

				% R and I are just local variable names which are assigned from the string-float or
				% string-int conversions

				local R I in
					{String.isFloat Head R}
					if R then
						{String.toFloat Head I}
						number(I)
					else
						local R I in
							{String.isInt Head R}
							if R then
								{String.toInt Head I}
								number(I)
							end
						end
					end
				end
			end|{Tokenize Tail}  % Note how the 'x ... end' in oz is an expression, so we are allowed to treat it just like any other expression
		else
			nil
		end
	end

	% 2c)
	% This is a utility function for this task
	fun {Reverse Elements}
		case Elements of Head|Tail then
			{Append {Reverse Tail} Head|nil}
		else
			nil
		end
	end

	% The main interpreter
	fun {InterpretStack Tokens Stack}
		case Tokens of Head|Tail then
			local NewStack in

				% Note the order here, left and right are pushed to the stack in an inverted manner

				case Head of operator(type: plus) then
					case Stack of number(Right)|number(Left)|Tail then
						NewStack = number(Right + Left)|Tail
					end
				[] operator(type: minus) then
					case Stack of number(Right)|number(Left)|Tail then
						NewStack = number(Left - Right)|Tail
					end
				[] operator(type: multiply) then
					case Stack of number(Right)|number(Left)|Tail then
						NewStack = number(Left * Right)|Tail
					end
				[] operator(type: divide) then
					case Stack of number(Right)|number(Left)|Tail then
						NewStack = number(Left / Right)|Tail
					end
				[] operator(type: negate) then
					case Stack of number(First)|Tail then
						NewStack = number(~First)|Tail
					end
				[] operator(type: inverse) then
					case Stack of number(First)|Tail then
						NewStack = number(1.0/First)|Tail
					end
				[] command(print) then
					{System.show {Reverse Stack}}
					NewStack = Stack
				[] command(duplicate) then
					case Stack of Head|Tail then
						NewStack = Head|Head|Tail
					else
						NewStack = Stack
					end
				else
					NewStack = Head|Stack
				end
				{InterpretStack Tail NewStack}
			end
		else
			Stack
		end
	end

	% We use this short function to avoid writing 'nil' whenever we call Interpret ourselves
	fun {Interpret Tokens}
		{Reverse {InterpretStack Tokens nil}}
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% 3b)
	fun {OpLeq Pushing Top}
		case Pushing of operator(type: minus) then
			true
		[] operator(type: plus) then
			true
		else
			case Top of operator(type: multiply) then
				true
			[] operator(type: divide) then
				true
			else
				false
			end
		end
	end

	% 3c)
	fun {ShuntInternal Tokens OpStack OutStack}

		% 3d)
		case OpStack of Pushed|Top|Tail then
			if {OpLeq Pushed Top} then
				{ShuntInternal Tokens Pushed|Tail Top|OutStack}
			else

				local NewOutStack NewOpStack NewTail in
					case Tokens of Head|Tail then

						case Head of number(N) then
							NewOpStack = OpStack
							NewOutStack = Head|OutStack

						[] operator(type: Op) then
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

					case Head of number(N) then
						NewOpStack = OpStack
						NewOutStack = Head|OutStack

					[] operator(type: Op) then
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

	% 3a)
	fun {Shunt Tokens}
		{ShuntInternal Tokens nil nil}
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% 4a)
	% The lexemes are described by the following /regular expressions/, which we use to describe /regular grammars/:
	% You can also draw DFAs/NFAs, but those aren't covered here
	%
	% number: "[0-9]+(\.[0-9]+)?"  or simpler  "digit+((.digit+)|eps)"
	% plus: "\+"
	% minus: "-"
	% multiply: "\*"
	% divide: "/"
	% print: "p"
	% duplicate: "d"
	% inverse: "i"

	% You could also have answered using a grammar G = (N, E, P, S) or a similar form, then you would also need to describe each lexeme individually:

	/* G_{integer} = ({S,A}, {1,2,3,4,5,6,7,8,9,0}, {
		S -> 1A,
		S -> 2A,
		S -> 3A,
		S -> 4A,
		S -> 5A,
		S -> 6A,
		S -> 7A,
		S -> 8A,
		S -> 9A,
		S -> 0A,

		A -> 1A,
		A -> 2A,
		A -> 3A,
		A -> 4A,
		A -> 5A,
		A -> 6A,
		A -> 7A,
		A -> 8A,
		A -> 9A,
		A -> 0A,
		A -> epsilon,
	},
	S)
	*/

	/* G_{operator} = ({S}, {+,-,*,/,p,d,i}, {
		S -> +,
		S -> -,
		S -> *,
		S -> /,
		S -> p,
		S -> d,
		S -> i,
	},
	S)
	*/

	% Remember that we do not describe the relation between tokens, but the /lexemes/ themselves.


	% 4b)

	% Correct answer:
	%
	% Expr ::= Expr + Prod
	%        | Expr - Prod
	%        | Prod;
	% Prod ::= Prod * number
	%        | Prod / number
	%        | number;  % Number that was defined as a lexeme
	%
	% This grammar is unambiguous because all parse trees are left-recursive as (((1*2)*3)*4).
	% The grammar parses 1-2-3 into ((1-2)-3), which is semantically correct.


	% Partially correct answer (Accepted):
	%
	% Expr ::= Expr + Expr
	%        | Expr - Expr
	%        | Prod;
	% Prod ::= Prod * Prod
	%        | Prod / Prod
	%        | number;  % Number that was defined as a lexeme
	%
	% This grammar is ambiguous because the parse trees for - say - 1*2*3 can be (1*2)*3 or 1*(2*3).
	% This is wrong because it doesn't capture the precise semantics: 1-2-3 can be (1-(2-3)), which is wrong.


	% Partially correct answer (Accepted):
	% Note that you can also create an unambiguous grammar like so: (Wrong answer)
	%
	% Expr ::= Prod + Expr
	%        | Prod - Expr
	%        | Prod;
	% Prod ::= number * Prod
	%        | number / Prod
	%        | number;  % Number that was defined as a lexeme
	%
	% This grammar is unambiguous because all parse trees are right-recursive as 1*(2*(3*4)).
	% However, the semantics of this grammar are wrong because '-' and '/' are strictly left-associative.
	% This is wrong because it doesn't capture the precise semantics: 1-2-3 is parsed into (1-(2-3)), which is wrong.

	% 4c)
	% A context-sensitive grammar has a non-terminal surrounded by terminals and/or non-terminals on
	% both the left-hand side and the right-hand side. Example: All rules are of the pattern: aAb -> aBb
	% A context-free grammar does not have this.

	% 4d)
	% This happens because Oz is /strongly typed/. This is useful for catching bugs and subtle
	% /type casts/ that may cause unexpected behaviour.

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Sanity tests
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	{System.show {Lex "1 2 + 3 *"}}
	{System.show {Tokenize {Lex "13 2 + 4 * -39"}}}
	{System.show {Interpret [number(10.0) number(5.0) operator(type:minus) number(3.4) operator(type:divide)]}}
	{System.show {Interpret {Tokenize {Lex "12.0 12.0 2.0 - 3.4 /"}}}}
	{System.show {Interpret {Tokenize {Lex "1 2 3 +"}}}}
	{System.show {Interpret {Tokenize {Lex "1.0 2.0 3.0 p +"}}}}
	{System.show {Interpret {Tokenize {Lex "1.4 2.2 3.1 + d 9.4 *"}}}}
	{System.show {Interpret {Tokenize {Lex "4.0 6.0 * i"}}}}
	{System.show {Interpret {Tokenize {Lex "2.0 2.0 + ^"}}}}
	{System.show {Shunt [number(3.0) operator(type: plus) number(10.0) operator(type: minus) number(9.0)]}}
	{System.show {Shunt [number(3.0) operator(type: minus) number(10.0) operator(type: multiply) number(9.0)]}}
	{System.show {Shunt [number(3.0) operator(type: minus) number(10.0) operator(type: multiply) number(9.0) operator(type: plus) number(0.3)]}}
	{System.show {Interpret {Shunt {Tokenize {Lex "3.0 - 10.0 * 9.0 + 0.3"}}}}}
	{System.show [number(5+1*3*2+4*2-1-2*2)]}
	{System.show {Interpret {Shunt {Tokenize {Lex "5 + 1 * 3 * 2 + 4 * 2 - 1 - 2 * 2"}}}}}
	{System.show {Interpret {Tokenize {Lex "1 2 8 * d d d"}}}}
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Appendix sanity tests
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	local X = myRecord(10) in
		case X of myRecord(N) then
			{System.showInfo N}
		end
	end

	local X = myRecord(value:10 2:nested("record")) in
		case X of myRecord(N) then
			{System.showInfo N}
		[] myRecord(value:N 2:S) then
			{System.showInfo N}
			{System.show S}
		end
	end

	local X = myRecord(value:10 2:nested("record")) in
		case X of myRecord(N) then
			{System.showInfo N}
		[] myRecord(value:N 2:nested(Something)) then
			{System.showInfo N}
			{System.showInfo Something}
		end
	end

	local X = myRecord(value:10 2:nested("record")) in
		case X of myRecord(N) then
			{System.showInfo "First Case"}
			{System.showInfo N}
		[] myRecord(value:N 2:nested("record")) then
			{System.showInfo "Second Case"}
			{System.showInfo N}
		end
	end

	local X = myRecord(value:10 2:nested("record")) in
		case X of myRecord(N) then
			{System.showInfo "First Case"}
			{System.showInfo N}
		[] myRecord(value:N 2:nested("Something different")) then
			{System.showInfo "Second Case"}
			{System.showInfo N}
		else
			{System.showInfo "Nothing matched"}
		end
	end
	local N = 30 X = recorded(10) in
		case X of recorded(N) then
			{System.showInfo N}
		end
	end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	{Exit 0}
end
