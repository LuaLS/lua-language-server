--------------------------------------------------------------------------------
-- Lua programming with types
--------------------------------------------------------------------------------

local _, inspect = pcall(require, "inspect")
inspect = inspect or tostring

local typed = {}

local FAST = false

local function is_sequence(xs)
   if type(xs) ~= "table" then
      return false
   end
   if FAST then
      return true
   end
   local l = #xs
   for k, _ in pairs(xs) do
      if type(k) ~= "number" or k < 1 or k > l or math.floor(k) ~= k then
         return false
      end
   end
   return true
end

local function type_of(t)
   local mt = getmetatable(t)
   return (mt and mt.__name) or (is_sequence(t) and "array") or type(t)
end

local function set_type(t, typ)
   local mt = getmetatable(t)
   if not mt then
      mt = {}
   end
   mt.__name = typ
   return setmetatable(t, mt)
end

local function typed_table(typ, t)
   return set_type(t, typ)
end

local function try_check(val, expected)
   local optional = expected:match("^(.*)%?$")
   if optional then
      if val == nil then
         return true
      end
      expected = optional
   end

   local seq_type = expected:match("^{(.+)}$")
   if seq_type then
      if type(val) == "table" then
         if FAST then
            return true
         end
         local allok = true
         for _, v in ipairs(val) do
            local ok = try_check(v, seq_type)
            if not ok then
               allok = false
               break
            end
         end
         if allok then
            return true
         end
      end
   end

   -- if all we want is a table, don't perform further checks
   if expected == "table" and type(val) == "table" then
      return true
   end

   local actual = type_of(val)
   if actual == expected then
      return true
   end
   return nil, actual
end

local function typed_check(val, expected, category, n)
   local ok, actual = try_check(val, expected)
   if ok then
      return true
   end
   if category and n then
      error(("type error: %s %d: expected %s, got %s (%s)"):format(category, n, expected, actual, inspect(val)), category == "value" and 2 or 3)
   else
      error(("type error: expected %s, got %s (%s)"):format(expected, actual, inspect(val)), 2)
   end
end

local function split(s, sep)
   local i, j, k = 1, s:find(sep, 1)
   local out = {}
   while j do
      table.insert(out, s:sub(i, j - 1))
      i = k + 1
      j, k = s:find(sep, i)
   end
   table.insert(out, s:sub(i, #s))
   return out
end

local function typed_function(types, fn)
   local inp, outp = types:match("(.*[^%s])%s*%->%s*([^%s].*)")
   local ins = split(inp, ",%s*")
   local outs = split(outp, ",%s*")
   return function(...)
      local args = table.pack(...)
      if args.n ~= #ins then
         error("wrong number of inputs (given " .. args.n .. " - expects " .. types .. ")", 2)
      end
      for i = 1, #ins do
         typed_check(args[i], ins[i], "argument", i)
      end
      local rets = table.pack(fn(...))
      if outp == "()" then
         if rets.n ~= 0 then
            error("wrong number of outputs (given " .. rets.n .. " - expects " .. types .. ")", 2)
         end
      else
         if rets.n ~= #outs then
            error("wrong number of outputs (given " .. rets.n .. " - expects " .. types .. ")", 2)
         end
         if outs[1] ~= "*" then
            for i = 1, #outs do
               typed_check(rets[i], outs[i], "return", i)
            end
         end
      end
      return table.unpack(rets, 1, rets.n)
   end
end

local typed_mt_on = {
   __call = function(_, types, fn)
       return typed_function(types, fn)
   end
}

local typed_mt_off = {
   __call = function(_, _, fn)
       return fn
   end
}

function typed.on()
   typed.check = typed_check
   typed.typed = typed_function
   typed.set_type = set_type
   typed.table = typed_table
   setmetatable(typed, typed_mt_on)
end

function typed.off()
   typed.check = function() end
   typed.typed = function(_, fn) return fn end
   typed.set_type = function(t, _) return t end
   typed.table = function(_, t) return t end
   setmetatable(typed, typed_mt_off)
end

typed.off()

return typed
