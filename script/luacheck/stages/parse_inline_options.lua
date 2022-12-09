local options = require "luacheck.options"
local utils = require "luacheck.utils"

local stage = {}

stage.warnings = {
   -- Also produced during filtering for options that did not pass validation.
   ["021"] = {message_format = "{msg}", fields = {"msg"}},
   ["022"] = {message_format = "unpaired push directive", fields = {}},
   ["023"] = {message_format = "unpaired pop directive", fields = {}}
}

stage.inline_option_fields = {"line", "pop_count", "options", "column", "end_column"}

local limit_opts = utils.array_to_set({"max_line_length", "max_code_line_length", "max_string_line_length",
   "max_comment_line_length", "max_cyclomatic_complexity"})

local function is_valid_option_name(name)
   if name == "std" or options.variadic_inline_options[name] then
      return true
   end

   name = name:gsub("^no_", "")
   return options.nullary_inline_options[name] or limit_opts[name]
end

-- Splits a token array for an inline option invocation into
-- option name and argument array, or nil if invocation is invalid.
local function split_invocation(tokens)
   -- Name of the option can be split into several space separated tokens.
   -- Since some valid names are prefixes of some other names
   -- (e.g. `unused` and `unused arguments`), the longest prefix of token
   -- array that is a valid option name should be considered.
   local cur_name
   local last_valid_name
   local last_valid_name_end_index

   for i, token in ipairs(tokens) do
      cur_name = cur_name and (cur_name .. "_" .. token) or token

      if is_valid_option_name(cur_name) then
         last_valid_name = cur_name
         last_valid_name_end_index = i
      end
   end

   if not last_valid_name then
      return
   end

   local args = {}

   for i = last_valid_name_end_index + 1, #tokens do
      table.insert(args, tokens[i])
   end

   return last_valid_name, args
end

