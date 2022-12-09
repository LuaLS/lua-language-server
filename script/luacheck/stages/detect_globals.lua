local utils = require "luacheck.utils"

local stage = {}

local function prefix_if_indirect(message)
   return function(warning)
      if warning.indirect then
         return "indirectly " .. message
      else
         return message
      end
   end
end

local function setting_global_format_message(warning)
   -- `module` field is set during filtering.
   if warning.module then
      return "setting non-module global variable {name!}"
   else
      return "setting non-standard global variable {name!}"
   end
end
local global_warning_fields = {"name", "indexing", "previous_indexing_len", "top", "indirect"}

stage.warnings = {
   ["111"] = {message_format = setting_global_format_message, fields = global_warning_fields},
   ["112"] = {message_format = "mutating non-standard global variable {name!}", fields = global_warning_fields},
   ["113"] = {message_format = "accessing undefined variable {name!}", fields = global_warning_fields},
   -- The following warnings are added during filtering.
   ["121"] = {message_format = "setting read-only global variable {name!}", fields = {}},
   ["122"] = {message_format = prefix_if_indirect("setting read-only field {field!} of global {name!}"), fields = {}},
   ["131"] = {message_format = "unused global variable {name!}", fields = {}},
   ["142"] = {message_format = prefix_if_indirect("setting undefined field {field!} of global {name!}"), fields = {}},
   ["143"] = {message_format = prefix_if_indirect("accessing undefined field {field!} of global {name!}"), fields = {}}
}

local action_codes = {
   set = "1",
   mutate = "2",
   access = "3"
}

-- `index` describes an indexing, where `index[1]` is a global node
-- and other items describe keys: each one is a string node, "not_string",
-- or "unknown". `node` is literal base node that's indexed.
-- E.g. in `local a = table.a; a.b = "c"` `node` is `a` node of the second
-- statement and `index` describes `table.a.b`.
-- `index.previous_indexing_len` is optional length of prefix of `index` array representing last assignment
-- in the aliasing chain, e.g. `2` in the previous example (because last indexing is `table.a`).
local function warn_global(chstate, node, index, is_lhs, is_top_line)
   local global = index[1]
   local action = is_lhs and (#index == 1 and "set" or "mutate") or "access"

   local indexing

   if #index > 1 then
      indexing = {}

      for i, field in ipairs(index) do
         if i > 1 then
            if field == "unknown" then
               indexing[i - 1] = true
            elseif field == "not_string" then
               indexing[i - 1] = false
            else
               indexing[i - 1] = field[1]
            end
         end
      end
   end

   chstate:warn_range("11" .. action_codes[action], node, {
      name = global[1],
      indexing = indexing,
      previous_indexing_len = index.previous_indexing_len,
      top = is_top_line and action == "set" or nil,
      indirect = node ~= global or nil
   })
end

local function resolved_to_index(resolution)
   return resolution ~= "unknown" and resolution ~= "not_string" and resolution.tag ~= "String"
end

local literal_tags = utils.array_to_set({"Nil", "True", "False", "Number", "String", "Table", "Function"})

local deep_resolve -- Forward declaration.

local function resolve_node(node, item)
   if node.tag == "Id" or node.tag == "Index" then
      deep_resolve(node, item)
      return node.resolution
   elseif literal_tags[node.tag] then
      return node.tag == "String" and node or "not_string"
   else
      return "unknown"
   end
end

-- Resolves value of an identifier or index node, tracking through simple
-- assignments like `local foo = bar.baz`.
-- Can be given an `Invoke` node to resolve the method field.
-- Sets `node.resolution` to "unknown", "not_string", `string node`, or
-- {previous_indexing_len = index, global_node, key...}.
-- Each key can be "unknown", "not_string" or `string_node`.
function deep_resolve(node, item)
   if node.resolution then
      return
   end

   -- Common case.
   -- Also protects against infinite recursion, if it's even possible.
   node.resolution = "unknown"

   local base = node
   local base_tag = node.tag == "Id" and "Id" or "Index"
   local keys = {}

   while base_tag == "Index" do
      table.insert(keys, 1, base[2])
      base = base[1]
      base_tag = base.tag
   end

   if base_tag ~= "Id" then
      return
   end

   local var = base.var
   local base_resolution
   local previous_indexing_len

   if var then
      if not item.used_values[var] or #item.used_values[var] ~= 1 then
         -- Do not know where the value for the base local came from.
         return
      end

      local value = item.used_values[var][1]

      if not value.node then
         return
      end

      base_resolution = resolve_node(value.node, value.item)

      if resolved_to_index(base_resolution) then
         previous_indexing_len = #base_resolution
      end
   else
      base_resolution = {base}
   end

   if #keys == 0 then
      node.resolution = base_resolution
   elseif not resolved_to_index(base_resolution) then
      -- Indexing something unknown or indexing a literal.
      node.resolution = "unknown"
   else
      local resolution = utils.update({}, base_resolution)
      resolution.previous_indexing_len = previous_indexing_len

      for _, key in ipairs(keys) do
         local key_resolution = resolve_node(key, item)

         if resolved_to_index(key_resolution) then
            key_resolution = "unknown"
         end

         table.insert(resolution, key_resolution)
      end

      -- Assign resolution only after all the recursive calls.
      node.resolution = resolution
   end
end

local function detect_in_node(chstate, item, node, is_top_line, is_lhs)
   if node.tag == "Index" or node.tag == "Invoke" or node.tag == "Id" then
      if node.tag == "Id" and node.var then
         -- Do not warn about assignments to and accesses of local variables
         -- that resolve to globals or their fields.
         return
      end

      deep_resolve(node, item)
      local resolution = node.resolution

      -- Still need to recurse into base and key nodes.
      -- E.g. don't miss a global in `(global1())[global2()].

      if node.tag == "Invoke" then
         for i = 3, #node do
            detect_in_node(chstate, item, node[i], is_top_line)
         end
      end

      if node.tag ~= "Id" then
         repeat
            detect_in_node(chstate, item, node[2], is_top_line)
            node = node[1]
         until node.tag ~= "Index"

         if node.tag ~= "Id" then
            detect_in_node(chstate, item, node, is_top_line)
         end
      end

      if resolved_to_index(resolution) then
         warn_global(chstate, node, resolution, is_lhs, is_top_line)
      end
   elseif node.tag ~= "Function" then
      for _, nested_node in ipairs(node) do
         if type(nested_node) == "table" then
            detect_in_node(chstate, item, nested_node, is_top_line)
         end
      end
   end
end

local function detect_in_nodes(chstate, item, nodes, is_top_line, is_lhs)
   for _, node in ipairs(nodes) do
      detect_in_node(chstate, item, node, is_top_line, is_lhs)
   end
end

local function detect_globals_in_line(chstate, line)
   local is_top_line = line == chstate.top_line

   for _, item in ipairs(line.items) do
      if item.tag == "Eval" then
         detect_in_node(chstate, item, item.node, is_top_line)
      elseif item.tag == "Local" then
         if item.rhs then
            detect_in_nodes(chstate, item, item.rhs, is_top_line)
         end
      elseif item.tag == "Set" then
         detect_in_nodes(chstate, item, item.lhs, is_top_line, true)
         detect_in_nodes(chstate, item, item.rhs, is_top_line)
      end
   end
end

-- Warns about assignments, field accesses, and mutations of global variables,
-- tracing through localizing assignments such as `local t = table`.
function stage.run(chstate)
   for _, line in ipairs(chstate.lines) do
      detect_globals_in_line(chstate, line)
   end
end

return stage
