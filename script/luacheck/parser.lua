local lexer = require "luacheck.lexer"
local utils = require "luacheck.utils"

local parser = {}

-- A table with range info, or simply range, has `line`, `offset`, and `end_offset` fields.
-- `line` is the line of the first character.
-- Parser state table has range info for the current token, and all AST
-- node tables have range info for themself, including parens around expressions
-- that are otherwise not reflected in the AST structure.

parser.SyntaxError = utils.class()

function parser.SyntaxError:__init(msg, range, prev_range)
   self.msg = msg
   self.line = range.line
   self.offset = range.offset
   self.end_offset = range.end_offset

   if prev_range then
      self.prev_line = prev_range.line
      self.prev_offset = prev_range.offset
      self.prev_end_offset = prev_range.end_offset
   end
end

function parser.syntax_error(msg, range, prev_range)
   error(parser.SyntaxError(msg, range, prev_range), 0)
end

local function mark_line_endings(state, token_type)
   for line = state.line, state.lexer.line - 1 do
      state.line_endings[line] = token_type
   end
end

local function skip_token(state)
   while true do
      local token, token_value, line, offset, error_end_offset = lexer.next_token(state.lexer)
      state.token = token
      state.token_value = token_value
      state.line = line
      state.offset = offset
      state.end_offset = error_end_offset or (state.lexer.offset - 1)

      if not token then
         parser.syntax_error(token_value, state)
      end

      if token == "short_comment" then
         state.comments[#state.comments + 1] = {
            contents = token_value,
            line = line,
            offset = offset,
            end_offset = state.end_offset
         }

         state.line_endings[line] = "comment"
      elseif token == "long_comment" then
         mark_line_endings(state, "comment")
      else
         if token ~= "eof" then
            mark_line_endings(state, "string")
            state.code_lines[line] = true
            state.code_lines[state.lexer.line] = true
         end

         return
      end
   end
end

local function token_name(token)
   return token == "name" and "identifier" or (token == "eof" and "<eof>" or ("'" .. token .. "'"))
end

local function parse_error(state, msg, prev_range, token_prefix, message_suffix)
   local token_repr

   if state.token == "eof" then
      token_repr = "<eof>"
   else
      token_repr = lexer.get_quoted_substring_or_line(state.lexer, state.line, state.offset, state.end_offset)
   end

   if token_prefix then
      token_repr = token_prefix .. " " .. token_repr
   end

   msg = msg .. " near " .. token_repr

   if message_suffix then
      msg = msg .. " " .. message_suffix
   end

   parser.syntax_error(msg, state, prev_range)
end

local function check_token(state, token)
   if state.token ~= token then
      parse_error(state, "expected " .. token_name(token))
   end
end

local function check_and_skip_token(state, token)
   check_token(state, token)
   skip_token(state)
end

local function test_and_skip_token(state, token)
   if state.token == token then
      skip_token(state)
      return true
   end
end

local function copy_range(range)
   return {
      line = range.line,
      offset = range.offset,
      end_offset = range.end_offset
   }
end

local new_state
local parse_block
local missing_closing_token_error

-- Attempt to guess a better location for missing `end` and `until` errors (usually they uselessly point to eof).
-- Guessed error token should be selected in such a way that inserting previously missing closing token
-- in front of it should fix the error or at least move its opening token forward.
-- The idea is to track the stack of opening tokens and their indentations.
-- For the first statement or closing token with the same or smaller indentation than the opening token
-- on the top of the stack:
-- * If it has the same indentation but is not the appropriate closing token for the opening one, pick it
--   as the guessed error location.
-- * If it has a lower indentation level, pick it as the guessed error location even it closes the opening token.
-- Example:
-- local function f()
--    <code>
--
--    if cond then                   <- `if` is the guessed opening token
--       <code>
--
--    <code not starting with `end`> <- first token on this line is the guessed error location
-- end
-- Another one:
-- local function g()
--    <code>
--
--    if cond then  <- `if` is the guessed opening token
--       <code>
--
-- end              <- `end` is the guessed error location

