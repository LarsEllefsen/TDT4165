functor
import
   System
   Application
   Open
   Module
define
   \insert 'mdc-lexemize.oz'
   \insert 'mdc-tokenize.oz'
   \insert 'mdc-interpret.oz'
   Browse = System.showInfo
   Args
   try
      Input =
      {Application.getArgs
       list(mode:anywhere
	    file(char:&f type:string)
	    expression(char:&e type:string)
	    help(char:[&h &?] type:bool))} in
      if Input == nil then Args = [file#stdin]
      else Args = Input end
   catch Exception then
      {Browse "mdc: "#Exception.1.2}
      {Application.exit 0}
   end
   fun {ReadFile FileName}
      try {{New Open.file init(name:FileName)}
	   read(list:$ size:all)}
      catch _ then
	 {Browse "mdc: cannot open file "#FileName}
      end
   end
   {ForAll Args
    proc {$ Arg}
       Input in
       case Arg
       of file#FileName then
	  Input = {ReadFile FileName}
       [] expression#Expression then
	  Input = Expression
       [] help#_ then
	  {Browse "mdc: sorry, no help so far"}
	  {Application.exit 0}
       else Input = {ReadFile Arg}
       end
       try
	  {Interpret {Tokenize {Lexemize Input}}}
       catch Exception then
	  {Browse "mdc: "#Exception}
       end
    end}
   {Application.exit 0}
end