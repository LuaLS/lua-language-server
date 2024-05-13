local ltask = require "ltask"
local logpath = (...).LOGPATH

local S = {}

local logfile = io.open(logpath .. '/ltask.log', 'w+b')
if logfile then
	logfile:setvbuf("no")
end

local function writelog()
	while true do
		local ti, _, msg, sz = ltask.poplog()
		if ti == nil then
			break
		end
		local tsec = ti // 100
		local msec = ti % 100
		local level, message = ltask.unpack_remove(msg, sz)
		if logfile then
			logfile:write(string.format("[%s.%02d][%-5s]%s\n", os.date("%Y-%m-%d %H:%M:%S", tsec), msec, level:upper(), message))
		end
	end
end

ltask.fork(function()
	while true do
		writelog()
		ltask.sleep(100)
	end
end)

function S.quit()
	writelog()
end

return S
