local fs = require 'bee.filesystem'
local async = require 'async'
local config = require 'config'

local function split(str, sep)
    local t = {}
    for s in str:gmatch('[^' .. sep .. ']+') do
        t[#t+1] = s
    end
    return t
end

local function similarity(a, b)
    local ta = split(a, '/\\')
    local tb = split(b, '/\\')
    for i = 1, #ta do
        if ta[i] ~= tb[i] then
            return i - 1
        end
    end
    return #ta
end

local mt = {}
mt.__index = mt

function mt:uriDecode(uri)
    if uri:sub(1, 8) ~= 'file:///' then
        log.error('uri decode failed: ', uri)
        return nil
    end
    local names = {}
    for name in uri:sub(9):gmatch '[^%/]+' do
        names[#names+1] = name:gsub('%%([0-9a-fA-F][0-9a-fA-F])', function (hex)
            return string.char(tonumber(hex, 16))
        end)
    end
    if #names == 0 then
        log.error('uri decode failed: ', uri)
        return nil
    end
    -- 盘符后面加个斜杠
    local path = fs.path(names[1] .. '\\')
    for i = 2, #names do
        path = path / names[i]
    end
    return fs.absolute(path)
end

function mt:uriEncode(path)
    local names = {}
    local cur = fs.absolute(path)
    while true do
        local name = cur:filename():string()
        if name == '' then
            -- 盘符，去掉一个斜杠
            name = cur:string():sub(1, -2)
        end
        name = name:gsub([=[[^%w%-%_%.%~]]=], function (char)
            return ('%%%02X'):format(string.byte(char))
        end)
        table.insert(names, 1, name)
        if cur == cur:parent_path() then
            break
        end
        cur = cur:parent_path()
    end
    return 'file:///' .. table.concat(names, '/')
end

function mt:init(rootUri)
    self.root = self:uriDecode(rootUri)
    if not self.root then
        return
    end
    log.info('Workspace inited, root: ', self.root)
    async.call([[
        require 'utility'
        local fs = require 'bee.filesystem'
        local list = {}
        local ignore = {
            ['.git'] = true,
            ['node_modules'] = true,
        }
        for path in io.scan(fs.path(ROOT)) do
            if path:extension():string() == '.lua' then
                list[#list+1] = path:string()
            end
        end
        return list
    ]], {
        ROOT = self.root:string()
    }, function (list)
        log.info(('Found [%d] files'):format(#list))
        local ignored = {}
        for name in pairs(config.config.workspace.ignoreDir) do
            local path = fs.absolute(self.root / name)
            local str = path:string():lower()
            ignored[#ignored+1] = str
        end
        for _, filename in ipairs(list) do
            local path = fs.absolute(fs.path(filename))
            local name = path:string():lower()
            local ok = true
            for _, ignore in ipairs(ignored) do
                if name:sub(1, #ignore) == ignore then
                    ok = false
                    break
                end
            end
            if ok then
                self.files[name] = self:uriEncode(path)
            end
        end
        self:reset()
        self._complete = true
    end)
end

function mt:isComplete()
    return not not self._complete
end

function mt:addFile(uri)
    if uri:sub(-4) == '.lua' then
        local name = self:uriDecode(uri):string():lower()
        self.files[name] = uri
    end
end

function mt:removeFile(uri)
    local name = self:uriDecode(uri):string():lower()
    self.files[name] = nil
end

function mt:findPath(baseUri, searchers)
    local results = {}
    for filename, uri in pairs(self.files) do
        for _, searcher in ipairs(searchers) do
            if filename:sub(-#searcher) == searcher then
                local sep = filename:sub(-#searcher-1, -#searcher-1)
                if sep == '/' or sep == '\\' then
                    results[#results+1] = uri
                end
            end
        end
    end

    if #results == 0 then
        return nil
    end
    local uri
    if #results == 1 then
        uri = results[1]
    else
        table.sort(results, function (a, b)
            return similarity(a, baseUri) > similarity(b, baseUri)
        end)
        uri = results[1]
    end
    self.lsp:readText(uri, self:uriDecode(uri))
    return uri
end

function mt:compileLuaPath()
    for i, luapath in ipairs(self.luapath) do
        self.compiledpath[i] = '^' .. luapath:gsub('%.', '%%.'):gsub('%?', '(.-)') .. '$'
    end
end

function mt:convertPathAsRequire(filename, start)
    local list
    for _, luapath in ipairs(self.compiledpath) do
        local str = filename:match(luapath, start)
        if str then
            if not list then
                list = {}
            end
            list[#list+1] = str:gsub('/', '.')
        end
    end
    return list
end

function mt:matchPath(baseUri, input)
    input = input:lower()
    local first = input:match '[^%.]+'
    if not first then
        return nil
    end
    local baseName = self:uriDecode(baseUri):string():lower()
    local rootLen = #self.root:string()
    local map = {}
    for filename in pairs(self.files) do
        local start = filename:find('/' .. first, rootLen + 1, true)
        if start then
            local list = self:convertPathAsRequire(filename, start + 1)
            if list then
                for _, str in ipairs(list) do
                    if #str >= #input and str:sub(1, #input) == input then
                        if not map[str]
                            or similarity(filename, baseName) > similarity(map[str], baseName)
                        then
                            map[str] = filename
                        end
                    end
                end
            end
        end
    end

    local list = {}
    for str in pairs(map) do
        list[#list+1] = str
    end
    if #list == 0 then
        return nil
    end
    table.sort(list, function (a, b)
        local sa = similarity(map[a], baseName)
        local sb = similarity(map[b], baseName)
        if sa == sb then
            return a < b
        else
            return sa > sb
        end
    end)
    return list
end

function mt:searchPath(baseUri, str)
    if self.searched[str] then
        return self.searched[str]
    end
    str = str:gsub('%.', '/')
    local searchers = {}
    for i, luapath in ipairs(self.luapath) do
        searchers[i] = luapath:gsub('%?', str):lower()
    end

    local uri = self:findPath(baseUri, searchers)
    if uri then
        self.searched[str] = uri
    end
    return uri
end

function mt:loadPath(baseUri, str)
    str = fs.relative(fs.absolute(self.root / str), self.root):string():lower()
    if self.loaded[str] then
        return self.loaded[str]
    end

    local searchers = { str }

    local uri = self:findPath(baseUri, searchers)
    if uri then
        self.loaded[str] = uri
    end
    return uri
end

function mt:reset()
    self.searched = {}
    self.loaded = {}
    self.lsp:reCompile()
end

function mt:relativePathByUri(uri)
    local path = self:uriDecode(uri)
    local relate = fs.relative(path, self.root)
    return relate
end

return function (lsp, name)
    local workspace = setmetatable({
        lsp = lsp,
        name = name,
        files = {},
        searched = {},
        loaded = {},
        luapath = {
            '?.lua',
            '?/init.lua',
            '?/?.lua',
        },
        compiledpath = {}
    }, mt)
    workspace:compileLuaPath()
    return workspace
end
