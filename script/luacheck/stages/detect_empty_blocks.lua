local core_utils = require "luacheck.core_utils"

local stage = {}

stage.warnings = {
   ["541"] = {message_format = "empty do..end block", fields = {}},
   ["542"] = {message_format = "empty if branch", fields = {}}
}

local function check_block(chstate, block, code)
   if #block == 0 then
      chstate:warn_range(code, block)
   end
end


local function check_node(chstate, node)
   if node.tag == "Do" then
      check_block(chstate, node, "541")
      return
   end

   for index = 2, #node, 2 do
      check_block(chstate, node[index], "542")
   end

   if #node % 2 == 1 then
      check_block(chstate, node[#node], "542")
   end
end

function stage.run(chstate)
   core_utils.each_statement(chstate, {"Do", "If"}, check_node)
end

return stage
