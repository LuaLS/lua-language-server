---@class SandBox
local M = {}
M.__index = M

function M:make_env()
    local env = {}
    self.env = env

    env._G = env
    env._VERSION = _VERSION
    env.assert = assert
    env.collectgarbage = collectgarbage
    env.error = error
    env.getmetatable = getmetatable
    env.ipairs = ipairs
    env.next = next
    env.pairs = pairs
    env.pcall = pcall
    env.print = print
    env.rawequal = rawequal
    env.rawget = rawget
    env.rawlen = rawlen
    env.rawset = rawset
    env.select = select
    env.setmetatable = setmetatable
    env.tonumber = tonumber
    env.tostring = tostring
    env.type = type
    env.xpcall = xpcall
    env.load = self:make_load()

    env.coroutine = {}
    env.coroutine.close = coroutine.close
    env.coroutine.create = coroutine.create
    env.coroutine.isyieldable = coroutine.isyieldable
    env.coroutine.resume = coroutine.resume
    env.coroutine.running = coroutine.running
    env.coroutine.status = coroutine.status
    env.coroutine.wrap = coroutine.wrap
    env.coroutine.yield = coroutine.yield

    env.math = {}
    env.math.abs = math.abs
    env.math.acos = math.acos
    env.math.asin = math.asin
    env.math.atan = math.atan
    env.math.ceil = math.ceil
    env.math.cos = math.cos
    env.math.deg = math.deg
    env.math.exp = math.exp
    env.math.floor = math.floor
    env.math.fmod = math.fmod
    env.math.huge = math.huge
    env.math.log = math.log
    env.math.max = math.max
    env.math.maxinteger = math.maxinteger
    env.math.min = math.min
    env.math.mininteger = math.mininteger
    env.math.modf = math.modf
    env.math.pi = math.pi
    env.math.rad = math.rad
    env.math.random = math.random
    env.math.randomseed = math.randomseed
    env.math.sin = math.sin
    env.math.sqrt = math.sqrt
    env.math.tan = math.tan
    env.math.tointeger = math.tointeger
    env.math.type = math.type
    env.math.ult = math.ult

    env.os = {}
    env.os.clock = os.clock
    env.os.date = os.date
    env.os.difftime = os.difftime
    env.os.time = os.time

    env.package = {}
    env.package.config = package.config
    env.package.loaded = {}
    env.package.preload = {}
    env.package.path = '?.lua;?/init.lua'
    env.package.searchers = {
        [1] = self:make_preload(),
        [2] = self:make_searcher(),
    }
    env.package.searchpath = self:make_packagesearchpath()

    env.string = {}
    env.string.byte = string.byte
    env.string.char = string.char
    env.string.dump = string.dump
    env.string.find = string.find
    env.string.format = string.format
    env.string.gmatch = string.gmatch
    env.string.gsub = string.gsub
    env.string.len = string.len
    env.string.lower = string.lower
    env.string.match = string.match
    env.string.pack = string.pack
    env.string.packsize = string.packsize
    env.string.rep = string.rep
    env.string.reverse = string.reverse
    env.string.sub = string.sub
    env.string.unpack = string.unpack
    env.string.upper = string.upper

    env.table = {}
    env.table.concat = table.concat
    env.table.insert = table.insert
    env.table.move = table.move
    env.table.pack = table.pack
    env.table.remove = table.remove
    env.table.sort = table.sort
    env.table.unpack = table.unpack

    env.utf8 = {}
    env.utf8.char = utf8.char
    env.utf8.charpattern = utf8.charpattern
    env.utf8.codepoint = utf8.codepoint
    env.utf8.codes = utf8.codes
    env.utf8.len = utf8.len
    env.utf8.offset = utf8.offset

    env.debug = {}
    env.debug.getinfo = self:make_debuggetinfo()
    env.debug.setmetatable = self:make_debugsetmetatable()
    env.debug.traceback = debug.traceback
    env.debug.upvalueid = debug.upvalueid

    env.io = {}
    env.io.stderr = io.stderr
    env.io.type = io.type

    env.require = self:make_require()

    return env
