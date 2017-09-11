declare
proc {Circle R}
   local
      A = 3.14 * R * R
      D = 2.0 * R
      C = 3.14 * D
   in
      {Browse A}
      {Browse D}
      {Browse C}
   end
end

{Circle 5.0}