local unicode_printability_boundaries = require "luacheck.unicode_printability_boundaries"

local unicode = {}

-- unicode_printability_boundaries is an array of first codepoints of
-- each continuous block of codepoints that are all printable or all not printable.

function unicode.is_printable(codepoint)
   -- Binary search for index of the first boundary less than or equal to given codepoint.
   local floor_boundary_index

   -- Target index is always in [begin_index..end_index).
   local begin_index = 1
   local end_index = #unicode_printability_boundaries + 1

   while end_index - begin_index > 1 do
      local mid_index = math.floor((begin_index + end_index) / 2)
      local mid_codepoint = unicode_printability_boundaries[mid_index]

      if codepoint < mid_codepoint then
         end_index = mid_index
      elseif codepoint > mid_codepoint then
         begin_index = mid_index
      else
         floor_boundary_index = mid_index
         break
      end
   end

   floor_boundary_index = floor_boundary_index or begin_index
   -- floor_boundary_index is the number of the block containing codepoint.
   -- Printable and not printable blocks alternate and the first one is not printable (zero is not printable).
   return floor_boundary_index % 2 == 0
end

return unicode
