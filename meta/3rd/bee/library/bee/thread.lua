---@meta

---@class bee.rpc:lightuserdata

---@class bee.thread_obj:lightuserdata

---@class bee.channel
local channel = {}

function channel:push(...)
end

---@return boolean ok
---@return ...
function channel:pop()
end

---@return ...
function channel:bpop()
end

---@class bee.thread
local m = {}

function m.sleep(sec)
end

---@return bee.thread_obj
function m.thread(source, params)
end

function m.newchannel(name)
end

---@return bee.channel
function m.channel(name)
end

function m.reset()
end

---@param th bee.thread_obj
function m.wait(th)
end

function m.setname(name)
end

---@return bee.rpc
function m.rpc_create()
end

function m.rpc_wait(rpc)
end

function m.rpc_return(rpc)
end

function m.preload_module()
end

return m
