local boot = require "ltask.bootstrap"

local SERVICE_ROOT <const> = 1
local MESSSAGE_SYSTEM <const> = 0

local function bootstrap_root(initfunc, config)
	local sid = assert(boot.new_service("root", config.service_source, config.service_chunkname, SERVICE_ROOT))
	assert(sid == SERVICE_ROOT)
	boot.init_root(SERVICE_ROOT)
	-- send init message to root service
	local init_msg, sz = boot.pack("init", {
		initfunc = initfunc,
		name = "root",
		args = {config}
	})
	-- self bootstrap
	boot.post_message {
		from = SERVICE_ROOT,
		to = SERVICE_ROOT,
		session = 1,	-- 1 for root init
		type = MESSSAGE_SYSTEM,
		message = init_msg,
		size = sz,
	}
end

local function start(config)
	boot.init(config.core)
	boot.init_timer()
	bootstrap_root(config.root_initfunc, config.root)
	return boot.run(config.mainthread)
end

local function wait(ctx)
	boot.wait(ctx)
	boot.deinit()
end

return {
	start = start,
	wait = wait,
}
