local stage = {}

stage.warnings = {
   ["611"] = {message_format = "line contains only whitespace", fields = {}},
   ["612"] = {message_format = "line contains trailing whitespace", fields = {}},
   ["613"] = {message_format = "trailing whitespace in a string", fields = {}},
   ["614"] = {message_format = "trailing whitespace in a comment", fields = {}},
   ["621"] = {message_format = "inconsistent indentation (SPACE followed by TAB)", fields = {}}
}

function stage.run(chstate)
   local num_lines = #chstate.line_offsets

   for line_number = 1, num_lines do
      local line_offset = chstate.line_offsets[line_number]
      local line_length = chstate.line_lengths[line_number]

      if line_length > 0 then
         local trailing_ws_pattern

         if line_number == num_lines then
            trailing_ws_pattern = "^[^\r\n]-()[ \t\f\v]+()[\r\n]?$"
         else
            trailing_ws_pattern = "^[^\r\n]-()[ \t\f\v]+()[\r\n]"
         end

         local line_start_byte, _, trailing_ws_start_byte, line_end_byte = chstate.source:find(
            trailing_ws_pattern, line_offset)

         local trailing_ws_code

         if trailing_ws_start_byte then

            if trailing_ws_start_byte == line_start_byte then
               -- Line contains only whitespace (thus never considered "code").
               trailing_ws_code = "611"
            elseif not chstate.line_endings[line_number] then
               -- Trailing whitespace on code line or after long comment.
               trailing_ws_code = "612"
            elseif chstate.line_endings[line_number] == "string" then
               -- Trailing whitespace embedded in a string literal.
               trailing_ws_code = "613"
            elseif chstate.line_endings[line_number] == "comment" then
            -- Trailing whitespace at the end of a line comment or inside long comment.
               trailing_ws_code = "614"
            end

            -- The difference between the start and the end of the warning range
            -- is the same in bytes and in characters because whitespace characters are ASCII.
            -- Can calculate one based on the three others.
            local trailing_ws_end_byte = line_end_byte - 1
            local trailing_ws_end_char = line_offset + line_length - 1
            local trailing_ws_start_char = trailing_ws_end_char - (trailing_ws_end_byte - trailing_ws_start_byte)

            chstate:warn(trailing_ws_code, line_number, trailing_ws_start_char, trailing_ws_end_char)
         end

         -- Don't look for inconsistent whitespace in pure whitespace lines.
         if trailing_ws_code ~= "611" then
            local leading_ws_start_byte, leading_ws_end_byte = chstate.source:find(
               "^[ \t\f\v]- \t[ \t\f\v]*", line_offset)

            if leading_ws_start_byte then
               -- Inconsistent leading whitespace (SPACE followed by TAB).

               -- Calculate warning end in characters using same logic as above.
               local leading_ws_start_char = line_offset
               local leading_ws_end_char = leading_ws_start_char + (leading_ws_end_byte - leading_ws_start_byte)
               chstate:warn("621", line_number, line_offset, leading_ws_end_char)
            end
         end
      end
   end
end

return stage
