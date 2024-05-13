local boot = require "ltask.bootstrap"

local function searchpath(name)
    return assert(package.searchpath(name, "script/ltask/?.lua"))
end

local function readall(path)
    local f <close> = assert(io.open(path))
    return f:read "a"
end

local servicepath = searchpath "service"

local root_config = {
    bootstrap = {
        {
            name = "timer",
            unique = true,
        },
        {
            name = "main",
            args = { arg },
        },
    },
    service_source = readall(servicepath),
    service_chunkname = "@" .. servicepath,
    initfunc = ([=[
local name = ...
package.path = [[${lua_path}]]
package.cpath = [[${lua_cpath}]]
local filename, err = package.searchpath(name, "${service_path}")
if not filename then
	return nil, err
end
return loadfile(filename)
]=]):gsub("%$%{([^}]*)%}", {
        lua_path = package.path,
        lua_cpath = package.cpath,
        service_path = "script/ltask/service/?.lua",
    }),
}

boot.init_socket()
local bootstrap = dofile(searchpath "bootstrap")
local ctx = bootstrap.start {
    core = {},
    root = root_config,
    root_initfunc = root_config.initfunc,
}
bootstrap.wait(ctx)
