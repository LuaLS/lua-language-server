local ltask = require "ltask"
local root = require "ltask.root"

local config = ...

local SERVICE_SYSTEM <const> = 0

local MESSAGE_ERROR <const> = 3

local MESSAGE_SCHEDULE_NEW <const> = 0
local MESSAGE_SCHEDULE_DEL <const> = 1

local RECEIPT_ERROR <const> = 2
local RECEIPT_BLOCK <const> = 3
local RECEIPT_RESPONCE <const> = 4

local S = {}

local anonymous_services = {}
local named_services = {}

local root_quit = ltask.quit
ltask.quit = function() end

local function writelog()
	while true do
		local ti, _, msg, sz = ltask.poplog()
		if ti == nil then
			break
		end
		local tsec = ti // 100
		local msec = ti % 100
		local level, message = ltask.unpack_remove(msg, sz)
		io.write(string.format("[%s.%02d][%-5s]%s\n", os.date("%Y-%m-%d %H:%M:%S", tsec), msec, level:upper(), message))
	end
end

do
	-- root init response to itself
	local function init_receipt(type, session, msg, sz)
		if type == MESSAGE_ERROR then
			local errobj = ltask.unpack_remove(msg, sz)
			ltask.log.error("Root fatal:", table.concat(errobj, "\n"))
			writelog()
			root_quit()
		end
	end

	-- The session of root init message must be 1
	ltask.suspend(1, coroutine.create(init_receipt))
end

local retry_queue

local function send_retry_queue(addr, queue)
	local n = #queue
	for i = 1, n do
		local type = ltask.post_message(addr, table.unpack(queue[i]))
		if type == RECEIPT_BLOCK then
			table.move(queue, i, n, 1)
			return true
		elseif type == RECEIPT_ERROR then
			for j = i, n do
				local msg, sz = queue[j][3], queue[j][4]
				ltask.remove(msg, sz)
			end
			return
		end
	end
end

local function send_all_retry()
	while true do
		local removed = {}
		for addr, queue in pairs(retry_queue) do
			if not send_retry_queue(addr, queue) then
				removed[addr] = true
			end
		end
		for addr in pairs(removed) do
			retry_queue[addr] = nil
		end
		if next(retry_queue) == nil then
			break
		end
		ltask.sleep(1)
	end
	retry_queue = nil
end

function S.send_retry(addr, session, type, ...)
	local message = { session, type, ltask.pack(...) }
	if retry_queue then
		local q = retry_queue[addr]
		if q then
			q[#q+1] = message
		else
			retry_queue[addr] = { message }
		end
	else
		retry_queue = {
			[addr] = { message },
		}
		ltask.fork(send_all_retry)
	end
end

local function register_service(address, name)
	if named_services[name] then
		error(("Name `%s` already exists."):format(name))
	end
	anonymous_services[address] = nil
	named_services[#named_services+1] = name
	named_services[name] = address
	ltask.multi_wakeup("unique."..name, address)
end

local function spawn(t)
	local type, address = ltask.post_message(SERVICE_SYSTEM, 0, MESSAGE_SCHEDULE_NEW)
	if type ~= RECEIPT_RESPONCE then
		-- RECEIPT_ERROR
		error("send MESSAGE_SCHEDULE_NEW failed.")
	end
	anonymous_services[address] = true
	assert(root.init_service(address, t.name, config.service_source, config.service_chunkname, t.worker_id))
	ltask.syscall(address, "init", {
		initfunc = t.initfunc or config.initfunc,
		name = t.name,
		args = t.args or {},
	})
	return address
end

local unique = {}

local function spawn_unique(t)
	local address = named_services[t.name]
	if address then
		return address
	end
	local key = "unique."..t.name
	if not unique[t.name] then
		unique[t.name] = true
		ltask.fork(function ()
			local ok, addr = pcall(spawn, t)
			if not ok then
				local err = addr
				ltask.multi_interrupt(key, err)
				unique[t.name] = nil
				return
			end
			register_service(addr, t.name)
			unique[t.name] = nil
		end)
	end
	return ltask.multi_wait(key)
end

function S.tracelog(timeout)
	local tlog = {}
	local tasks = {}
	local n = 1
	for addr in pairs(anonymous_services) do
		tasks[n] = { ltask.syscall, addr, "traceback" , addr = addr } ; n = n + 1
		tlog[addr] = {}
	end
	for _, name in ipairs(named_services) do
		local addr = named_services[name]
		tasks[n] = { ltask.syscall, addr, "traceback" , addr = addr, name = name } ; n = n + 1
		tlog[addr] = { name = name }
	end
	if timeout then
		tasks[n] = { ltask.sleep, timeout }
	end

	for req, resp in ltask.parallel(tasks) do
		if not req.addr then
			-- timeout
			break
		end
		if not resp.error then
			tlog[req.addr].traceback = resp[1]
		else
			tlog[req.addr].error = resp.error
		end
	end

	return tlog
end

function S.spawn(name, ...)
	return spawn {
		name = name,
		args = {...},
	}
end

function S.queryservice(name)
	local address = named_services[name]
	if address then
		return address
	end
	return ltask.multi_wait("unique."..name)
end

function S.uniqueservice(name, ...)
	return spawn_unique {
		name = name,
		args = {...},
	}
end

function S.spawn_service(t)
	if t.unique then
		return spawn_unique(t)
	else
		return spawn(t)
	end
end

local function del_service(address)
	if anonymous_services[address] then
		anonymous_services[address] = nil
	else
		for _, name in ipairs(named_services) do
			if named_services[name] == address then
				break
			end
		end
	end
	local msg = root.close_service(address)
	ltask.post_message(SERVICE_SYSTEM, address, MESSAGE_SCHEDULE_DEL)
	if msg then
		local err = "Service " .. address .. " has been quit."
		for i=1, #msg, 2 do
			local addr = msg[i]
			local session = msg[i+1]
			ltask.rasie_error(addr, session, err)
		end
	end
end

function S.quit_ltask()
	ltask.signal_handler(del_service)
	for i = #named_services, 1, -1 do
		local name = named_services[i]
		local address = named_services[name]
		local ok, err = pcall(ltask.syscall, address, "quit")
		if not ok then
			print(string.format("named service %s(%d) quit error: %s.", name, address, err))
		end
	end
	writelog()
	root_quit()
end

local function quit()
	if next(anonymous_services) ~= nil then
		return
	end
	ltask.send(ltask.self(), "quit_ltask")
end

local function signal_handler(from)
	del_service(from)
	quit()
end

ltask.signal_handler(signal_handler)

local function bootstrap()
	for _, t in ipairs(config.bootstrap) do
		S.spawn_service(t)
	end
end

ltask.dispatch(S)

bootstrap()
quit()
