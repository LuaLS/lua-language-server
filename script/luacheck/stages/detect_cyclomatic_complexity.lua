local utils = require "luacheck.utils"

local stage = {}

local function cyclomatic_complexity_message_format(warning)
   local template = "cyclomatic complexity of %s is too high ({complexity} > {max_complexity})"

   local function_descr

   if warning.function_type == "main_chunk" then
      function_descr = "main chunk"
   elseif warning.function_name then
      function_descr = "{function_type} {function_name!}"
   else
      function_descr = "function"
   end

   return template:format(function_descr)
end

stage.warnings = {
   ["561"] = {message_format = cyclomatic_complexity_message_format,
      fields = {"complexity", "function_type", "function_name"}}
}

local function warn_cyclomatic_complexity(chstate, line, complexity)
   if line == chstate.top_line then
      chstate:warn("561", 1, 1, 1, {
         complexity = complexity,
         function_type = "main_chunk"
      })
   else
      local node = line.node

      chstate:warn_range("561", node, {
         complexity = complexity,
         function_type = node[1][1] and node[1][1].implicit and "method" or "function",
         function_name = node.name
      })
   end
end

local CyclomaticComplexityMetric = utils.class()

function CyclomaticComplexityMetric:incr_decisions(count)
   self.count = self.count + count
end

function CyclomaticComplexityMetric:calc_expr(node)
   if node.tag == "Op" and (node[1] == "and" or node[1] == "or") then
      self:incr_decisions(1)
   end

   if node.tag ~= "Function" then
      self:calc_exprs(node)
   end
end

function CyclomaticComplexityMetric:calc_exprs(exprs)
   for _, expr in ipairs(exprs) do
      if type(expr) == "table" then
         self:calc_expr(expr)
      end
   end
end

function CyclomaticComplexityMetric:calc_item_Eval(item)
   self:calc_expr(item.node)
end

function CyclomaticComplexityMetric:calc_item_Local(item)
   if item.rhs then
      self:calc_exprs(item.rhs)
   end
end

function CyclomaticComplexityMetric:calc_item_Set(item)
   self:calc_exprs(item.rhs)
end

function CyclomaticComplexityMetric:calc_item(item)
   local f = self["calc_item_" .. item.tag]
   if f then
      f(self, item)
   end
end

function CyclomaticComplexityMetric:calc_items(items)
   for _, item in ipairs(items) do
      self:calc_item(item)
   end
end

-- stmt if: {condition, block; condition, block; ... else_block}
function CyclomaticComplexityMetric:calc_stmt_If(node)
   for i = 1, #node - 1, 2 do
      self:incr_decisions(1)
      self:calc_stmts(node[i+1])
   end

   if #node % 2 == 1 then
      self:calc_stmts(node[#node])
   end
end

-- stmt while: {condition, block}
function CyclomaticComplexityMetric:calc_stmt_While(node)
   self:incr_decisions(1)
   self:calc_stmts(node[2])
end

-- stmt repeat: {block, condition}
function CyclomaticComplexityMetric:calc_stmt_Repeat(node)
   self:incr_decisions(1)
   self:calc_stmts(node[1])
end

-- stmt forin: {iter_vars, expression_list, block}
function CyclomaticComplexityMetric:calc_stmt_Forin(node)
   self:incr_decisions(1)
   self:calc_stmts(node[3])
end

-- stmt fornum: {first_var, expression, expression, expression[optional], block}
function CyclomaticComplexityMetric:calc_stmt_Fornum(node)
   self:incr_decisions(1)
   self:calc_stmts(node[5] or node[4])
end

function CyclomaticComplexityMetric:calc_stmt(node)
   local f = self["calc_stmt_" .. node.tag]
   if f then
      f(self, node)
   end
end

function CyclomaticComplexityMetric:calc_stmts(stmts)
   for _, stmt in ipairs(stmts) do
      self:calc_stmt(stmt)
   end
end

-- Cyclomatic complexity of a function equals to the number of decision points plus 1.
function CyclomaticComplexityMetric:report(chstate, line)
   self.count = 1
   self:calc_stmts(line.node[2])
   self:calc_items(line.items)
   warn_cyclomatic_complexity(chstate, line, self.count)
end

function stage.run(chstate)
   local ccmetric = CyclomaticComplexityMetric()

   for _, line in ipairs(chstate.lines) do
      ccmetric:report(chstate, line)
   end
end

return stage
