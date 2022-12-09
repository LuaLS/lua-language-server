local core_utils = require "luacheck.core_utils"

local stage = {}

local function unused_field_value_message_format(warning)
   local target = warning.index and "index" or "field"
   return "value assigned to " .. target .. " {field!} is overwritten on line {overwritten_line} before use"
end

stage.warnings = {
   ["314"] = {message_format = unused_field_value_message_format,
      fields = {"field", "index", "overwritten_line","overwritten_column", "overwritten_end_column"}}
}

local function warn_unused_field_value(chstate, node, field_repr, is_index, overwriting_node)
   chstate:warn_range("314", node, {
      field = field_repr,
      index = is_index,
      overwritten_line = overwriting_node.line,
      overwritten_column = chstate:offset_to_column(overwriting_node.line, overwriting_node.offset),
      overwritten_end_column = chstate:offset_to_column(overwriting_node.line, overwriting_node.end_offset)
   })
end

local function check_table(chstate, node)
   local array_index = 1.0
   local key_value_to_node = {}
   local key_node_to_repr = {}
   local index_key_nodes = {}

   for _, pair in ipairs(node) do
      local key_value
      local key_repr
      local key_node

      if pair.tag == "Pair" then
         key_node = pair[1]
         key_value, key_repr = core_utils.eval_const_node(key_node)
      else
         key_node = pair
         key_value = array_index
         key_repr = tostring(math.floor(key_value))
         array_index = array_index + 1.0
      end

      if key_value then
         local prev_key_node = key_value_to_node[key_value]
         local prev_key_repr = key_node_to_repr[prev_key_node]
         local prev_key_is_index = index_key_nodes[prev_key_node]

         if prev_key_node then
            warn_unused_field_value(chstate, prev_key_node, prev_key_repr, prev_key_is_index, key_node)
         end

         key_value_to_node[key_value] = key_node
         key_node_to_repr[key_node] = key_repr

         if pair.tag ~= "Pair" then
            index_key_nodes[key_node] = true
         end
      end
   end
end

local function check_nodes(chstate, nodes)
   for _, node in ipairs(nodes) do
      if type(node) == "table" then
         if node.tag == "Table" then
            check_table(chstate, node)
         end

         check_nodes(chstate, node)
      end
   end
end

function stage.run(chstate)
   check_nodes(chstate, chstate.ast)
end

return stage
