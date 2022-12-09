local stage = {}

local function get_index_name(base_name, key_node)
   if key_node.tag == "String" then
      return base_name .. "." .. key_node[1]
   end
end

local function get_full_field_name(node)
   if node.tag == "Id" then
      return node[1]
   elseif node.tag == "Index" then
      local base_name = get_full_field_name(node[1])
      return base_name and get_index_name(base_name, node[2])
   end
end

local handle_node

local function handle_nodes(nodes)
   for _, node in ipairs(nodes) do
      if type(node) == "table" then
         handle_node(node)
      end
   end
end

function handle_node(node, name)
   if node.tag == "Function" then
      node.name = name
      handle_nodes(node[2])
   elseif node.tag == "Set" or node.tag == "Local" or node.tag == "Localrec" then
      local lhs = node[1]
      local rhs = node[2]

      -- No need to handle LHS if there is no RHS, it's always just a list of locals in that case.
      if rhs then
         handle_nodes(lhs)

         for index, rhs_node in ipairs(rhs) do
            local lhs_node = lhs[index]
            local field_name = lhs_node and get_full_field_name(lhs_node)
            handle_node(rhs_node, field_name)
         end
      end
   elseif node.tag == "Table" and name then
      for _, pair_node in ipairs(node) do
         if pair_node.tag == "Pair" then
            local key_node = pair_node[1]
            local value_node = pair_node[2]
            handle_node(key_node)
            handle_node(value_node, get_index_name(name, key_node))
         else
            handle_node(pair_node)
         end
      end
   else
      handle_nodes(node)
   end
end

-- Adds `name` field to `Function` ast nodes when possible:
-- * Function assigned to a variable (doesn't matter if local or global): "foo".
-- * Function assigned to a field: "foo.bar.baz".
--   Function can be in a table assigned to a variable or a field, e.g. `foo.bar = {baz = function() ... end}`.
-- * Otherwise: `nil`.
function stage.run(chstate)
   handle_nodes(chstate.ast)
end

return stage
