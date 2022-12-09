local utils = require "luacheck.utils"

-- Lexer should support syntax of Lua 5.1, Lua 5.2, Lua 5.3 and LuaJIT(64bit and complex cdata literals).
local lexer = {}

local sbyte = string.byte
local schar = string.char
local sreverse = string.reverse
local tconcat = table.concat
local mfloor = math.floor

-- No point in inlining these, fetching a constant ~= fetching a local.
local BYTE_0, BYTE_9, BYTE_f, BYTE_F = sbyte("0"), sbyte("9"), sbyte("f"), sbyte("F")
local BYTE_x, BYTE_X, BYTE_i, BYTE_I = sbyte("x"), sbyte("X"), sbyte("i"), sbyte("I")
local BYTE_l, BYTE_L, BYTE_u, BYTE_U = sbyte("l"), sbyte("L"), sbyte("u"), sbyte("U")
local BYTE_e, BYTE_E, BYTE_p, BYTE_P = sbyte("e"), sbyte("E"), sbyte("p"), sbyte("P")
local BYTE_a, BYTE_z, BYTE_A, BYTE_Z = sbyte("a"), sbyte("z"), sbyte("A"), sbyte("Z")
local BYTE_DOT, BYTE_COLON = sbyte("."), sbyte(":")
local BYTE_OBRACK, BYTE_CBRACK = sbyte("["), sbyte("]")
local BYTE_OBRACE, BYTE_CBRACE = sbyte("{"), sbyte("}")
local BYTE_QUOTE, BYTE_DQUOTE = sbyte("'"), sbyte('"')
local BYTE_PLUS, BYTE_DASH, BYTE_LDASH = sbyte("+"), sbyte("-"), sbyte("_")
local BYTE_SLASH, BYTE_BSLASH = sbyte("/"), sbyte("\\")
local BYTE_EQ, BYTE_NE = sbyte("="), sbyte("~")
local BYTE_LT, BYTE_GT = sbyte("<"), sbyte(">")
local BYTE_LF, BYTE_CR = sbyte("\n"), sbyte("\r")
local BYTE_SPACE, BYTE_FF, BYTE_TAB, BYTE_VTAB = sbyte(" "), sbyte("\f"), sbyte("\t"), sbyte("\v")

local function to_hex(b)
   if BYTE_0 <= b and b <= BYTE_9 then
      return b-BYTE_0
   elseif BYTE_a <= b and b <= BYTE_f then
      return 10+b-BYTE_a
   elseif BYTE_A <= b and b <= BYTE_F then
      return 10+b-BYTE_A
   else
      return nil
   end
end

local function to_dec(b)
   if BYTE_0 <= b and b <= BYTE_9 then
      return b-BYTE_0
   else
      return nil
   end
end

