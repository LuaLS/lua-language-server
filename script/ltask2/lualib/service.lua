local SERVICE_ROOT <const> = 1

local MESSAGE_SYSTEM <const> = 0
local MESSAGE_REQUEST <const> = 1
local MESSAGE_RESPONSE <const> = 2
local MESSAGE_ERROR <const> = 3
local MESSAGE_SIGNAL <const> = 4
local MESSAGE_IDLE <const> = 5

local RECEIPT_DONE <const> = 1
local RECEIPT_ERROR <const> = 2
local RECEIPT_BLOCK <const> = 3

local SESSION_SEND_MESSAGE <const> = 0

local ltask = require "ltask"

local CURRENT_SERVICE <const> = ltask.self()
local CURRENT_SERVICE_LABEL <const> = ltask.label()

ltask.log = {}
for _, level in ipairs {"info","error"} do
	ltask.log[level] = function (...)
		local t = table.pack(...)
		local str = {}
		for i = 1, t.n do
			str[#str+1] = tostring(t[i])
		end
		local message = string.format("( %s ) %s", CURRENT_SERVICE_LABEL, table.concat(str, "\t"))
		ltask.pushlog(ltask.pack(level, message))
	end
end

ltask.log.info ( "startup " .. CURRENT_SERVICE )

local yield_service = coroutine.yield
local yield_session = coroutine.yield
local function continue_session()
	coroutine.yield(true)
end

local running_thread

local session_coroutine_suspend_lookup = {}
local session_coroutine_response = {}
local session_coroutine_address = {}
local session_id = 2	-- 1 is reserved for root

local session_waiting = {}
local wakeup_queue = {}

----- error handling ------

local error_mt = {}
function error_mt:__tostring()
	return table.concat(self, "\n")
end

local traceback, create_traceback; do
	local selfsource <const> = debug.getinfo(1, "S").source
	local function getshortsrc(source)
		local maxlen <const> = 60
		local type = source:byte(1)
		if type == 61 --[['=']] then
			if #source <= maxlen then
				return source:sub(2)
			else
				return source:sub(2, maxlen)
			end
		elseif type == 64 --[['@']] then
			if #source <= maxlen then
				return source:sub(2)
			else
				return '...' .. source:sub(#source - maxlen + 5)
			end
		else
			local nl = source:find '\n'
			local maxlen <const> = maxlen - 15
			if #source < maxlen and nl == nil then
				return ('[string "%s"]'):format(source)
			else
				local n = #source
				if nl ~= nil then
					n = nl - 1
				end
				if n > maxlen then
					n = maxlen
				end
				return ('[string "%s..."]'):format(source:sub(1, n))
			end
		end
	end
	local function findfield(t, f, level)
		if level == 0 or type(t) ~= 'table' then
			return
		end
		for key, value in pairs(t) do
			if type(key) == 'string' and not (level == 2 and key == '_G') then
				if value == f then
					return key
				end
				local res = findfield(value, f, level - 1)
				if res then
					return key .. '.' .. res
				end
			end
		end
	end
	local function pushglobalfuncname(f)
		return findfield(_G, f, 2)
	end
	local function pushfuncname(info)
		local funcname = pushglobalfuncname(info.func)
		if funcname then
			return ("function '%s'"):format(funcname)
		elseif info.namewhat ~= '' then
			return ("%s '%s'"):format(info.namewhat, info.name)
		elseif info.what == 'main' then
			return 'main chunk'
		elseif info.what ~= 'C' then
			return ('function <%s:%d>'):format(getshortsrc(info.source), info.linedefined)
		else
			return '?'
		end
	end
	function create_traceback(co, level)
		local s = {}
		local depth = level or 0
		while true do
			local info = co and debug.getinfo(co, depth, "Slntf")
							or debug.getinfo(depth, "Slntf")
			if not info then
				s[#s] = nil
				break
			end
			if #s > 0 and selfsource == info.source then
				goto continue
			end
			s[#s + 1] = ('\t%s:'):format(getshortsrc(info.source))
			if info.currentline > 0 then
				s[#s + 1] = ('%d:'):format(info.currentline)
			end
			s[#s + 1] = " in "
			s[#s + 1] = pushfuncname(info)
			if info.istailcall then
				s[#s + 1] = '\n\t(...tail calls...)'
			end
			s[#s + 1] = "\n"
			::continue::
			depth = depth + 1
		end
		return table.concat(s)
	end
	local function replacewhere(co, message, level)
		local f, l = message:find ':[-%d]+: '
		if f and l then
			local where_path = message:sub(1, f - 1)
			local where_line = tonumber(message:sub(f + 1, l - 2))
			local where_src = "@"..where_path
			message = message:sub(l + 1)
			local depth = level or 0
			while true do
				local info = debug.getinfo(co, depth, "Sl")
				if not info then
					break
				end
				if info.what ~= 'C' and info.source == where_src and where_line == info.currentline then
					return message, depth
				end
				depth = depth + 1
			end
		end
		return message, level
	end
	function traceback(errobj, where)
		if type(where) == "string" then
			if type(errobj) ~= "table" then
				local message = tostring(errobj)
				local level = 0
				errobj = {
					message,
					"stack traceback:",
					("\t( service:%d )"):format(CURRENT_SERVICE),
					where,
					level = level,
				}
			end
			errobj[#errobj+1] = ("\t( service:%d )"):format(CURRENT_SERVICE)
			errobj[#errobj+1] = where
			setmetatable(errobj, error_mt)
			return errobj
		end
		local co, level
		if type(where) == "thread" then
			co = where
		else
			co = running_thread
			level = where
		end
		if type(errobj) ~= "table" then
			local message
			message, level = replacewhere(co, tostring(errobj), level)
			errobj = {
				message,
				"stack traceback:",
				level = level,
			}
		end
		errobj[#errobj+1] = ("\t( service:%d )"):format(CURRENT_SERVICE)
		errobj[#errobj+1] = create_traceback(co, level or errobj.level)
		setmetatable(errobj, error_mt)
		return errobj
	end
end

local function rethrow_error(level, errobj)
	if type(errobj) ~= "table" then
		error(errobj, level + 1)
	else
		errobj.level = level + 1
		setmetatable(errobj, error_mt)
		error(errobj)
	end
end

function ltask.post_message(addr, session, type, msg, sz)
	ltask.send_message(addr, session, type, msg, sz)
	continue_session()
	return ltask.message_receipt()
end

local function send_blocked_message(addr, session, type, ...)
	local msg, sz = ltask.pack("send_retry", addr, session, type, ...)
	while true do
		local receipt_type = ltask.post_message(SERVICE_ROOT, SESSION_SEND_MESSAGE, MESSAGE_REQUEST, msg, sz)
		if receipt_type == RECEIPT_DONE then
			break
		elseif receipt_type == RECEIPT_BLOCK then
			ltask.sleep(1)
		else
			-- error (root quit?)
			ltask.remove(msg, sz)
			break
		end
	end
end

local function post_request_message(addr, session, type, msg, sz)
	local receipt_type, receipt_msg, receipt_sz = ltask.post_message(addr, session, type, msg, sz)
	if receipt_type == RECEIPT_DONE then
		return
	end
	if receipt_type == RECEIPT_ERROR then
		ltask.remove(receipt_msg, receipt_sz)
		if session ~= SESSION_SEND_MESSAGE then
			error(string.format("{service:%d} is dead", addr))
		end
	else
		--RECEIPT_BLOCK
		-- todo: send again
		ltask.remove(receipt_msg, receipt_sz)
		error(string.format("{service:%d} is busy", addr))
	end
end

local function post_response_message(addr, session, type, msg, sz)
	local receipt_type, receipt_msg, receipt_sz = ltask.post_message(addr, session, type, msg, sz)
	if receipt_type == RECEIPT_DONE then
		return
	end
	if receipt_type == RECEIPT_ERROR then
		ltask.remove(receipt_msg, receipt_sz)
	else
		--RECEIPT_BLOCK
		ltask.fork(function ()
			send_blocked_message(addr, session, type, ltask.unpack_remove(receipt_msg, receipt_sz))
		end)
	end
end

function ltask.rasie_error(addr, session, message)
	if session == SESSION_SEND_MESSAGE then
		return
	end
	local errobj = traceback(message, 4)
	post_response_message(addr, session, MESSAGE_ERROR, ltask.pack(errobj))
end

local function resume_session(co, ...)
	running_thread = co
	local ok, errobj = coroutine.resume(co, ...)
	running_thread = nil
	if ok then
		return errobj
	else
		local from = session_coroutine_address[co]
		local session = session_coroutine_response[co]

		-- term session
		session_coroutine_address[co] = nil
		session_coroutine_response[co] = nil

		errobj = traceback(errobj, co)
		if from == nil or from == 0 or session == SESSION_SEND_MESSAGE then
			ltask.log.error(tostring(errobj))
		else
			post_response_message(from, session, MESSAGE_ERROR, ltask.pack(errobj))
		end
		coroutine.close(co)
	end
end

local function wakeup_session(co, ...)
	local cont = resume_session(co, ...)
	while cont do
		yield_service()
		cont = resume_session(co)
	end
end

local coroutine_pool = setmetatable({}, { __mode = "kv" })

local function new_thread(f)
	local co = table.remove(coroutine_pool)
	if co == nil then
		co = coroutine.create(function(...)
			f(...)
			while true do
				f = nil
				coroutine_pool[#coroutine_pool+1] = co
				f = coroutine.yield()
				f(coroutine.yield())
			end
		end)
	else
		coroutine.resume(co, f)
	end
	return co
end

local function new_session(f, from, session)
	local co = new_thread(f)
	session_coroutine_address[co] = from
	session_coroutine_response[co] = session
	return co
end

local SESSION = {}

local function send_response(...)
	local session = session_coroutine_response[running_thread]

	if session ~= SESSION_SEND_MESSAGE then
		local from = session_coroutine_address[running_thread]
		post_response_message(from, session, MESSAGE_RESPONSE, ltask.pack(...))
	end

	-- End session
	session_coroutine_address[running_thread] = nil
	session_coroutine_response[running_thread] = nil
end

------------- ltask lua api

function ltask.suspend(session, co)
	session_coroutine_suspend_lookup[session] = co
end

function ltask.call(address, ...)
	post_request_message(address, session_id, MESSAGE_REQUEST, ltask.pack(...))
	session_coroutine_suspend_lookup[session_id] = running_thread
	session_id = session_id + 1
	local type, session, msg, sz = yield_session()
	if type == MESSAGE_RESPONSE then
		return ltask.unpack_remove(msg, sz)
	else
		-- type == MESSAGE_ERROR
		rethrow_error(2, ltask.unpack_remove(msg, sz))
	end
end

do	-- async object
	local async = {}	; async.__index = async

	local function still_session(obj, session)
		local s = obj._sessions
		s[session] = nil
		return next(s)
	end

	function ltask.async()
		local obj
		local function wait_func(type, session, msg, sz)
			-- ignore type
			ltask.unpack_remove(msg, sz)
			while still_session(obj, session) do
				type, session, msg, sz = yield_session()
				ltask.unpack_remove(msg, sz)
			end

			if obj._wakeup then
				ltask.wakeup(obj._wakeup)
			end
			return wait_func(yield_session())
		end

		obj = {
			_sessions = {},
			_wait = new_thread(wait_func),
		}
		return setmetatable(obj, async)
	end

	function async:request(address, ...)
		post_request_message(address, session_id, MESSAGE_REQUEST, ltask.pack(...))
		session_coroutine_suspend_lookup[session_id] = self._wait
		self._sessions[session_id] = true
		session_id = session_id + 1
	end

	function async:wait()
		if next(self._sessions) then
			if not self._wakeup then
				self._wakeup = self
				ltask.wait(self)
			end
		end
		self._wakeup = nil
	end
end

function ltask.send(address, ...)
	post_request_message(address, SESSION_SEND_MESSAGE, MESSAGE_REQUEST, ltask.pack(...))
end

function ltask.syscall(address, ...)
	post_request_message(address, session_id, MESSAGE_SYSTEM, ltask.pack(...))
	session_coroutine_suspend_lookup[session_id] = running_thread
	session_id = session_id + 1
	local type, session,  msg, sz = yield_session()
	if type == MESSAGE_RESPONSE then
		return ltask.unpack_remove(msg, sz)
	else
		-- type == MESSAGE_ERROR
		rethrow_error(2, ltask.unpack_remove(msg, sz))
	end
end

function ltask.sleep(ti)
	session_coroutine_suspend_lookup[session_id] = running_thread
	if ti == 0 then
		if RECEIPT_DONE ~= ltask.post_message(CURRENT_SERVICE, session_id, MESSAGE_RESPONSE) then
			ltask.timer_add(session_id, 0)
		end
	else
		ltask.timer_add(session_id, ti)
	end
	session_id = session_id + 1
	yield_session()
end

function ltask.thread_info(thread)
	local v = {}
	v[".name"] = debug.getinfo(thread, 1, "n")
	local index = 1
	while true do
		local name, value = debug.getlocal(thread, 1, index)
		if name then
			v[name] = value
		else
			break
		end
		index = index + 1
	end
	return v
end

function ltask.timeout(ti, func)
	local co = new_thread(func)
	session_coroutine_suspend_lookup[session_id] = co
	if ti == 0 then
		if RECEIPT_DONE ~= ltask.post_message(CURRENT_SERVICE, session_id, MESSAGE_RESPONSE) then
			ltask.timer_add(session_id, 0)
		end
	else
		ltask.timer_add(session_id, ti)
	end
	session_id = session_id + 1
end

local function wait_interrupt(errobj)
	rethrow_error(3, errobj)
end

local function wait_response(type, ...)
	if type == MESSAGE_RESPONSE then
		return ...
	else -- type == MESSAGE_ERROR
		wait_interrupt(...)
	end
end

function ltask.wait(token)
	token = token or running_thread
	assert(session_waiting[token] == nil)
	session_waiting[token] = running_thread
	session_id = session_id + 1
	return wait_response(yield_session())
end

function ltask.multi_wait(token)
	token = token or running_thread
	local thr = session_waiting[token]
	if thr then
		thr[#thr+1] = running_thread
	else
		session_waiting[token] = { running_thread }
	end
	session_id = session_id + 1
	return wait_response(yield_session())
end

function ltask.wakeup(token, ...)
	local co = session_waiting[token]
	if co then
		wakeup_queue[#wakeup_queue+1] = {co, MESSAGE_RESPONSE, ...}
		session_waiting[token] = nil
		return true
	end
end

function ltask.multi_wakeup(token, ...)
	local co = session_waiting[token]
	if co then
		local n = #wakeup_queue
		for i = 1, #co do
			wakeup_queue[n+i] = {co[i], MESSAGE_RESPONSE, ...}
		end
		session_waiting[token] = nil
		return true
	end
end

function ltask.interrupt(token, errobj)
	local co = session_waiting[token]
	if co then
		errobj = traceback(errobj, 4)
		wakeup_queue[#wakeup_queue+1] = {co, MESSAGE_ERROR, errobj}
		session_waiting[token] = nil
		return true
	end
end

function ltask.multi_interrupt(token, errobj)
	local co = session_waiting[token]
	if co then
		errobj = traceback(errobj, 4)
		local n = #wakeup_queue
		for i = 1, #co do
			wakeup_queue[n+i] = {co[i], MESSAGE_ERROR, errobj}
		end
		session_waiting[token] = nil
		return true
	end
end

function ltask.fork(func, ...)
	local co = new_thread(func)
	wakeup_queue[#wakeup_queue+1] = {co, ...}
end

function ltask.current_session()
	local from = session_coroutine_address[running_thread]
	local session = session_coroutine_response[running_thread]
	return { from = from, session = session }
end

function ltask.no_response()
	session_coroutine_response[running_thread] = nil
end

function ltask.spawn(name, ...)
    return ltask.call(SERVICE_ROOT, "spawn", name, ...)
end

function ltask.queryservice(name)
    return ltask.call(SERVICE_ROOT, "queryservice", name)
end

function ltask.uniqueservice(name, ...)
    return ltask.call(SERVICE_ROOT, "uniqueservice", name, ...)
end

function ltask.spawn_service(name, ...)
    return ltask.call(SERVICE_ROOT, "spawn_service", name, ...)
end

function ltask.parallel(task)
	local n = #task
	if n == 0 then
		return function () end
	end
	local ret_head = 0
	local ret_tail = 0
	local ret = {}
	local token
	local function rethrow(res)
		rethrow_error(2, res.error)
	end
	local function resp(t, ok, ...)
		local res = {}
		if ok then
			res = table.pack(...)
		else
			res.error = ...
			res.rethrow = rethrow
		end
		ret_tail = ret_tail + 1
		ret[ret_tail] = { t, res }
		if token then
			ltask.wakeup(token)
			token = nil
		end
	end
	local idx = 1
	local supervisor_running = false
	local run_task	-- function
	local function next_task()
		local i = idx
		idx = idx + 1
		local t = task[i]
		if t then
			run_task(t)
		end
	end
	local function run_supervisor()
		supervisor_running = false	-- only one supervisor
		next_task()
	end
	local function error_handler(errobj)
		return traceback(errobj, 4)
	end
	function run_task(t)
		if not supervisor_running then
			supervisor_running = true
			ltask.fork(run_supervisor)
		end
		resp(t, xpcall(t[1], error_handler, table.unpack(t, 2)))
		next_task()
	end
	ltask.fork(next_task)
	return function()
		if ret_tail == n and ret_head == ret_tail then
			return
		end
		while ret_head == ret_tail do
			token = {}
			ltask.wait(token)
		end
		ret_head = ret_head + 1
		local t = ret[ret_head]
		ret[ret_head] = nil
		return t[1], t[2]
	end
end

-------------

local quit

function ltask.quit()
	ltask.fork(function ()
		for co, addr in pairs(session_coroutine_address) do
			local session = session_coroutine_response[co]
			ltask.rasie_error(addr, session, "Service has been quit.")
		end
		quit = true
	end)
end

local service = nil
local sys_service = {}

function ltask.dispatch(handler)
	if handler then
		service = service or {}
		-- merge handler into service
		for k,v in pairs(handler) do
			if type(v) == "function" then
				assert(service[k] == nil)
				service[k] = v
			end
		end
	end
	return service
end

local function register_handler(msg_type, f)
	SESSION[msg_type] = function (type)
		local from = session_coroutine_address[running_thread]
		local session = session_coroutine_response[running_thread]
		f(from, session)
	end
end

function ltask.signal_handler(f)	-- root only
	register_handler(MESSAGE_SIGNAL, f)
end

function ltask.idle_handler(f)
	register_handler(MESSAGE_IDLE, f)
end

local yieldable_require; do
	local require = _G.require
	local loaded = package.loaded
	local loading = {}
	local function findloader(name)
		local msg = ''
		local searchers = package.searchers
		assert(type(searchers) == "table", "'package.searchers' must be a table")
		for _, searcher in ipairs(searchers) do
			local f, extra = searcher(name)
			if type(f) == 'function' then
				return f, extra
			elseif type(f) == 'string' then
				msg = msg .. "\n\t" .. f
			end
		end
		error(("module '%s' not found:%s"):format(name, msg), 3)
	end
	local function finish_loading(loading_queue)
		local waiting = #loading_queue
		if waiting > 0 then
			for i = 1, waiting do
				ltask.wakeup(loading_queue[i])
			end
		end
		loading[loading_queue.name] = nil
	end
	local toclosed_loading = {__close = finish_loading}
	local function start_loading(name, co)
		local loading_queue = loading[name]
		if loading_queue then
			if loading_queue.co == co then
				error("circular dependency", 2)
			end
			loading_queue[#loading_queue+1] = co
			ltask.wait(co)
			return
		end
		loading_queue = setmetatable({co = co, name = name}, toclosed_loading)
		loading[name] = loading_queue
		return loading_queue
	end
	function yieldable_require(name)
		local m = loaded[name]
		if m ~= nil then
			return m
		end
		local co, main = coroutine.running()
		if main then
			return require(name)
		end
		local queue <close> = start_loading(name, co)
		if not queue then
			local r = loaded[name]
			if r == nil then
				error(("require %q failed"):format(name), 2)
			end
			return r
		end
		local initfunc, extra = findloader(name)
		local r = initfunc(name, extra)
		if r == nil then
			r = true
		end
		loaded[name] = r
		return r
	end
end

local function sys_service_init(t)
	-- The first system message
	_G.require = yieldable_require
	local initfunc = assert(load(t.initfunc))
	local func = assert(initfunc(t.name))
	local handler = func(table.unpack(t.args))
	ltask.dispatch(handler)
	if service == nil then
		ltask.quit()
	end
end

local function error_handler(errobj)
	return traceback(errobj, 4)
end

function sys_service.init(t)
	local ok, errobj = xpcall(sys_service_init, error_handler, t)
	if not ok then
		ltask.quit()
		rethrow_error(1, errobj)
	end
end

function sys_service.quit()
	if service and service.quit then
		return service.quit()
	else
		ltask.quit()
	end
end

function sys_service.memory()
	return collectgarbage "count" * 1024
end

function sys_service.traceback()
	local tlog = {}
	local n = 1
	for session, co in pairs(session_coroutine_suspend_lookup) do
		tlog[n] = "Session : " ..  tostring(session) ; n = n + 1
		tlog[n] = debug.traceback(co) ; n = n + 1
	end
	return table.concat(tlog, "\n")
end

local function system(command, ...)
	local s = sys_service[command]
	if not s then
		error("Unknown system message : " .. command)
		return
	end
	send_response(s(...))
end

SESSION[MESSAGE_SYSTEM] = function (type, msg, sz)
	system(ltask.unpack_remove(msg, sz))
end

local function request(command, ...)
	local s = service[command]
	if not s then
		error("Unknown request message : " .. command)
		return
	end
	send_response(s(...))
end

SESSION[MESSAGE_REQUEST] = function (type, msg, sz)
	request(ltask.unpack_remove(msg, sz))
end

local function schedule_message()
	local from, session, type, msg, sz = ltask.recv_message()
	local f = SESSION[type]
	if f then
		-- new session for this message
		local co = new_session(f, from, session)
		wakeup_session(co, type, msg, sz)
	else
		local co = session_coroutine_suspend_lookup[session]
		if co == nil then
			print("Unknown response session : ", session, "from", from, "type", type, ltask.unpack_remove(msg, sz))
		else
			session_coroutine_suspend_lookup[session] = nil
			wakeup_session(co, type, session, msg, sz)
		end
	end
	while #wakeup_queue > 0 do
		local s = table.remove(wakeup_queue, 1)
		wakeup_session(table.unpack(s))
	end
end

print = ltask.log.info

local function mainloop()
	while true do
		schedule_message()
		if quit then
			ltask.log.info "quit."
			return
		end
		yield_service()
	end
end

mainloop()
