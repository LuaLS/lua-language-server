local stage = {}

-- Mutates an array of nodes and non-tables, unwrapping Paren nodes.
-- If list_start is given, tail Paren is not unwrapped if it's unpacking and past list_start index.
local function handle_nodes(nodes, list_start)
   local num_nodes = #nodes

   for index = 1, num_nodes do
      local node = nodes[index]

      if type(node) == "table" then
         local tag = node.tag

         if tag == "Table" or tag == "Return" then
            handle_nodes(node, 1)
         elseif tag == "Call" then
            handle_nodes(node, 2)
         elseif tag == "Invoke" then
            handle_nodes(node, 3)
         elseif tag == "Forin" then
            handle_nodes(node[2], 1)
            handle_nodes(node[3])
         elseif tag == "Local" then
            if node[2] then
               handle_nodes(node[2])
            end
         elseif tag == "Set" then
            handle_nodes(node[1])
            handle_nodes(node[2], 1)
         else
            handle_nodes(node)

            if tag == "Paren" and (not list_start or index < list_start or index ~= num_nodes) then
               local inner_node = node[1]

               if inner_node.tag ~= "Call" and inner_node.tag ~= "Invoke" and inner_node.tag ~= "Dots" then
                  nodes[index] = inner_node
               end
            end
         end
      end
   end
end

-- Mutates AST, unwrapping Paren nodes.
-- Paren nodes are preserved only when they matter:
-- at the ends of expression lists with potentially multi-value inner expressions.
function stage.run(chstate)
   handle_nodes(chstate.ast)
end

return stage