local function to_utf(codepoint)
   if codepoint < 0x80 then  -- ASCII?
      return schar(codepoint)
   end

   local buf = {}
   local mfb = 0x3F

   repeat
      buf[#buf+1] = schar(codepoint % 0x40 + 0x80)
      codepoint = mfloor(codepoint / 0x40)
      mfb = mfloor(mfb / 2)
   until codepoint <= mfb

   buf[#buf+1] = schar(0xFE - mfb*2 + codepoint)
   return sreverse(tconcat(buf))
end

local function is_alpha(b)
   return (BYTE_a <= b and b <= BYTE_z) or
      (BYTE_A <= b and b <= BYTE_Z) or b == BYTE_LDASH
end

local function is_newline(b)
   return (b == BYTE_LF) or (b == BYTE_CR)
end

local function is_space(b)
   return (b == BYTE_SPACE) or (b == BYTE_FF) or
      (b == BYTE_TAB) or (b == BYTE_VTAB)
end

local keywords = utils.array_to_set({
   "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in",
   "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"})

local simple_escapes = {
   [sbyte("a")] = sbyte("\a"),
   [sbyte("b")] = sbyte("\b"),
   [sbyte("f")] = sbyte("\f"),
   [sbyte("n")] = sbyte("\n"),
   [sbyte("r")] = sbyte("\r"),
   [sbyte("t")] = sbyte("\t"),
   [sbyte("v")] = sbyte("\v"),
   [BYTE_BSLASH] = BYTE_BSLASH,
   [BYTE_QUOTE] = BYTE_QUOTE,
   [BYTE_DQUOTE] = BYTE_DQUOTE
}

local function next_byte(state)
   local offset = state.offset + 1
   state.offset = offset
   return state.src:get_codepoint(offset)
end

-- Skipping helpers.
-- Take the current character, skip something, return next character.

local function skip_newline(state, newline)
   local first_newline_offset = state.offset
   local b = next_byte(state)

   if b ~= newline and is_newline(b) then
      b = next_byte(state)
   end

   local line = state.line
   local line_offsets = state.line_offsets
   state.line_lengths[line] = first_newline_offset - line_offsets[line]
   line = line + 1
   state.line = line
   line_offsets[line] = state.offset
   return b
end

local function skip_to_newline(state, b)
   while not is_newline(b) and b do
      b = next_byte(state)
   end

   return b
end

local function skip_space(state, b)
   while is_space(b) or is_newline(b) do
      if is_newline(b) then
         b = skip_newline(state, b)
      else
         b = next_byte(state)
      end
   end

   return b
end

-- Skips "[=*" or "]=*". Returns next character and number of "="s.
local function skip_long_bracket(state)
   local start = state.offset
   local b = next_byte(state)

   while b == BYTE_EQ do
      b = next_byte(state)
   end

   return b, state.offset-start-1
end

-- Token handlers.

-- Called after the opening "[=*" has been skipped.
-- Takes number of "=" in the opening bracket and token type(comment or string).
local function lex_long_string(state, opening_long_bracket, token)
   local b = next_byte(state)

   if is_newline(b) then
      b = skip_newline(state, b)
   end

   local lines = {}
   local line_start = state.offset

   while true do
      if is_newline(b) then
         -- Add the finished line.
         lines[#lines+1] = state.src:get_substring(line_start, state.offset-1)

         b = skip_newline(state, b)
         line_start = state.offset
      elseif b == BYTE_CBRACK then
         local long_bracket
         b, long_bracket = skip_long_bracket(state)

         if b == BYTE_CBRACK and long_bracket == opening_long_bracket then
            break
         end
      elseif b == nil then
         return nil, token == "string" and "unfinished long string" or "unfinished long comment"
      else
         b = next_byte(state)
      end
   end

   -- Add last line.
   lines[#lines+1] = state.src:get_substring(line_start, state.offset-opening_long_bracket-2)
   state.offset = state.offset + 1
   return token, tconcat(lines, "\n")
end

local function lex_short_string(state, quote)
   local b = next_byte(state)
   local chunks  -- Buffer is only required when there are escape sequences.
   local chunk_start = state.offset

   while b ~= quote do
      if b == BYTE_BSLASH then
         -- Escape sequence.

         if not chunks then
            -- This is the first escape sequence, init buffer.
            chunks = {}
         end

         -- Put previous chunk into buffer.
         if chunk_start ~= state.offset then
            chunks[#chunks+1] = state.src:get_substring(chunk_start, state.offset-1)
         end

         b = next_byte(state)

         -- The final string escape sequence evaluates to.
         local s

         local escape_byte = simple_escapes[b]

         if escape_byte then  -- Is it a simple escape sequence?
            b = next_byte(state)
            s = schar(escape_byte)
         elseif is_newline(b) then
            b = skip_newline(state, b)
            s = "\n"
         elseif b == BYTE_x then
            -- Hexadecimal escape.
            b = next_byte(state)  -- Skip "x".
            -- Exactly two hexadecimal digits.
            local c1, c2

            if b then
               c1 = to_hex(b)
            end

            if not c1 then
               return nil, "invalid hexadecimal escape sequence", -2
            end

            b = next_byte(state)

            if b then
               c2 = to_hex(b)
            end

            if not c2 then
               return nil, "invalid hexadecimal escape sequence", -3
            end

            b = next_byte(state)
            s = schar(c1*16 + c2)
         elseif b == BYTE_u then
            b = next_byte(state)  -- Skip "u".

            if b ~= BYTE_OBRACE then
               return nil, "invalid UTF-8 escape sequence", -2
            end

            b = next_byte(state)  -- Skip "{".

            local codepoint  -- There should be at least one digit.

            if b then
               codepoint = to_hex(b)
            end

            if not codepoint then
               return nil, "invalid UTF-8 escape sequence", -3
            end

            local hexdigits = 0

            while true do
               b = next_byte(state)
               local hex

               if b then
                  hex = to_hex(b)
               end

               if hex then
                  hexdigits = hexdigits + 1
                  codepoint = codepoint*16 + hex

                  if codepoint > 0x10FFFF then
                     -- UTF-8 value too large.
                     return nil, "invalid UTF-8 escape sequence", -hexdigits-3
                  end
               else
                  break
               end
            end

            if b ~= BYTE_CBRACE then
               return nil, "invalid UTF-8 escape sequence", -hexdigits-4
            end

            b = next_byte(state)  -- Skip "}".
            s = to_utf(codepoint)
         elseif b == BYTE_z then
            -- Zap following span of spaces.
            b = skip_space(state, next_byte(state))
         else
            -- Must be a decimal escape.
            local cb

            if b then
               cb = to_dec(b)
            end

            if not cb then
               return nil, "invalid escape sequence", -1
            end

            -- Up to three decimal digits.
            b = next_byte(state)

            if b then
               local c2 = to_dec(b)

               if c2 then
                  cb = 10*cb + c2
                  b = next_byte(state)

                  if b then
                     local c3 = to_dec(b)

                     if c3 then
                        cb = 10*cb + c3

                        if cb > 255 then
                           return nil, "invalid decimal escape sequence", -3
                        end

                        b = next_byte(state)
                     end
                  end
               end
            end

            s = schar(cb)
         end

         if s then
            chunks[#chunks+1] = s
         end

         -- Next chunk starts after escape sequence.
         chunk_start = state.offset
      elseif b == nil or is_newline(b) then
         return nil, "unfinished string"
      else
         b = next_byte(state)
      end
   end

   -- Offset now points at the closing quote.
   local string_value

   if chunks then
      -- Put last chunk into buffer.
      if chunk_start ~= state.offset then
         chunks[#chunks+1] = state.src:get_substring(chunk_start, state.offset-1)
      end

      string_value = tconcat(chunks)
   else
      -- There were no escape sequences.
      string_value = state.src:get_substring(chunk_start, state.offset-1)
   end

   -- Skip the closing quote.
   state.offset = state.offset + 1
   return "string", string_value
end

-- Payload for a number is simply a substring.
-- Luacheck is supposed to be forward-compatible with Lua 5.3 and LuaJIT syntax, so
--    parsing it into actual number may be problematic.
-- It is not needed currently anyway as Luacheck does not do static evaluation yet.
local function lex_number(state, b)
   local start = state.offset

   local exp_lower, exp_upper = BYTE_e, BYTE_E
   local is_digit = to_dec
   local has_digits = false
   local is_float = false

   if b == BYTE_0 then
      b = next_byte(state)

      if b == BYTE_x or b == BYTE_X then
         exp_lower, exp_upper = BYTE_p, BYTE_P
         is_digit = to_hex
         b = next_byte(state)
      else
         has_digits = true
      end
   end

   while b ~= nil and is_digit(b) do
      b = next_byte(state)
      has_digits = true
   end

   if b == BYTE_DOT then
      -- Fractional part.
      is_float = true
      b = next_byte(state)  -- Skip dot.

      while b ~= nil and is_digit(b) do
         b = next_byte(state)
         has_digits = true
      end
   end

   if b == exp_lower or b == exp_upper then
      -- Exponent part.
      is_float = true
      b = next_byte(state)

      -- Skip optional sign.
      if b == BYTE_PLUS or b == BYTE_DASH then
         b = next_byte(state)
      end

      -- Exponent consists of one or more decimal digits.
      if b == nil or not to_dec(b) then
         return nil, "malformed number"
      end

      repeat
         b = next_byte(state)
      until b == nil or not to_dec(b)
   end

   if not has_digits then
      return nil, "malformed number"
   end

   -- Is it cdata literal?
   if b == BYTE_i or b == BYTE_I then
      -- It is complex literal. Skip "i" or "I".
      state.offset = state.offset + 1
   else
      -- uint64_t and int64_t literals can not be fractional.
      if not is_float then
         if b == BYTE_u or b == BYTE_U then
            -- It may be uint64_t literal.
            local b1 = state.src:get_codepoint(state.offset+1)

            if b1 == BYTE_l or b1 == BYTE_L then
               local b2 = state.src:get_codepoint(state.offset+2)

               if b2 == BYTE_l or b2 == BYTE_L then
                  -- It is uint64_t literal.
                  state.offset = state.offset + 3
               end
            end
         elseif b == BYTE_l or b == BYTE_L then
            -- It may be uint64_t or int64_t literal.
            local b1 = state.src:get_codepoint(state.offset+1)

            if b1 == BYTE_l or b1 == BYTE_L then
               local b2 = state.src:get_codepoint(state.offset+2)

               if b2 == BYTE_u or b2 == BYTE_U then
                  -- It is uint64_t literal.
                  state.offset = state.offset + 3
               else
                  -- It is int64_t literal.
                  state.offset = state.offset + 2
               end
            end
         end
      end
   end

   return "number", state.src:get_substring(start, state.offset-1)
end

local function lex_ident(state)
   local start = state.offset
   local b = next_byte(state)

   while (b ~= nil) and (is_alpha(b) or to_dec(b)) do
      b = next_byte(state)
   end

   local ident = state.src:get_substring(start, state.offset-1)

   if keywords[ident] then
      return ident
   else
      return "name", ident
   end
end

local function lex_dash(state)
   local b = next_byte(state)

   -- Is it "-" or comment?
   if b ~= BYTE_DASH then
      return "-"
   end

   -- It is a comment.
   b = next_byte(state)
   local start = state.offset

   -- Is it a long comment?
   if b == BYTE_OBRACK then
      local long_bracket
      b, long_bracket = skip_long_bracket(state)

      if b == BYTE_OBRACK then
         return lex_long_string(state, long_bracket, "long_comment")
      end
   end

   -- Short comment.
   skip_to_newline(state, b)
   local comment_value = state.src:get_substring(start, state.offset - 1)
   return "short_comment", comment_value
end

local function lex_bracket(state)
   -- Is it "[" or long string?
   local b, long_bracket = skip_long_bracket(state)

   if b == BYTE_OBRACK then
      return lex_long_string(state, long_bracket, "string")
   elseif long_bracket == 0 then
      return "["
   else
      return nil, "invalid long string delimiter"
   end
end

local function lex_eq(state)
   local b = next_byte(state)

   if b == BYTE_EQ then
      state.offset = state.offset + 1
      return "=="
   else
      return "="
   end
end

local function lex_lt(state)
   local b = next_byte(state)

   if b == BYTE_EQ then
      state.offset = state.offset + 1
      return "<="
   elseif b == BYTE_LT then
      state.offset = state.offset + 1
      return "<<"
   else
      return "<"
   end
end

local function lex_gt(state)
   local b = next_byte(state)

   if b == BYTE_EQ then
      state.offset = state.offset + 1
      return ">="
   elseif b == BYTE_GT then
      state.offset = state.offset + 1
      return ">>"
   else
      return ">"
   end
end

local function lex_div(state)
   local b = next_byte(state)

   if b == BYTE_SLASH then
      state.offset = state.offset + 1
      return "//"
   else
      return "/"
   end
end

local function lex_ne(state)
   local b = next_byte(state)

   if b == BYTE_EQ then
      state.offset = state.offset + 1
      return "~="
   else
      return "~"
   end
end

local function lex_colon(state)
   local b = next_byte(state)

   if b == BYTE_COLON then
      state.offset = state.offset + 1
      return "::"
   else
      return ":"
   end
end

local function lex_dot(state)
   local b = next_byte(state)

   if b == BYTE_DOT then
      b = next_byte(state)

      if b == BYTE_DOT then
         state.offset = state.offset + 1
         return "...", "..."
      else
         return ".."
      end
   elseif b and to_dec(b) then
      -- Backtrack to dot.
      state.offset = state.offset - 2
      return lex_number(state, next_byte(state))
   else
      return "."
   end
end

local function lex_any(state, b)
   state.offset = state.offset + 1

   if b > 255 then
      b = 255
   end

   return schar(b)
end

-- Maps first bytes of tokens to functions that handle them.
-- Each handler takes the first byte as an argument.
-- Each handler stops at the character after the token and returns the token and,
--    optionally, a value associated with the token.
-- On error handler returns nil, error message and, optionally, start of reported location as negative offset.
local byte_handlers = {
   [BYTE_DOT] = lex_dot,
   [BYTE_COLON] = lex_colon,
   [BYTE_OBRACK] = lex_bracket,
   [BYTE_QUOTE] = lex_short_string,
   [BYTE_DQUOTE] = lex_short_string,
   [BYTE_DASH] = lex_dash,
   [BYTE_SLASH] = lex_div,
   [BYTE_EQ] = lex_eq,
   [BYTE_NE] = lex_ne,
   [BYTE_LT] = lex_lt,
   [BYTE_GT] = lex_gt,
   [BYTE_LDASH] = lex_ident
}

for b=BYTE_0, BYTE_9 do
   byte_handlers[b] = lex_number
end

for b=BYTE_a, BYTE_z do
   byte_handlers[b] = lex_ident
end

for b=BYTE_A, BYTE_Z do
   byte_handlers[b] = lex_ident
end

-- Creates and returns lexer state for source.
function lexer.new_state(src, line_offsets, line_lengths)
   local state = {
      src = src,
      line = 1,
      line_offsets = line_offsets or {},
      line_lengths = line_lengths or {},
      offset = 1
   }

   state.line_offsets[1] = 1

   if src:get_length() >= 2 and src:get_substring(1, 2) == "#!" then
      -- Skip shebang line.
      state.offset = 2
      skip_to_newline(state, next_byte(state))
   end

   return state
end

function lexer.get_quoted_substring_or_line(state, line, offset, end_offset)
   local line_length = state.line_lengths[line]

   if line_length then
      local line_end_offset = state.line_offsets[line] + line_length - 1

      if line_end_offset < end_offset then
         end_offset = line_end_offset
      end
   end

   return "'" .. state.src:get_printable_substring(offset, end_offset) .. "'"
end

-- Looks for next token starting from state.line, state.offset.
-- Returns next token, its value and its location (line, offset).
-- Sets state.line, state.offset to token end location + 1.
-- Fills state.line_offsets and state.line_lengths.
-- On error returns nil, error message, error location (line, offset), error end offset.
function lexer.next_token(state)
   local line_offsets = state.line_offsets
   local b = skip_space(state, state.src:get_codepoint(state.offset))

   -- Save location of token start.
   local token_line = state.line
   local line_offset = line_offsets[token_line]
   local token_offset = state.offset

   if not b then
      -- EOF token has length 1.
      state.offset = state.offset + 1
      state.line_lengths[token_line] = token_offset - line_offset
      return "eof", nil, token_line, token_offset
   end

   local token, token_value, relative_error_offset = (byte_handlers[b] or lex_any)(state, b)

   if relative_error_offset then
      -- Error relative to current offset.
      local error_offset = state.offset + relative_error_offset
      local error_end_offset = math.min(state.offset, state.src:get_length())
      local error_message = token_value .. " " .. lexer.get_quoted_substring_or_line(state,
         state.line, error_offset, error_end_offset)
      return nil, error_message, state.line, error_offset, error_end_offset
   end

   -- Single character errors fall through here.
   return token, token_value, token_line, token_offset, not token and token_offset
end

return lexer
