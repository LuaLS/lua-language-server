local parser = require "luacheck.parser"
local utils = require "luacheck.utils"

local stage = {}

local function redefined_warning(message_format)
   return {
      message_format = message_format,
      fields = {"name", "prev_line", "prev_column", "prev_end_column", "self"}
   }
end

stage.warnings = {
   ["411"] = redefined_warning("variable {name!} was previously defined on line {prev_line}"),
   ["412"] = redefined_warning("variable {name!} was previously defined as an argument on line {prev_line}"),
   ["413"] = redefined_warning("variable {name!} was previously defined as a loop variable on line {prev_line}"),
   ["421"] = redefined_warning("shadowing definition of variable {name!} on line {prev_line}"),
   ["422"] = redefined_warning("shadowing definition of argument {name!} on line {prev_line}"),
   ["423"] = redefined_warning("shadowing definition of loop variable {name!} on line {prev_line}"),
   ["431"] = redefined_warning("shadowing upvalue {name!} on line {prev_line}"),
   ["432"] = redefined_warning("shadowing upvalue argument {name!} on line {prev_line}"),
   ["433"] = redefined_warning("shadowing upvalue loop variable {name!} on line {prev_line}"),
   ["521"] = {message_format = "unused label {label!}", fields = {"label"}}
}

local type_codes = {
   var = "1",
   func = "1",
   arg = "2",
   loop = "3",
   loopi = "3"
}

local function warn_redefined(chstate, var, prev_var, is_same_scope)
   local code = "4" .. (is_same_scope and "1" or var.line == prev_var.line and "2" or "3") .. type_codes[prev_var.type]

   chstate:warn_var(code, var, {
      self = var.self and prev_var.self,
      prev_line = prev_var.node.line,
      prev_column = chstate:offset_to_column(prev_var.node.line, prev_var.node.offset),
      prev_end_column = chstate:offset_to_column(prev_var.node.line, prev_var.node.end_offset)
   })
end

local function warn_unused_label(chstate, label)
   chstate:warn_range("521", label.range, {
      label = label.name
   })
end

local pseudo_labels = utils.array_to_set({"do", "else", "break", "end", "return"})

local Line = utils.class()

function Line:__init(node, parent, value)
   -- Maps variables to arrays of accessing items.
   self.accessed_upvalues = {}
   -- Maps variables to arrays of mutating items.
   self.mutated_upvalues = {}
   -- Maps variables to arays of setting items.
   self.set_upvalues = {}
   self.lines = {}
   self.node = node
   self.parent = parent
   self.value = value
   self.items = utils.Stack()
end

-- Calls callback with line, index, item, ... for each item reachable from starting item.
-- `visited` is a set of already visited indexes.
-- Callback can return true to stop walking from current item.
function Line:walk(visited, index, callback, ...)
   if visited[index] then
      return
   end

   visited[index] = true

   local item = self.items[index]

   if callback(self, index, item, ...) then
      return
   end

   if not item then
      return
   elseif item.tag == "Jump" then
      return self:walk(visited, item.to, callback, ...)
   elseif item.tag == "Cjump" then
      self:walk(visited, item.to, callback, ...)
   end

   return self:walk(visited, index + 1, callback, ...)
end

local function new_scope(line)
   return {
      vars = {},
      labels = {},
      gotos = {},
      line = line
   }
end

local function new_var(line, node, type_)
   return {
      name = node[1],
      node = node,
      type = type_,
      self = node.implicit,
      line = line,
      scope_start = line.items.size + 1,
      values = {}
   }
end

local function new_value(var_node, value_node, item, is_init)
   local value = {
      var = var_node.var,
      var_node = var_node,
      type = is_init and var_node.var.type or "var",
      node = value_node,
      using_lines = {},
      empty = is_init and not value_node and (var_node.var.type == "var"),
      item = item
   }

   if value_node and value_node.tag == "Function" then
      value.type = "func"
      value_node.value = value
   end

   return value
end

local function new_label(line, name, range)
   return {
      name = name,
      range = range,
      index = line.items.size + 1
   }
end

local function new_goto(name, jump, range)
   return {
      name = name,
      jump = jump,
      range = range
   }
end

local function new_jump_item(is_conditional)
   return {
      tag = is_conditional and "Cjump" or "Jump"
   }
end

local function new_eval_item(node)
   return {
      tag = "Eval",
      node = node,
      accesses = {},
      used_values = {},
      lines = {}
   }
end

local function new_noop_item(node, loop_end)
   return {
      tag = "Noop",
      node = node,
      loop_end = loop_end
   }