local opening_token_to_closing = {
   ["("] = ")",
   ["["] = "]",
   ["{"] = "}",
   ["do"] = "end",
   ["if"] = "end",
   ["else"] = "end",
   ["elseif"] = "end",
   ["while"] = "end",
   ["repeat"] = "until",
   ["for"] = "end",
   ["function"] = "end"
}

local function get_indentation(state, line)
   local ws_start, ws_end = state.lexer.src:find("^[ \t\v\f]*", state.lexer.line_offsets[line])
   return ws_end - ws_start
end

local UnpairedTokenGuesser = utils.class()

function UnpairedTokenGuesser:__init(state, error_opening_range, error_closing_token)
   self.old_state = state
   self.error_offset = state.offset
   self.error_opening_range = error_opening_range
   self.error_closing_token = error_closing_token
   self.opening_tokens_stack = utils.Stack()
end

function UnpairedTokenGuesser:guess()
   -- Need to reinitialize lexer (e.g. to skip shebang again).
   self.state = new_state(self.old_state.lexer.src)
   self.state.unpaired_token_guesser = self
   skip_token(self.state)
   parse_block(self.state)
   error("No syntax error in second parse", 0)
end

function UnpairedTokenGuesser:on_block_start(opening_token_range, opening_token)
   local token_wrapper = copy_range(opening_token_range)
   token_wrapper.token = opening_token
   token_wrapper.closing_token = opening_token_to_closing[opening_token]
   token_wrapper.eligible = token_wrapper.closing_token == self.error_closing_token
   token_wrapper.indentation = get_indentation(self.state, opening_token_range.line)
   self.opening_tokens_stack:push(token_wrapper)
end

function UnpairedTokenGuesser:set_guessed()
   -- Keep the first detected location.
   if self.guessed then
      return
   end

   self.guessed = self.opening_tokens_stack.top
   self.guessed.error_token = self.state.token
   self.guessed.error_range = copy_range(self.state)
end

function UnpairedTokenGuesser:check_token()
   local top = self.opening_tokens_stack.top

   if top and top.eligible and self.state.line > top.line then
      local token_indentation = get_indentation(self.state, self.state.line)

      if token_indentation < top.indentation then
         self:set_guessed()
      elseif token_indentation == top.indentation then
         local token = self.state.token

         if token ~= top.closing_token and
               ((top.token ~= "if" and top.token ~= "elseif") or (token ~= "elseif" and token ~= "else")) then
            self:set_guessed()
         end
      end
   end

   if self.state.offset == self.error_offset then
      if self.guessed and self.guessed.error_range.offset ~= self.state.offset then
         self.state.line = self.guessed.error_range.line
         self.state.offset = self.guessed.error_range.offset
         self.state.end_offset = self.guessed.error_range.end_offset
         self.state.token = self.guessed.error_token
         missing_closing_token_error(self.state, self.guessed, self.guessed.token, self.guessed.closing_token, true)
      end
   end
end

function UnpairedTokenGuesser:on_block_end()
   self:check_token()
   self.opening_tokens_stack:pop()

   if not self.opening_tokens_stack.top then
      -- Inserting an end token into a balanced sequence of tokens adds an error earlier than original one.
      self.guessed = nil
   end
end

function UnpairedTokenGuesser:on_statement()
   self:check_token()
end

function missing_closing_token_error(state, opening_range, opening_token, closing_token, is_guess)
   local msg = "expected " .. token_name(closing_token)

   if opening_range and opening_range.line ~= state.line then
      msg = msg .. " (to close " .. token_name(opening_token) .. " on line " .. tostring(opening_range.line) .. ")"
   end

   local token_prefix
   local message_suffix

   if is_guess then
      if state.token == closing_token then
         -- "expected 'end' near 'end'" seems confusing.
         token_prefix = "less indented"
      end

      message_suffix = "(indentation-based guess)"
   end

   parse_error(state, msg, opening_range, token_prefix, message_suffix)
end

