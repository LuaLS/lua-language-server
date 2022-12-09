local core_utils = require "luacheck.core_utils"

local stage = {}

stage.warnings = {
   ["571"] = {message_format = "numeric for loop goes from #(expr) down to {limit} but loop step is not negative",
      fields = {"limit"}}
}

local function check_fornum(chstate, node)
   if node[2].tag ~= "Op" or node[2][1] ~= "len" then
      return
   end

   local limit, limit_repr = core_utils.eval_const_node(node[3])

   if not limit or limit > 1 then
      return
   end

   local step = 1

   if node[5] then
      step = core_utils.eval_const_node(node[4])
   end

   if step and step >= 0 then
      chstate:warn_range("571", node, {
         limit = limit_repr
      })
   end
end

-- Warns about loops trying to go from `#(expr)` to `1` with positive step.
function stage.run(chstate)
   core_utils.each_statement(chstate, {"Fornum"}, check_fornum)
end

return stage