end

local function split(str, sep)
    local result = {}
    for part in string.gmatch(str, '([^' .. sep .. ']+)') do
        result[#result+1] = part
    end
    return result
end

---@private
function M:make_searcher()
    return function (name)
        local path, err = self.env.package.searchpath(name, self.env.package.path)
        if not path then
            return err
        end
        local f = assert(loadfile(path, 't', self.env))
        return f
    end
end

---@private
function M:make_preload()
    local preload = self.env.package.preload
    return function (name)
        assert(type(preload) == "table", "'package.preload' must be a table")
        if preload[name] == nil then
            return ("\n\tno field package.preload['%s']"):format(name)
        end
        return preload[name]
    end
end

---@private
function M:make_require(searchers, loaded)
    local env = self.env
    searchers = searchers or env.package.searchers
    loaded = loaded or env.package.loaded
    local function search_loader(name)
        local msg = ''
        for _, searcher in ipairs(searchers) do
            local f, extra = searcher(name)
            if type(f) == 'function' then
                return f, extra
            elseif type(f) == 'string' then
                msg = msg .. f
            end
        end
        error(("module '%s' not found:%s"):format(name, msg))
    end
    self.require = function (name)
        assert(type(name) == "string", ("bad argument #1 to 'require' (string expected, got %s)"):format(type(name)))
        local p = loaded[name]
        if p ~= nil then
            return p
        end
        local f, extra = search_loader(name)
        if debug.getupvalue(f, 1) == '_ENV' then
            debug.setupvalue(f, 1, env)
        end
        local res = f(name, extra)
        if res == nil then
            res = true
        end
        loaded[name] = res
        return res
    end

    return self.require
end

function M:make_debuggetinfo()
    local debug_getinfo = debug.getinfo
    local type = type
    return function (f, ...)
        if type(f) == 'number' then
            f = f + 1
        end
        local result = debug_getinfo(f, ...)
        if not result then
            return nil
        end
        result.func = nil
        return result
    end
end

function M:make_debugsetmetatable()
    local type = type
    local debug_setmetatable = debug.setmetatable
    return function (t, mt)
        if type(t) == 'table'
        or type(t) == 'userdata' then
            return setmetatable(t, mt)
        else
            return debug_setmetatable(t, mt)
        end
    end
end

function M:make_packagesearchpath()
    local io_open = io.open
    local string_gsub = string.gsub
    return function (name, path, sep, rep)
        local configs = split(self.env.package.config, '\r\n')
        sep = sep or '.'
        rep = rep or configs[1]
        name = string_gsub(name, '%' .. sep, rep)
        local pp
        if self.prefix_name then
            pp = string_gsub(self.prefix_name, '%' .. configs[3], name)
            pp = string_gsub(pp, '%' .. sep, rep)
        end
        local msg = ''
        local paths = split(path, configs[2])
        for i = 1, #paths do
            local filepath = string_gsub(paths[i], '%' .. configs[3], name)
            if pp then
                filepath = pp .. rep .. filepath
            end
            local f = io_open(filepath, 'r')
            if f then
                f:close()
                return filepath
            end
            msg = msg .. ("\n\tno file '%s'"):format(filepath)
        end

        return nil, msg
    end
end

function M:make_load()
    local load = load
    return function (chunk, chunkname, mode, env)
        return load(chunk, chunkname, 't', env)
    end
end

---@package
---@param sandbox_name string
---@param prefix_name? string
function M:init(sandbox_name, prefix_name)
    ---@type string
    self.name = sandbox_name
    ---@type string?
    self.prefix_name = prefix_name
    ---@type table
    self:make_env()
end

---@param name string
---@param prefix_name? string
---@return SandBox
return function (name, prefix_name)
    local sandbox = setmetatable({}, M)
    sandbox:init(name, prefix_name)
    return sandbox
end