local function unexpected_num_args(name, args, expected)
   return ("inline option '%s' expects %d argument%s, %d given"):format(
      name, expected, expected == 1 and "" or "s", #args)
end

-- Parses inline option body, returns options or nil and error message.
local function parse_options(body)
   local opts = {}

   local parts = utils.split(body, ",")

   for _, name_and_args in ipairs(parts) do
      local tokens = utils.split(name_and_args)
      local name, args = split_invocation(tokens)

      if not name then
         if #tokens == 0 then
            return nil, (#parts == 1) and "empty inline option" or "empty inline option invocation"
         else
            return nil, ("unknown inline option '%s'"):format(table.concat(tokens, " "))
         end
      end

      if name == "std" then
         if #args ~= 1 then
            return nil, unexpected_num_args(name, args, 1)
         end

         opts.std = args[1]
      elseif name == "ignore" and #args == 0 then
         opts.ignore = {".*"}
      elseif options.variadic_inline_options[name] then
         opts[name] = args
      else
         local full_name = name:gsub("_", " ")
         local subs
         name, subs = name:gsub("^no_", "")
         local flag = subs == 0

         if options.nullary_inline_options[name] then
            if #args ~= 0 then
               return nil, unexpected_num_args(full_name, args, 0)
            end

            opts[name] = flag
         else
            assert(limit_opts[name])

            if flag then
               if #args ~= 1 then
                  return nil, unexpected_num_args(full_name, args, 1)
               end

               local value = tonumber(args[1])

               if not value then
                  return nil, ("inline option '%s' expects number as argument"):format(name)
               end

               opts[name] = value
            else
               if #args ~= 0 then
                  return nil, unexpected_num_args(full_name, args, 0)
               end

               opts[name] = false
            end
         end
      end
   end

   return opts
end

-- Parses comment contents, returns up to two `options` values (tables or "push" or "pop").
-- On an invalid inline comment returns nil and an error message.
local function parse_inline_comment(comment_contents)
   local body = utils.after(utils.strip(comment_contents), "^luacheck:")

   if not body then
      return
   end

   local opts1, opts2

   -- Remove comments in balanced parens.
   body = utils.strip((body:gsub("%b()", " ")))
   local after_push = body:match("^push%s+(.*)")

   if after_push then
      opts2 = "push"
      body = after_push
   elseif body == "push" or body == "pop" then
      return body
   end

   local err_msg
   opts1, err_msg = parse_options(body)
   return opts1, err_msg or opts2
end

-- Returns an array of tables with column range info and an `options` field
-- containing a table of options or "push" or "pop".
-- Warns about invalid inline option comments.
local function parse_inline_comments(chstate)
   local res = {}

   for _, comment in ipairs(chstate.comments) do
      local opts1, opts2 = parse_inline_comment(comment.contents)

      if opts1 then
         table.insert(res, {
            line = comment.line,
            column = chstate:offset_to_column(comment.line, comment.offset),
            end_column = chstate:offset_to_column(comment.line, comment.end_offset),
            options = opts1
         })

         if opts2 then
            table.insert(res, {
               line = comment.line,
               column = chstate:offset_to_column(comment.line, comment.offset),
               end_column = chstate:offset_to_column(comment.line, comment.end_offset),
               options = opts2
            })
         end
      elseif opts2 then
         chstate:warn_range("021", comment, {msg = opts2})
      end
   end

   return res
end

-- Adds a table with `line`, `column`, and `options` fields to given array.
-- For each function a table with `options` set to "push" for the function start
-- and a talbe with `options` set to "pop" for the function end are added.
local function add_function_boundaries(inline_options_and_boundaries, chstate)
   for _, line in ipairs(chstate.top_line.lines) do
      local fn_node = line.node

      table.insert(inline_options_and_boundaries, {
         line = fn_node.line,
         column = chstate:offset_to_column(fn_node.line, fn_node.offset),
         options = "push"
      })

      table.insert(inline_options_and_boundaries, {
         line = fn_node.end_range.line,
         column = chstate:offset_to_column(fn_node.end_range.line, fn_node.end_range.offset),
         options = "pop"
      })
   end
end

local function get_order(t)
   if t.options == "push" then
      return 1
   elseif t.options == "pop" then
      return 3
   else
      return 2
   end
end

local function options_and_boundaries_comparator(t1, t2)
   if t1.line ~= t2.line then
      return t1.line < t2.line
   end

   -- For options and boundaries on the same line, all pushes are applied before options before pops.
   -- (Valid pops will be moved to the start of the next line later.)
   local order1 = get_order(t1)
   local order2 = get_order(t2)

   if order1 ~= order2 then
      return order1 < order2
   else
      return t1.column < t2.column
   end
end

-- Applies bounadaries withing `inline_options_and_boundaries` to replace them with pop count
-- instructions in the resulting array.
-- Comments on lines with code are popped at the end of line.
-- Warns about unpaired push and pop directives.
local function apply_boundaries(chstate, inline_options_and_boundaries)
   local res = {}
   local res_last

   -- While iterating over inline options and boundaries track push
   -- boundaries that were not popped yet plus the number of options
   -- that would be on the option stack after applying all already
   -- processed option table pushes and pops.
   local pushes = utils.Stack()
   local push_option_counts = utils.Stack()
   local option_count = 0

   for _, item in ipairs(inline_options_and_boundaries) do
      if item.options == "push" then
         pushes:push(item)
         push_option_counts:push(option_count)
      elseif item.options == "pop" then
         -- Function boundaries are implicit, don't allow inline options to pop
         -- them, don't allow function boundaries to pop inline option pushes either.
         -- Inline options boundaries have end_column, function boundaries don't.
         if not pushes.top or (item.end_column and not pushes.top.end_column) then
            -- Inline option pop against nothing or a function push, mark as unpaired.
            chstate:warn_column_range("023", item)
         else
            if not item.end_column then
               -- Function pop, remove any unpaired inline option pushes.
               while pushes.top and pushes.top.end_column do
                  chstate:warn_column_range("022", pushes.top)
                  pushes:pop()
                  push_option_counts:pop()
               end
            end

            pushes:pop()
            local prev_option_count = push_option_counts:pop()
            local pop_count = option_count - prev_option_count

            if pop_count > 0 then
               -- Place the pop instruction at the start of the next line so that getting option stack
               -- for a line amounts to applying both the pop instruction and the option push for the line.
               local line = item.line + 1

               -- Collapse with a previous table if it's on the same line. It can only be a pop count table.
               if res_last and res_last.line == line then
                  res_last.pop_count = res_last.pop_count + pop_count
               else
                  res_last = {
                     line = line,
                     pop_count = pop_count
                  }

                  table.insert(res, res_last)
               end
            end

            -- Update option stack size for this pop.
            option_count = prev_option_count
         end
      else
         -- Inline options table. Check if there is a pop count table for this line already.
         if res_last and res_last.line == item.line then
            res_last.options = item.options
            res_last.column = item.column
            res_last.end_column = item.end_column
         else
            res_last = item
            table.insert(res, item)
         end

         if chstate.code_lines[item.line] then
            -- Inline comment on a line with some code, immediately pop it.
            res_last = {
               line = item.line + 1,
               pop_count = 1
            }
            table.insert(res, res_last)
         else
            option_count = option_count + 1
         end
      end
   end

   -- Any remaining pushes are unpaired inline comments from the main chunk.
   while pushes.top do
      chstate:warn_column_range("022", pushes:pop())
   end

   return res
end

-- Warns about invalid inline options.
-- Sets `chstate.inline_options` to an array of tables that describe the way inline option tables
-- are pushed onto and popped from the option stack when iterating over lines.
-- Each table has field `line` that the array is sorted by and also ether or both sets of fields:
-- * `pop_count` - refers to a number of option tables that should be popped from the stack before processing
--   warnings on this line.
-- * `options`, `column`, `end_column` - refers to an option table that should be pushed onto the stack
--   before processing warnings on this line but after popping tables if `pop_count` is present.
function stage.run(chstate)
   local inline_options_and_boundaries = parse_inline_comments(chstate)
   add_function_boundaries(inline_options_and_boundaries, chstate)
   table.sort(inline_options_and_boundaries, options_and_boundaries_comparator)
   chstate.inline_options = apply_boundaries(chstate, inline_options_and_boundaries)
end

return stage