local function check_closing_token(state, opening_range, opening_token)
   local closing_token = opening_token_to_closing[opening_token] or "eof"

   if state.token == closing_token then
      return
   end

   if (opening_token == "if" or opening_token == "elseif") and (state.token == "else" or state.token == "elseif") then
      return
   end

   if closing_token == "end" or closing_token == "until" then
      if not state.unpaired_token_guesser then
         UnpairedTokenGuesser(state, opening_range, closing_token):guess()
      end
   end

   missing_closing_token_error(state, opening_range, opening_token, closing_token)
end

local function check_and_skip_closing_token(state, opening_range, opening_token)
   check_closing_token(state, opening_range, opening_token)
   skip_token(state)
end

local function check_name(state)
   check_token(state, "name")
   return state.token_value
end

local function new_outer_node(range, tag, node)
   node = node or {}
   node.line = range.line
   node.offset = range.offset
   node.end_offset = range.end_offset
   node.tag = tag
   return node
end

local function new_inner_node(start_range, end_range, tag, node)
   node = node or {}
   node.line = start_range.line
   node.offset = start_range.offset
   node.end_offset = end_range.end_offset
   node.tag = tag
   return node
end

local parse_expression

local function parse_expression_list(state, list)
   list = list or {}

   repeat
      list[#list + 1] = parse_expression(state)
   until not test_and_skip_token(state, ",")

   return list
end

local function parse_id(state, tag)
   local ast_node = new_outer_node(state, tag or "Id")
   ast_node[1] = check_name(state)
   -- Skip name.
   skip_token(state)
   return ast_node
end

local function atom(tag)
   return function(state)
      local ast_node = new_outer_node(state, tag)
      ast_node[1] = state.token_value
      skip_token(state)
      return ast_node
   end
end

local simple_expressions = {}

simple_expressions.number = atom("Number")
simple_expressions.string = atom("String")
simple_expressions["nil"] = atom("Nil")
simple_expressions["true"] = atom("True")
simple_expressions["false"] = atom("False")
simple_expressions["..."] = atom("Dots")

simple_expressions["{"] = function(state)
   local start_range = copy_range(state)
   local ast_node = {}
   skip_token(state)

   repeat
      if state.token == "}" then
         break
      end

      local key_node, value_node
      local first_token_range = copy_range(state)

      if state.token == "name" then
         local name = state.token_value
         skip_token(state)  -- Skip name.

         if test_and_skip_token(state, "=") then
            -- `name` = `expr`.
            key_node = new_outer_node(first_token_range, "String", {name})
            value_node = parse_expression(state)
         else
            -- `name` is beginning of an expression in array part.
            -- Backtrack lexer to before name.
            state.lexer.line = first_token_range.line
            state.lexer.offset = first_token_range.offset
            skip_token(state)  -- Load name again.
            value_node = parse_expression(state)
         end
      elseif state.token == "[" then
         -- [ `expr` ] = `expr`.
         skip_token(state)
         key_node = parse_expression(state)
         check_and_skip_closing_token(state, first_token_range, "[")
         check_and_skip_token(state, "=")
         value_node = parse_expression(state)
      else
         -- Expression in array part.
         value_node = parse_expression(state)
      end

      if key_node then
         -- Pair.
         ast_node[#ast_node + 1] = new_inner_node(first_token_range, value_node, "Pair", {key_node, value_node})
      else
         -- Array part item.
         ast_node[#ast_node + 1] = value_node
      end
   until not (test_and_skip_token(state, ",") or test_and_skip_token(state, ";"))

   new_inner_node(start_range, state, "Table", ast_node)
   check_and_skip_closing_token(state, start_range, "{")
   return ast_node
end

-- Parses argument list and the statements.
local function parse_function(state, function_range)
   local paren_range = copy_range(state)
   check_and_skip_token(state, "(")
   local args = {}

   -- Are there arguments?
   if state.token ~= ")" then
      repeat
         if state.token == "name" then
            args[#args + 1] = parse_id(state)
         elseif state.token == "..." then
            args[#args + 1] = simple_expressions["..."](state)
            break
         else
            parse_error(state, "expected argument")
         end
      until not test_and_skip_token(state, ",")
   end

   check_and_skip_closing_token(state, paren_range, "(")
   local body = parse_block(state, function_range, "function")
   local end_range = copy_range(state)
   -- Skip "function".
   skip_token(state)
   return new_inner_node(function_range, end_range, "Function", {args, body, end_range = end_range})
end

simple_expressions["function"] = function(state)
   local function_range = copy_range(state)
   -- Skip "function".
   skip_token(state)
   return parse_function(state, function_range)
end

-- A call handler parses arguments of a call with given base node that determines resulting node start location,
-- given tag, and array to which the arguments should be appended.
local call_handlers = {}

call_handlers["("] = function(state, base_node, tag, node)
   local paren_range = copy_range(state)
   -- Skip "(".
   skip_token(state)

   if state.token ~= ")" then
      parse_expression_list(state, node)
   end

   new_inner_node(base_node, state, tag, node)
   check_and_skip_closing_token(state, paren_range, "(")
   return node
end

call_handlers["{"] = function(state, base_node, tag, node)
   local arg_node = simple_expressions[state.token](state)
   node[#node + 1] = arg_node
   return new_inner_node(base_node, arg_node, tag, node)
end

call_handlers.string = call_handlers["{"]

local suffix_handlers = {}

suffix_handlers["."] = function(state, base_node)
   -- Skip ".".
   skip_token(state)
   local index_node = parse_id(state, "String")
   return new_inner_node(base_node, index_node, "Index", {base_node, index_node})
end

suffix_handlers["["] = function(state, base_node)
   local bracket_range = copy_range(state)
   -- Skip "[".
   skip_token(state)
   local index_node = parse_expression(state)
   local ast_node = new_inner_node(base_node, state, "Index", {base_node, index_node})
   check_and_skip_closing_token(state, bracket_range, "[")
   return ast_node
end

suffix_handlers[":"] = function(state, base_node)
   -- Skip ":".
   skip_token(state)
   local method_name = parse_id(state, "String")
   local call_handler = call_handlers[state.token]

   if not call_handler then
      parse_error(state, "expected method arguments")
   end

   return call_handler(state, base_node, "Invoke", {base_node, method_name})
end

suffix_handlers["("] = function(state, base_node)
   return call_handlers[state.token](state, base_node, "Call", {base_node})
end

suffix_handlers["{"] = suffix_handlers["("]
suffix_handlers.string = suffix_handlers["("]

local function parse_simple_expression(state, kind, no_literals)
   local expression

   if state.token == "(" then
      local paren_range = copy_range(state)
      skip_token(state)
      local inner_expression = parse_expression(state)
      expression = new_inner_node(paren_range, state, "Paren", {inner_expression})
      check_and_skip_closing_token(state, paren_range, "(")
   elseif state.token == "name" then
      expression = parse_id(state)
   else
      local literal_handler = simple_expressions[state.token]

      if not literal_handler or no_literals then
         parse_error(state, "expected " .. (kind or "expression"))
      end

      return literal_handler(state)
   end

   while true do
      local suffix_handler = suffix_handlers[state.token]

      if suffix_handler then
         expression = suffix_handler(state, expression)
      else
         return expression
      end
   end
end

local unary_operators = {
   ["not"] = "not",
   ["-"] = "unm",
   ["~"] = "bnot",
   ["#"] = "len"
}

local unary_priority = 12

local binary_operators = {
   ["+"] = "add", ["-"] = "sub",
   ["*"] = "mul", ["%"] = "mod",
   ["^"] = "pow",
   ["/"] = "div", ["//"] = "idiv",
   ["&"] = "band", ["|"] = "bor", ["~"] = "bxor",
   ["<<"] = "shl", [">>"] = "shr",
   [".."] = "concat",
   ["~="] = "ne", ["=="] = "eq",
   ["<"] = "lt", ["<="] = "le",
   [">"] = "gt", [">="] = "ge",
   ["and"] = "and", ["or"] = "or"
}

local left_priorities = {
   add = 10, sub = 10,
   mul = 11, mod = 11,
   pow = 14,
   div = 11, idiv = 11,
   band = 6, bor = 4, bxor = 5,
   shl = 7, shr = 7,
   concat = 9,
   ne = 3, eq = 3,
   lt = 3, le = 3,
   gt = 3, ge = 3,
   ["and"] = 2, ["or"] = 1
}

local right_priorities = {
   add = 10, sub = 10,
   mul = 11, mod = 11,
   pow = 13,
   div = 11, idiv = 11,
   band = 6, bor = 4, bxor = 5,
   shl = 7, shr = 7,
   concat = 8,
   ne = 3, eq = 3,
   lt = 3, le = 3,
   gt = 3, ge = 3,
   ["and"] = 2, ["or"] = 1
}

local function parse_subexpression(state, limit, kind)
   local expression
   local unary_operator = unary_operators[state.token]

   if unary_operator then
      local operator_range = copy_range(state)
      -- Skip operator.
      skip_token(state)
      local operand = parse_subexpression(state, unary_priority)
      expression = new_inner_node(operator_range, operand, "Op", {unary_operator, operand})
   else
      expression = parse_simple_expression(state, kind)
   end

   -- Expand while operators have priorities higher than `limit`.
   while true do
      local binary_operator = binary_operators[state.token]

      if not binary_operator or left_priorities[binary_operator] <= limit then
         break
      end

       -- Skip operator.
      skip_token(state)
      -- Read subexpression with higher priority.
      local subexpression = parse_subexpression(state, right_priorities[binary_operator])
      expression = new_inner_node(expression, subexpression, "Op", {binary_operator, expression, subexpression})
   end

   return expression
end

function parse_expression(state, kind)
   return parse_subexpression(state, 0, kind)
end

local statements = {}

statements["if"] = function(state)
   local start_range = copy_range(state)
   -- Skip "if".
   skip_token(state)
   local ast_node = {}

   -- The loop is entered after skipping "if" or "elseif".
   -- Block start token info is set to the last skipped "if", "elseif", or "else" token.
   local block_start_token = "if"
   local block_start_range = start_range

   while true do
      ast_node[#ast_node + 1] = parse_expression(state, "condition")
      -- Add range of the "then" token to the block statement array.
      local branch_range = copy_range(state)
      check_and_skip_token(state, "then")
      ast_node[#ast_node + 1] = parse_block(state, block_start_range, block_start_token, branch_range)

      if state.token == "else" then
         branch_range = copy_range(state)
         block_start_token = "else"
         block_start_range = branch_range
         skip_token(state)
         ast_node[#ast_node + 1] = parse_block(state, block_start_range, block_start_token, branch_range)
         break
      elseif state.token == "elseif" then
         block_start_token = "elseif"
         block_start_range = copy_range(state)
         skip_token(state)
      else
         break
      end
   end

   new_inner_node(start_range, state, "If", ast_node)
   -- Skip "end".
   skip_token(state)
   return ast_node
end

statements["while"] = function(state)
   local start_range = copy_range(state)
   -- Skip "while".
   skip_token(state)
   local condition = parse_expression(state, "condition")
   check_and_skip_token(state, "do")
   local block = parse_block(state, start_range, "while")
   local ast_node = new_inner_node(start_range, state, "While", {condition, block})
   -- Skip "end".
   skip_token(state)
   return ast_node
end

statements["do"] = function(state)
   local start_range = copy_range(state)
   -- Skip "do".
   skip_token(state)
   local block = parse_block(state, start_range, "do")
   local ast_node = new_inner_node(start_range, state, "Do", block)
   -- Skip "end".
   skip_token(state)
   return ast_node
end

statements["for"] = function(state)
   local start_range = copy_range(state)
   -- Skip "for".
   skip_token(state)

   local ast_node = {}
   local tag
   local first_var = parse_id(state)

   if state.token == "=" then
      -- Numeric "for" loop.
      tag = "Fornum"
      -- Skip "=".
      skip_token(state)
      ast_node[1] = first_var
      ast_node[2] = parse_expression(state)
      check_and_skip_token(state, ",")
      ast_node[3] = parse_expression(state)

      if test_and_skip_token(state, ",") then
         ast_node[4] = parse_expression(state)
      end

      check_and_skip_token(state, "do")
      ast_node[#ast_node + 1] = parse_block(state, start_range, "for")
   elseif state.token == "," or state.token == "in" then
      -- Generic "for" loop.
      tag = "Forin"

      local iter_vars = {first_var}
      while test_and_skip_token(state, ",") do
         iter_vars[#iter_vars + 1] = parse_id(state)
      end

      ast_node[1] = iter_vars
      check_and_skip_token(state, "in")
      ast_node[2] = parse_expression_list(state)
      check_and_skip_token(state, "do")
      ast_node[3] = parse_block(state, start_range, "for")
   else
      parse_error(state, "expected '=', ',' or 'in'")
   end

   new_inner_node(start_range, state, tag, ast_node)
   -- Skip "end".
   skip_token(state)
   return ast_node
end

statements["repeat"] = function(state)
   local start_range = copy_range(state)
   -- Skip "repeat".
   skip_token(state)
   local block = parse_block(state, start_range, "repeat")
   -- Skip "until".
   skip_token(state)
   local condition = parse_expression(state, "condition")
   return new_inner_node(start_range, condition, "Repeat", {block, condition})
end

statements["function"] = function(state)
   local start_range = copy_range(state)
   -- Skip "function".
   skip_token(state)
   local lhs = parse_id(state)
   local implicit_self_range

   while (not implicit_self_range) and (state.token == "." or state.token == ":") do
      implicit_self_range = (state.token == ":") and copy_range(state)
      -- Skip "." or ":".
      skip_token(state)
      local index_node = parse_id(state, "String")
      lhs = new_inner_node(lhs, index_node, "Index", {lhs, index_node})
   end

   local function_node = parse_function(state, start_range)

   if implicit_self_range then
      -- Insert implicit "self" argument.
      local self_arg = new_outer_node(implicit_self_range, "Id", {"self", implicit = true})
      table.insert(function_node[1], 1, self_arg)
   end

   return new_inner_node(start_range, function_node, "Set", {{lhs}, {function_node}})
end

statements["local"] = function(state)
   local start_range = copy_range(state)
   -- Skip "local".
   skip_token(state)

   if state.token == "function" then
      -- Local function.
      local function_range = copy_range(state)
      -- Skip "function".
      skip_token(state)
      local var = parse_id(state)
      local function_node = parse_function(state, function_range)
      return new_inner_node(start_range, function_node, "Localrec", {{var}, {function_node}})
   end

   -- Local definition, potentially with assignment.
   local lhs = {}
   local rhs

   repeat
      lhs[#lhs + 1] = parse_id(state)
   until not test_and_skip_token(state, ",")

   if test_and_skip_token(state, "=") then
      rhs = parse_expression_list(state)
   end

   return new_inner_node(start_range, rhs and rhs[#rhs] or lhs[#lhs], "Local", {lhs, rhs})
end

statements["::"] = function(state)
   local start_range = copy_range(state)
   -- Skip "::".
   skip_token(state)
   local name = check_name(state)
   -- Skip label name.
   skip_token(state)
   local ast_node = new_inner_node(start_range, state, "Label", {name})
   check_and_skip_token(state, "::")
   return ast_node
end

local closing_tokens = utils.array_to_set({"end", "eof", "else", "elseif", "until"})

statements["return"] = function(state)
   local start_range = copy_range(state)
   -- Skip "return".
   skip_token(state)

   if closing_tokens[state.token] or state.token == ";" then
      -- No return values.
      return new_outer_node(start_range, "Return")
   else
      local returns = parse_expression_list(state)
      return new_inner_node(start_range, returns[#returns], "Return", returns)
   end
end

statements["break"] = function(state)
   local ast_node = new_outer_node(state, "Break")
   -- Skip "break".
   skip_token(state)
   return ast_node
end

statements["goto"] = function(state)
   local start_range = copy_range(state)
   -- Skip "goto".
   skip_token(state)
   local name = check_name(state)
   local ast_node = new_outer_node(start_range, "Goto", {name})
   -- Skip label name.
   skip_token(state)
   return ast_node
end

local function parse_expression_statement(state)
   local lhs
   local start_range = copy_range(state)

   -- Handle lhs of an assignment or a single expression.
   repeat
      local item_start_range = lhs and copy_range(state) or start_range
      local expected = lhs and "identifier or field" or "statement"
      local primary_expression = parse_simple_expression(state, expected, true)

      if primary_expression.tag == "Paren" then
         -- (expr) in lhs is invalid.
         parser.syntax_error("expected " .. expected .. " near '('", item_start_range)
      end

      if primary_expression.tag == "Call" or primary_expression.tag == "Invoke" then
         if lhs then
            -- The is an assingment, and a call is not valid in lhs.
            parse_error(state, "expected call or indexing")
         else
            -- This is a call.
            return primary_expression
         end
      end

      -- This is an assignment.
      lhs = lhs or {}
      lhs[#lhs + 1] = primary_expression
   until not test_and_skip_token(state, ",")

   check_and_skip_token(state, "=")
   local rhs = parse_expression_list(state)
   return new_inner_node(start_range, rhs[#rhs], "Set", {lhs, rhs})
end

local function parse_statement(state)
   return (statements[state.token] or parse_expression_statement)(state)
end

function parse_block(state, opening_token_range, opening_token, block)
   local unpaired_token_guesser = state.unpaired_token_guesser

   if unpaired_token_guesser and opening_token then
      unpaired_token_guesser:on_block_start(opening_token_range, opening_token)
   end

   block = block or {}
   local after_statement = false

   while not closing_tokens[state.token] do
      local first_token = state.token

      if first_token == ";" then
         if not after_statement then
            table.insert(state.hanging_semicolons, copy_range(state))
         end

         -- Skip ";".
         skip_token(state)
         -- Further semicolons are considered hanging.
         after_statement = false
      else
         if unpaired_token_guesser then
            unpaired_token_guesser:on_statement()
         end

         local statement = parse_statement(state)
         after_statement = true
         block[#block + 1] = statement

         if statement.tag == "Return" then
            -- "return" must be the last statement.
            -- However, one ";" after it is allowed.
            test_and_skip_token(state, ";")
            break
         end
      end
   end

   if unpaired_token_guesser and opening_token then
      unpaired_token_guesser:on_block_end()
   end

   check_closing_token(state, opening_token_range, opening_token)

   return block
end

function new_state(src, line_offsets, line_lengths)
   return {
      lexer = lexer.new_state(src, line_offsets, line_lengths),
      -- Set of line numbers containing code.
      code_lines = {},
      -- Maps line numbers to "comment", "string", or nil based on whether the line ending is within a token
      line_endings = {},
      -- Array of {contents = string} with range info.
      comments = {},
       -- Array of ranges of semicolons not following a statement.
      hanging_semicolons = {}
   }
end

-- Parses source characters.
-- Returns AST (in almost MetaLua format), array of comments - tables {contents = string} with range info,
-- set of line numbers containing code, map of types of tokens wrapping line endings (nil, "string", or "comment"),
-- array of ranges of hanging semicolons (not after statements), array of line start offsets, array of line lengths.
-- The last two tables can be passed as arguments to be filled.
-- On error throws an instance of parser.SyntaxError: table {msg = msg, prev_range = prev_range?} with range info,
-- prev_range may refer to some extra relevant location.
function parser.parse(src, line_offsets, line_lengths)
   local state = new_state(src, line_offsets, line_lengths)
   skip_token(state)
   local ast = parse_block(state)
   return ast, state.comments, state.code_lines, state.line_endings, state.hanging_semicolons,
      state.lexer.line_offsets, state.lexer.line_lengths
end

return parser