end

local function new_local_item(node)
   return {
      tag = "Local",
      node = node,
      lhs = node[1],
      rhs = node[2],
      accesses = node[2] and {},
      used_values = node[2] and {},
      lines = node[2] and {}
   }
end

local function new_set_item(node)
   return {
      tag = "Set",
      node = node,
      lhs = node[1],
      rhs = node[2],
      accesses = {},
      mutations = {},
      used_values = {},
      lines = {}
   }
end

local function is_unpacking(node)
   return node.tag == "Dots" or node.tag == "Call" or node.tag == "Invoke"
end

local LinState = utils.class()

function LinState:__init(chstate)
   self.chstate = chstate
   self.lines = utils.Stack()
   self.scopes = utils.Stack()
end

function LinState:enter_scope()
   self.scopes:push(new_scope(self.lines.top))
end

function LinState:leave_scope()
   local left_scope = self.scopes:pop()
   local prev_scope = self.scopes.top

   for _, goto_ in ipairs(left_scope.gotos) do
      local label = left_scope.labels[goto_.name]

      if label then
         goto_.jump.to = label.index
         label.used = true
      else
         if not prev_scope or prev_scope.line ~= self.lines.top then
            if goto_.name == "break" then
               parser.syntax_error("'break' is not inside a loop", goto_.range)
            else
               parser.syntax_error(("no visible label '%s'"):format(goto_.name), goto_.range)
            end
         end

         table.insert(prev_scope.gotos, goto_)
      end
   end

   for name, label in pairs(left_scope.labels) do
      if not label.used and not pseudo_labels[name] then
         warn_unused_label(self.chstate, label)
      end
   end

   for _, var in pairs(left_scope.vars) do
      var.scope_end = self.lines.top.items.size
   end
end

function LinState:register_var(node, type_)
   local var = new_var(self.lines.top, node, type_)
   local prev_var = self:resolve_var(var.name)

   if prev_var then
      local is_same_scope = self.scopes.top.vars[var.name]

      if var.name ~= "..." then
         warn_redefined(self.chstate, var, prev_var, is_same_scope)
      end

      if is_same_scope then
         prev_var.scope_end = self.lines.top.items.size
      end
   end

   self.scopes.top.vars[var.name] = var
   node.var = var
   return var
end

function LinState:register_vars(nodes, type_)
   for _, node in ipairs(nodes) do
      self:register_var(node, type_)
   end
end

function LinState:resolve_var(name)
   for _, scope in utils.ripairs(self.scopes) do
      local var = scope.vars[name]

      if var then
         return var
      end
   end
end

function LinState:check_var(node)
   if not node.var then
      node.var = self:resolve_var(node[1])
   end

   return node.var
end

function LinState:register_label(name, range)
   local prev_label = self.scopes.top.labels[name]

   if prev_label then
      assert(not pseudo_labels[name])
      parser.syntax_error(("label '%s' already defined on line %d"):format(
         name, prev_label.range.line), range, prev_label.range)
   end

   self.scopes.top.labels[name] = new_label(self.lines.top, name, range)
end

function LinState:emit(item)
   self.lines.top.items:push(item)
end

function LinState:emit_goto(name, is_conditional, range)
   local jump = new_jump_item(is_conditional)
   self:emit(jump)
   table.insert(self.scopes.top.gotos, new_goto(name, jump, range))
end

local tag_to_boolean = {
   Nil = false, False = false,
   True = true, Number = true, String = true, Table = true, Function = true
}

-- Emits goto that jumps to ::name:: if bool(cond_node) == false.
function LinState:emit_cond_goto(name, cond_node)
   local cond_bool = tag_to_boolean[cond_node.tag]

   if cond_bool ~= true then
      self:emit_goto(name, cond_bool ~= false)
   end
end

function LinState:emit_noop(node, loop_end)
   self:emit(new_noop_item(node, loop_end))
end

function LinState:emit_stmt(stmt)
   self["emit_stmt_" .. stmt.tag](self, stmt)
end

function LinState:emit_stmts(stmts)
   for _, stmt in ipairs(stmts) do
      self:emit_stmt(stmt)
   end
end

function LinState:emit_block(block)
   self:enter_scope()
   self:emit_stmts(block)
   self:leave_scope()
end

function LinState:emit_stmt_Do(node)
   self:emit_noop(node)
   self:emit_block(node)
end

