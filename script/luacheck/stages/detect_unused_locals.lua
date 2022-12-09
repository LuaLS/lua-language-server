local utils = require "luacheck.utils"

local stage = {}

local function unused_local_message_format(warning)
   if warning.func then
      if warning.recursive then
         return "unused recursive function {name!}"
      elseif warning.mutually_recursive then
         return "unused mutually recursive function {name!}"
      else
         return "unused function {name!}"
      end
   else
      return "unused variable {name!}"
   end
end

local function unused_arg_message_format(warning)
   if warning.name == "..." then
      return "unused variable length argument"
   else
      return "unused argument {name!}"
   end
end

local function unused_or_overwritten_warning(message_format)
   return {
      message_format = function(warning)
         if warning.overwritten_line then
            return message_format .. " is overwritten on line {overwritten_line} before use"
         else
            return message_format .. " is unused"
         end
      end,
      fields = {"name", "secondary", "overwritten_line", "overwritten_column", "overwritten_end_column"}
   }
end

stage.warnings = {
   ["211"] = {message_format = unused_local_message_format,
      fields = {"name", "func", "secondary", "useless", "recursive", "mutually_recursive"}},
   ["212"] = {message_format = unused_arg_message_format, fields = {"name", "self"}},
   ["213"] = {message_format = "unused loop variable {name!}", fields = {"name"}},
   ["221"] = {message_format = "variable {name!} is never set", fields = {"name", "secondary"}},
   ["231"] = {message_format = "variable {name!} is never accessed", fields = {"name", "secondary"}},
   ["232"] = {message_format = "argument {name!} is never accessed", fields = {"name"}},
   ["233"] = {message_format = "loop variable {name!} is never accessed", fields = {"name"}},
   ["241"] = {message_format = "variable {name!} is mutated but never accessed", fields = {"name", "secondary"}},
   ["311"] = unused_or_overwritten_warning("value assigned to variable {name!}"),
   ["312"] = unused_or_overwritten_warning("value of argument {name!}"),
   ["313"] = unused_or_overwritten_warning("value of loop variable {name!}"),
   ["331"] = {message_format = "value assigned to variable {name!} is mutated but never accessed",
      fields = {"name", "secondary"}}
}

local function is_secondary(value)
   return value.secondaries and value.secondaries.used
end

local type_codes = {
   var = "1",
   func = "1",
   arg = "2",
   loop = "3",
   loopi = "3"
}

local function warn_unused_var(chstate, value, is_useless)
   chstate:warn_value("21" .. type_codes[value.var.type], value, {
      secondary = is_secondary(value) or nil,
      func = value.type == "func" or nil,
      self = value.var.self,
      useless = value.var.name == "_" and is_useless or nil
   })
end

local function warn_unaccessed_var(chstate, var, is_mutated)
   -- Mark as secondary if all assigned values are secondary.
   -- It is guaranteed that there are at least two values.
   local secondary = true

   for _, value in ipairs(var.values) do
      if not value.empty and not is_secondary(value) then
         secondary = nil
         break
      end
   end

   chstate:warn_var("2" .. (is_mutated and "4" or "3") .. type_codes[var.type], var, {
      secondary = secondary
   })
end

local function warn_unused_value(chstate, value, overwriting_node)
   local warning = chstate:warn_value("3" .. (value.mutated and "3" or "1") .. type_codes[value.type], value, {
      secondary = is_secondary(value) or nil
   })

   if overwriting_node then
      warning.overwritten_line = overwriting_node.line
      warning.overwritten_column = chstate:offset_to_column(overwriting_node.line, overwriting_node.offset)
      warning.overwritten_end_column = chstate:offset_to_column(overwriting_node.line, overwriting_node.end_offset)
   end
end

