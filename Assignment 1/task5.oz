functor
import
	Application(exit:Exit)
	System
define
proc{Circle R}
	local
		A = 3.14 * R * R
		D = 2.0 * R
		C = 3.14 * D
	in
		{System.showInfo A}
		{System.showInfo D}
		{System.showInfo C}
    end
  end
    {Circle 5.0}
    {Exit 0}
end
