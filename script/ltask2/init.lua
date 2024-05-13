local boot = require "ltask.bootstrap"

local function searchpath(name)
    return assert(package.searchpath(name, (ROOT / 'script/ltask2/lualib/?.lua'):string()))
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
            name = "logger",
            unique = true,
            args = {
                {
                    LOGPATH = LOGPATH,
                }
            }
        },
        {
            name = "main",
            args = {
                {
                    ROOT     = ROOT:string(),
                    LOGPATH  = LOGPATH,
                    METAPATH = METAPATH,
                }
            },
        },
    },
    service_source = readall(servicepath),
    service_chunkname = "@" .. servicepath,
    initfunc = ([=[
local name = ...
package.path = [[${lua_path}]]
package.cpath = [[${lua_cpath}]]
local filename, err = package.searchpath(name, [[${service_path}]])
if not filename then
    return nil, err
end
return loadfile(filename)
]=]):gsub("%$%{([^}]*)%}", {
        lua_path = package.path,
        lua_cpath = package.cpath,
        service_path = (ROOT / 'script/ltask2/service/?.lua'):string()
    }),
}

boot.init_socket()
local bootstrap = require 'ltask2.lualib.bootstrap'
local ctx = bootstrap.start {
    core = {},
    root = root_config,
    root_initfunc = root_config.initfunc,
}

bootstrap.wait(ctx)
print('bootstrap.wait(ctx) 结束！')
