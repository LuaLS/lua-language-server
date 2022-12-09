local utils = require "luacheck.utils"

local multithreading = {}

local lanes_ok, lanes = pcall(require, "lanes")
lanes_ok = lanes_ok and pcall(lanes.configure)
multithreading.has_lanes = lanes_ok
multithreading.lanes = lanes
multithreading.default_jobs = 1

if not lanes_ok then
   return multithreading
end

local cpu_number_detection_commands = {}

if utils.is_windows then
   cpu_number_detection_commands[1] = "echo %NUMBER_OF_PROCESSORS%"
else
   cpu_number_detection_commands[1] = "getconf _NPROCESSORS_ONLN 2>&1"
   cpu_number_detection_commands[2] = "sysctl -n hw.ncpu 2>&1"
   cpu_number_detection_commands[3] = "psrinfo -p 2>&1"
end

for _, command in ipairs(cpu_number_detection_commands) do
   local handler = io.popen(command)

   if handler then
      local output = handler:read("*a")
      handler:close()

      if output then
         local cpu_number = tonumber(utils.strip(output))

         if cpu_number then
            multithreading.default_jobs = math.floor(math.max(cpu_number, 1))
            break
         end
      end
   end
end

-- Reads pairs {key, arg} from given linda slot until it gets nil as arg.
-- Returns table with pairs [key] = func(arg).
local function worker_task(linda, input_slot, func)
   local results = {}

   while true do
      local _, pair = linda:receive(nil, input_slot)
      local key, arg = pair[1], pair[2]

      if arg == nil then
         return results
      end

      results[key] = func(arg)
   end
end

local function protected_worker_task(...)
   return true, utils.try(worker_task, ...)
end

local worker_gen = lanes.gen("*", protected_worker_task)

-- Maps func over array, performing at most jobs calls in parallel.
function multithreading.pmap(func, array, jobs)
   jobs = jobs or multithreading.default_jobs
   jobs = math.min(jobs, #array)

   if jobs < 2 then
      return utils.map(func, array)
   end

   local workers = {}
   local linda = lanes.linda()

   for i = 1, jobs do
      workers[i] = worker_gen(linda, 0, func)
   end

   for i, item in ipairs(array) do
      linda:send(nil, 0, {i, item})
   end

   for _ = 1, jobs do
      linda:send(nil, 0, {})
   end

   local results = {}

   for _, worker in ipairs(workers) do
      local _, ok, worker_results = assert(worker:join())

      if ok then
         utils.update(results, worker_results)
      else
         error(worker_results, 0)
      end
   end

   return results
end

return multithreading
