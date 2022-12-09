-- Require luasocket only when needed.
local socket

local profiler = {}

local metrics = {
   {name = "Wall", get = function() return socket.gettime() end},
   {name = "CPU", get = os.clock},
   {name = "Memory", get = function() return collectgarbage("count") end}
}

local functions = {
   {name = "sha1", module = "vendor.sha1"},
   {name = "load", module = "cache"},
   {name = "update", module = "cache"},
   {name = "decode", module = "decoder"},
   {name = "parse", module = "parser"},
   {name = "dump_check_result", module = "serializer"},
   {name = "load_check_result", module = "serializer"},
   {name = "run", module = "stages.unwrap_parens"},
   {name = "run", module = "stages.parse_inline_options"},
   {name = "run", module = "stages.linearize"},
   {name = "run", module = "stages.name_functions"},
   {name = "run", module = "stages.resolve_locals"},
   {name = "run", module = "stages.detect_bad_whitespace"},
   {name = "run", module = "stages.detect_cyclomatic_complexity"},
   {name = "run", module = "stages.detect_empty_blocks"},
   {name = "run", module = "stages.detect_empty_statements"},
   {name = "run", module = "stages.detect_globals"},
   {name = "run", module = "stages.detect_reversed_fornum_loops"},
   {name = "run", module = "stages.detect_unbalanced_assignments"},
   {name = "run", module = "stages.detect_uninit_accesses"},
   {name = "run", module = "stages.detect_unreachable_code"},
   {name = "run", module = "stages.detect_unused_fields"},
   {name = "run", module = "stages.detect_unused_locals"},
   {name = "filter", module = "filter"},
   {name = "normalize", module = "options"}
}

local stats = {}
local start_values = {}

local function start_phase(name)
   for _, metric in ipairs(metrics) do
      start_values[metric][name] = metric.get()
   end
end

local function stop_phase(name)
   for _, metric in ipairs(metrics) do
      local increment = metric.get() - start_values[metric][name]
      stats[metric][name] = (stats[metric][name] or 0) + increment
   end
end

local phase_stack = {}

local function push_phase(name)
   local prev_name = phase_stack[#phase_stack]

   if prev_name then
      stop_phase(prev_name)
   end

   table.insert(phase_stack, name)
   start_phase(name)
end

local function pop_phase(name)
   assert(name == table.remove(phase_stack))
   stop_phase(name)
   local prev_name = phase_stack[#phase_stack]

   if prev_name then
      start_phase(prev_name)
   end
end

local function continue_wrapper(name, ...)
   pop_phase(name)
   return ...
end

local function wrap(fn, name)
   return function(...)
      push_phase(name)
      return continue_wrapper(name, fn(...))
   end
end

local function patch(fn)
   local mod = require("luacheck." .. fn.module)
   local orig = mod[fn.name]
   local new = wrap(orig, fn.module .. "." .. fn.name)
   mod[fn.name] = new
end

function profiler.init()
   socket = require "socket"
   collectgarbage("stop")

   for _, metric in ipairs(metrics) do
      stats[metric] = {}
      start_values[metric] = {}
   end

   for _, fn in ipairs(functions) do
      patch(fn)
   end

   push_phase("other")
end

function profiler.report()
   pop_phase("other")

   for _, metric in ipairs(metrics) do
      local names = {}
      local total = 0

      for name, value in pairs(stats[metric]) do
         table.insert(names, name)
         total = total + value
      end

      table.sort(names, function(name1, name2)
         local stats1 = stats[metric][name1]
         local stats2 = stats[metric][name2]

         if stats1 ~= stats2 then
            return stats1 > stats2
         else
            return name1 < name2
         end
      end)

      print(metric.name)
      print()

      for _, name in ipairs(names) do
         print(("%s - %f (%f%%)"):format(name, stats[metric][name], stats[metric][name] / total * 100))
      end

      print(("Total - %f"):format(total))
      print()
   end
end

return profiler
