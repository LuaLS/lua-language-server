local ltask = require "ltask"

local S = {}

local function writelog()
	local flush
	while true do
		local ti, _, msg, sz = ltask.poplog()
		if ti == nil then
			if flush then
				io.flush()
			end
			break
		end
		local tsec = ti // 100
		local msec = ti % 100
		local level, message = ltask.unpack_remove(msg, sz)
		io.write(string.format("[%s.%02d][%-5s]%s\n", os.date("%Y-%m-%d %H:%M:%S", tsec), msec, level:upper(), message))
		flush = true
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