function LinState:emit_stmt_While(node)
   self:emit_noop(node)
   self:enter_scope()
   self:register_label("do")
   self:emit_expr(node[1])
   self:emit_cond_goto("break", node[1])
   self:emit_block(node[2])
   self:emit_noop(node, true)
   self:emit_goto("do")
   self:register_label("break")
   self:leave_scope()
end

function LinState:emit_stmt_Repeat(node)
   self:emit_noop(node)
   self:enter_scope()
   self:register_label("do")
   self:enter_scope()
   self:emit_stmts(node[1])
   self:emit_expr(node[2])
   self:leave_scope()
   self:emit_cond_goto("do", node[2])
   self:register_label("break")
   self:leave_scope()
end

function LinState:emit_stmt_Fornum(node)
   self:emit_noop(node)
   self:emit_expr(node[2])
   self:emit_expr(node[3])

   if node[5] then
      self:emit_expr(node[4])
   end

   self:enter_scope()
   self:register_label("do")
   self:emit_goto("break", true)
   self:enter_scope()
   self:emit(new_local_item({{node[1]}}))
   self:register_var(node[1], "loopi")
   self:emit_stmts(node[5] or node[4])
   self:leave_scope()
   self:emit_noop(node, true)
   self:emit_goto("do")
   self:register_label("break")
   self:leave_scope()
end

function LinState:emit_stmt_Forin(node)
   self:emit_noop(node)
   self:emit_exprs(node[2])
   self:enter_scope()
   self:register_label("do")
   self:emit_goto("break", true)
   self:enter_scope()
   self:emit(new_local_item({node[1]}))
   self:register_vars(node[1], "loop")
   self:emit_stmts(node[3])
   self:leave_scope()
   self:emit_noop(node, true)
   self:emit_goto("do")
   self:register_label("break")
   self:leave_scope()
end

