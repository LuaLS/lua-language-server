local function standard(loaded, env)
    local r = env or {}
    for _, s in ipairs {
        --'package',
        'coroutine',
        'table',
        --'io',
        'os',
        'string',
        'math',
        'utf8',
        'debug',
    } do
        r[s] = _G[s]
        loaded[s] = _G[s]
    end
    for _, s in ipairs {
        'assert',
        'collectgarbage',
        --'dofile',
        'error',
        'getmetatable',
        'ipairs',
        --'loadfile',
        'load',
        'next',
        'pairs',
        'pcall',
        'print',
        'rawequal',
        'rawlen',
        'rawget',
        'rawset',
        'select',
        'setmetatable',
        'tonumber',
        'tostring',
        'type',
        'xpcall',
        '_VERSION',
        --'require',
    } do
        r[s] = _G[s]
    end
    return r
end

local function sandbox_env(loadlua, openfile, loaded, env)
    local _LOADED = loaded or {}
    local _E = standard(_LOADED, env)
    local _PRELOAD = {}

    _E.io = {
        open = openfile,
    }

    local function searchpath(name, path)
        local err = ''
        name = string.gsub(name, '%.', '/')
        for c in string.gmatch(path, '[^;]+') do
            local filename = string.gsub(c, '%?', name)
            local f = openfile(filename)
            if f then
                f:close()
                return filename
            end
            err = err .. ("\n\tno file '%s'"):format(filename)
        end
        return nil, err
    end

    local function searcher_preload(name)
        assert(type(_PRELOAD) == "table", "'package.preload' must be a table")
        if _PRELOAD[name] == nil then
            return ("\n\tno field package.preload['%s']"):format(name)
        end
        return _PRELOAD[name]
    end

    local function searcher_lua(name)
        assert(type(_E.package.path) == "string", "'package.path' must be a string")
        local filename, err = searchpath(name, _E.package.path)
        if not filename then
            return err
        end
        local f, err = loadlua(filename)
        if not f then
            error(("error loading module '%s' from file '%s':\n\t%s"):format(name, filename, err))
        end
        return f, filename
    end

    local function require_load(name)
        local msg = ''
        local _SEARCHERS = _E.package.searchers
        assert(type(_SEARCHERS) == "table", "'package.searchers' must be a table")
        for _, searcher in ipairs(_SEARCHERS) do
            local f, extra = searcher(name)
            if type(f) == 'function' then
                return f, extra
            elseif type(f) == 'string' then
                msg = msg .. f
            end
        end
        error(("module '%s' not found:%s"):format(name, msg))
    end

    _E.require = function(name)
        assert(type(name) == "string", ("bad argument #1 to 'require' (string expected, got %s)"):format(type(name)))
        local p = _LOADED[name]
        if p ~= nil then
            return p
        end
        local init, extra = require_load(name)
        if debug.getupvalue(init, 1) == '_ENV' then
            debug.setupvalue(init, 1, _E)
        end
        local res = init(name, extra)
        if res ~= nil then
            _LOADED[name] = res
        end
        if _LOADED[name] == nil then
            _LOADED[name] = true
        end
        return _LOADED[name]
    end
    _E.package = {
        config = [[
            \
            ;
            ?
            !
            -
        ]],
        loaded = _LOADED,
        path = '?.lua',
        preload = _PRELOAD,
        searchers = { searcher_preload, searcher_lua },
        searchpath = searchpath
    }
    return _E
end

return function(name, root, io_open, loaded, env)
    if not root:sub(-1):find '[/\\]' then
        root = root .. '/'
    end
    local function openfile(name, mode)
        return io_open(root .. name, mode)
    end
    local function loadlua(name)
        local f = openfile(name, 'r')
        if f then
            local str = f:read 'a'
            f:close()
            return load(str, '@' .. root .. name)
        end
    end
    local init = loadlua(name)
    if not init then
        return
    end
    if debug.getupvalue(init, 1) == '_ENV' then
        debug.setupvalue(init, 1, sandbox_env(loadlua, openfile, loaded, env))
    end
    return init()
end
