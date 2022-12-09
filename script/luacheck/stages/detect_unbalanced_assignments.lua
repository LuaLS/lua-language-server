local core_utils = require "luacheck.core_utils"

local stage = {}

stage.warnings = {
   ["531"] = {message_format = "right side of assignment has more values than left side expects", fields = {}},
   ["532"] = {message_format = "right side of assignment has less values than left side expects", fields = {}}
}

local function is_unpacking(node)
   return node.tag == "Dots" or node.tag == "Call" or node.tag == "Invoke"
end

local function check_assignment(chstate, node)
   local rhs = node[2]

   if not rhs then
      return
   end

   local lhs = node[1]

   if #rhs > #lhs then
      chstate:warn_range("531", node)
   elseif #rhs < #lhs and node.tag == "Set" and not is_unpacking(rhs[#rhs]) then
      chstate:warn_range("532", node)
   end
end

function stage.run(chstate)
   core_utils.each_statement(chstate, {"Set", "Local"}, check_assignment)
end

return stage