function LinState:emit_stmt_If(node)
   self:emit_noop(node)
   self:enter_scope()

   for i = 1, #node - 1, 2 do
      self:enter_scope()
      self:emit_expr(node[i])
      self:emit_cond_goto("else", node[i])
      self:emit_block(node[i + 1])
      self:emit_goto("end")
      self:register_label("else")
      self:leave_scope()
   end

   if #node % 2 == 1 then
      self:emit_block(node[#node])
   end

   self:register_label("end")
   self:leave_scope()
end

function LinState:emit_stmt_Label(node)
   self:register_label(node[1], node)
end

function LinState:emit_stmt_Goto(node)
   self:emit_noop(node)
   self:emit_goto(node[1], false, node)
end

function LinState:emit_stmt_Break(node)
   self:emit_goto("break", false, node)
end

function LinState:emit_stmt_Return(node)
   self:emit_noop(node)
   self:emit_exprs(node)
   self:emit_goto("return")
end

function LinState:emit_expr(node)
   local item = new_eval_item(node)
   self:scan_expr(item, node)
   self:emit(item)
end

function LinState:emit_exprs(exprs)
   for _, expr in ipairs(exprs) do
      self:emit_expr(expr)
   end
end

LinState.emit_stmt_Call = LinState.emit_expr
LinState.emit_stmt_Invoke = LinState.emit_expr

function LinState:emit_stmt_Local(node)
   local item = new_local_item(node)
   self:emit(item)

   if node[2] then
      self:scan_exprs(item, node[2])
   end

   self:register_vars(node[1], "var")
end

function LinState:emit_stmt_Localrec(node)
   local item = new_local_item(node)
   self:register_var(node[1][1], "var")
   self:emit(item)
   self:scan_expr(item, node[2][1])
end

function LinState:emit_stmt_Set(node)
   local item = new_set_item(node)
   self:scan_exprs(item, node[2])

   for _, expr in ipairs(node[1]) do
      if expr.tag == "Id" then
         local var = self:check_var(expr)

         if var then
            self:register_upvalue_action(item, var, "set_upvalues")
         end
      else
         assert(expr.tag == "Index")
         self:scan_lhs_index(item, expr)
      end
   end

   self:emit(item)
end


function LinState:scan_expr(item, node)
   local scanner = self["scan_expr_" .. node.tag]

   if scanner then
      scanner(self, item, node)
   end
end

function LinState:scan_exprs(item, nodes)
   for _, node in ipairs(nodes) do
      self:scan_expr(item, node)
   end
end

function LinState:register_upvalue_action(item, var, key)
   for _, line in utils.ripairs(self.lines) do
      if line == var.line then
         break
      end

      if not line[key][var] then
         line[key][var] = {}
      end

      table.insert(line[key][var], item)
   end
end

function LinState:mark_access(item, node)
   node.var.accessed = true

   if not item.accesses[node.var] then
      item.accesses[node.var] = {}
   end

   table.insert(item.accesses[node.var], node)
   self:register_upvalue_action(item, node.var, "accessed_upvalues")
end

function LinState:mark_mutation(item, node)
   node.var.mutated = true

   if not item.mutations[node.var] then
      item.mutations[node.var] = {}
   end

   table.insert(item.mutations[node.var], node)
   self:register_upvalue_action(item, node.var, "mutated_upvalues")
end

function LinState:scan_expr_Id(item, node)
   if self:check_var(node) then
      self:mark_access(item, node)
   end
end

function LinState:scan_expr_Dots(item, node)
   local dots = self:check_var(node)

   if not dots or dots.line ~= self.lines.top then
      parser.syntax_error("cannot use '...' outside a vararg function", node)
   end

   self:mark_access(item, node)
end

function LinState:scan_lhs_index(item, node)
   if node[1].tag == "Id" then
      if self:check_var(node[1]) then
         self:mark_mutation(item, node[1])
      end
   elseif node[1].tag == "Index" then
      self:scan_lhs_index(item, node[1])
   else
      self:scan_expr(item, node[1])
   end

   self:scan_expr(item, node[2])
end

LinState.scan_expr_Index = LinState.scan_exprs
LinState.scan_expr_Call = LinState.scan_exprs
LinState.scan_expr_Invoke = LinState.scan_exprs
LinState.scan_expr_Paren = LinState.scan_exprs
LinState.scan_expr_Table = LinState.scan_exprs
LinState.scan_expr_Pair = LinState.scan_exprs

function LinState:scan_expr_Op(item, node)
   self:scan_expr(item, node[2])

   if node[3] then
      self:scan_expr(item, node[3])
   end
end

-- Puts tables {var = value{} into field `set_variables` of items in line which set values.
-- Registers set values in field `values` of variables.
function LinState:register_set_variables()
   local line = self.lines.top

   for _, item in ipairs(line.items) do
      if item.tag == "Local" or item.tag == "Set" then
         item.set_variables = {}

         local is_init = item.tag == "Local"
         local unpacking_item -- Rightmost item of rhs which may unpack into several lhs items.

         if item.rhs then
            local last_rhs_item = item.rhs[#item.rhs]

            if is_unpacking(last_rhs_item) then
               unpacking_item = last_rhs_item
            end
         end

         local secondaries -- Array of values unpacked from rightmost rhs item.

         if unpacking_item and (#item.lhs > #item.rhs) then
            secondaries = {}
         end

         for i, node in ipairs(item.lhs) do
            local value

            if node.var then
               value = new_value(node, item.rhs and item.rhs[i] or unpacking_item, item, is_init)
               item.set_variables[node.var] = value
               table.insert(node.var.values, value)
            end

            if secondaries and (i >= #item.rhs) then
               if value then
                  value.secondaries = secondaries
                  table.insert(secondaries, value)
               else
                  -- If one of secondary values is assigned to a global or index,
                  -- it is considered used.
                  secondaries.used = true
               end
            end
         end
      end
   end
end

function LinState:build_line(node)
   self.lines:push(Line(node, self.lines.top))
   self:enter_scope()
   self:emit(new_local_item({node[1]}))
   self:enter_scope()
   self:register_vars(node[1], "arg")
   self:emit_stmts(node[2])
   self:leave_scope()
   self:register_label("return")
   self:leave_scope()
   self:register_set_variables()
   local line = self.lines:pop()

   for _, prev_line in ipairs(self.lines) do
      table.insert(prev_line.lines, line)
   end

   return line
end

function LinState:scan_expr_Function(item, node)
   local line = self:build_line(node)
   table.insert(item.lines, line)

   for _, nested_line in ipairs(line.lines) do
      table.insert(item.lines, nested_line)
   end
end

-- Builds linear representation (line) of AST and assigns it as `chstate.top_line`.
-- Assings an array of all lines as `chstate.lines`.
-- Adds warnings for redefined/shadowed locals and unused labels.
function stage.run(chstate)
   local linstate = LinState(chstate)
   chstate.top_line = linstate:build_line({{{tag = "Dots", "..."}}, chstate.ast})
   assert(linstate.lines.size == 0)
   assert(linstate.scopes.size == 0)

   chstate.lines = {chstate.top_line}

   for _, nested_line in ipairs(chstate.top_line.lines) do
      table.insert(chstate.lines, nested_line)
   end
end

return stage
