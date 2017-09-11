fun {Lexemize Input}
   [String] = {Module.link ['x-oz://system/String.ozf']}
in
   {String.split
    {String.strip Input unit}
    unit}
end