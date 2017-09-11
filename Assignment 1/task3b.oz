functor
import
	Application(exit:Exit)
	System
define
	X = "This is a string"
	thread {System.showInfo Y} end
  Y = X
	{Exit 0}
end