-- Returns `true` if a variable should be reported as a function instead of simply local,
-- `false` otherwise.
-- A variable is considered a function if it has a single assignment and the value is a function,
-- or if there is a forward declaration with a function assignment later.
local function is_function_var(var)
   return (#var.values == 1 and var.values[1].type == "func") or (
      #var.values == 2 and var.values[1].empty and var.values[2].type == "func")
end

local externally_accessible_tags = utils.array_to_set({"Id", "Index", "Call", "Invoke", "Op", "Paren", "Dots"})

local function is_externally_accessible(value)
   return value.type ~= "var" or (value.node and externally_accessible_tags[value.node.tag])
end

local function get_overwriting_lhs_node(item, value)
   for _, node in ipairs(item.lhs) do
      if node.var == value.var then
         return node
      end
   end
end

local function get_second_overwriting_lhs_node(item, value)
   local after_value_node

   for _, node in ipairs(item.lhs) do
      if node.var == value.var then
         if after_value_node then
            return node
         elseif node == value.var_node then
            after_value_node = true
         end
      end
   end
end

local function detect_unused_local(chstate, var)
   if is_function_var(var) then
      local value = var.values[2] or var.values[1]

      if not value.used then
         warn_unused_var(chstate, value)
      end
   elseif #var.values == 1 then
      local value = var.values[1]

      if not value.used then
         if value.mutated then
            if not is_externally_accessible(value) then
               warn_unaccessed_var(chstate, var, true)
            end
         else
            warn_unused_var(chstate, value, value.empty)
         end
      elseif value.empty then
         chstate:warn_var("221", var)
      end
   elseif not var.accessed and not var.mutated then
      warn_unaccessed_var(chstate, var)
   else
      local no_values_externally_accessible = true

      for _, value in ipairs(var.values) do
         if is_externally_accessible(value) then
            no_values_externally_accessible = false
         end
      end

      if not var.accessed and no_values_externally_accessible then
         warn_unaccessed_var(chstate, var, true)
      end

      for _, value in ipairs(var.values) do
         if not value.empty then
            if not value.used then
               if not value.mutated then
                  local overwriting_node

                  if value.overwriting_item then
                     if value.overwriting_item ~= value.item then
                        overwriting_node = get_overwriting_lhs_node(value.overwriting_item, value)
                     end
                  else
                     overwriting_node = get_second_overwriting_lhs_node(value.item, value)
                  end

                  warn_unused_value(chstate, value, overwriting_node)
               elseif not is_externally_accessible(value) then
                  if var.accessed or not no_values_externally_accessible then
                     warn_unused_value(chstate, value)
                  end
               end
            end
         end
      end
   end
end

local function detect_unused_locals_in_line(chstate, line)
   for _, item in ipairs(line.items) do
      if item.tag == "Local" then
         for var in pairs(item.set_variables) do
            -- Do not check the implicit top level vararg.
            if var.node.line then
               detect_unused_local(chstate, var)
            end
         end
      end
   end
end

local function detect_unused_locals(chstate)
   for _, line in ipairs(chstate.lines) do
      detect_unused_locals_in_line(chstate, line)
   end
end

local function mark_reachable_lines(edges, marked, line)
   for connected_line in pairs(edges[line]) do
      if not marked[connected_line] then
         marked[connected_line] = true
         mark_reachable_lines(edges, marked, connected_line)
      end
   end
end

local function detect_unused_rec_funcs(chstate)
   -- Build a graph of usage relations of all closures.
   -- Closure A is used by closure B iff either B is parent
   -- of A and A is not assigned to a local/upvalue, or
   -- B uses local/upvalue value that is A.
   -- Closures not reachable from root closure are unused,
   -- report corresponding values/variables if not done already.

   local line = chstate.top_line

   -- Initialize edges maps.
   local forward_edges = {[line] = {}}
   local backward_edges = {[line] = {}}

   for _, nested_line in ipairs(line.lines) do
      forward_edges[nested_line] = {}
      backward_edges[nested_line] = {}
   end

   -- Add edges leading to each nested line.
   for _, nested_line in ipairs(line.lines) do
      if nested_line.node.value then
         for using_line in pairs(nested_line.node.value.using_lines) do
            forward_edges[using_line][nested_line] = true
            backward_edges[nested_line][using_line] = true
         end
      elseif nested_line.parent then
         forward_edges[nested_line.parent][nested_line] = true
         backward_edges[nested_line][nested_line.parent] = true
      end
   end

   -- Recursively mark all closures reachable from root closure and unused closures.
   -- Closures reachable from main chunk are used; closure reachable from unused closures
   -- depend on that closure; that is, fixing warning about parent unused closure
   -- fixes warning about the child one, so issuing a warning for the child is superfluous.
   local marked = {[line] = true}
   mark_reachable_lines(forward_edges, marked, line)

   for _, nested_line in ipairs(line.lines) do
      if nested_line.node.value and not nested_line.node.value.used then
         marked[nested_line] = true
         mark_reachable_lines(forward_edges, marked, nested_line)
      end
   end

   -- Deal with unused closures.
   for _, nested_line in ipairs(line.lines) do
      local value = nested_line.node.value

      if value and value.used and not marked[nested_line] then
         -- This closure is used by some closure, but is not marked as reachable
         -- from main chunk or any of reported closures.
         -- Find candidate group of mutually recursive functions containing this one:
         -- mark sets of closures reachable from it by forward and backward edges,
         -- intersect them. Ignore already marked closures in the process to avoid
         -- issuing superfluous, dependent warnings.
         local forward_marked = setmetatable({}, {__index = marked})
         local backward_marked = setmetatable({}, {__index = marked})
         mark_reachable_lines(forward_edges, forward_marked, nested_line)
         mark_reachable_lines(backward_edges, backward_marked, nested_line)

         -- Iterate over closures in the group.
         for mut_rec_line in pairs(forward_marked) do
            if rawget(backward_marked, mut_rec_line) then
               marked[mut_rec_line] = true
               value = mut_rec_line.node.value

               if value then
                  -- Report this closure as self recursive or mutually recursive.
                  local is_self_recursive = forward_edges[mut_rec_line][mut_rec_line]

                  if is_function_var(value.var) then
                     chstate:warn_value("211", value, {
                        func = true,
                        mutually_recursive = not is_self_recursive or nil,
                        recursive = is_self_recursive or nil
                     })
                  else
                     chstate:warn_value("311", value)
                  end
               end
            end
         end
      end
   end
end

-- Warns about unused local variables and their values as well as locals that
-- are accessed but never set or set but never accessed.
-- Warns about unused recursive functions.
function stage.run(chstate)
   detect_unused_locals(chstate)
   detect_unused_rec_funcs(chstate)
end

return stage
