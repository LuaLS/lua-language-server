local fs = require 'bee.filesystem'
local async = require 'async'

local function uriDecode(uri)
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

local function uriEncode(path)
    local names = {}
    local cur = fs.absolute(path)
    while true do
        local name = cur:filename():string():gsub([=[[^%w%-%_%.%~]]=], function (char)
            return '%' .. string.byte(char)
        end)
        table.insert(names, 1, name)
        if cur == cur:parent_path() then
            break
        end
        cur = cur:parent_path()
    end
    return 'file:///' .. table.concat(names, '/')
end

local mt = {}
mt.__index = mt

function mt:init(rootUri)
    self.root = uriDecode(rootUri)
    if not self.root then
        return
    end
    log.info('Workspace inited, root: ', self.root)
    async.call([[
        require 'utility'
        local fs = require 'bee.filesystem'
        local list = {}
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
        for _, filename in ipairs(list) do
            local path = fs.absolute(fs.path(filename))
            local name = path:string():lower()
            self.files[name] = uriEncode(path)
        end
    end)
end

function mt:addFile(uri)
    if uri:sub(-4) == '.lua' then
        local name = uriDecode(uri):string():lower()
        self.files[name] = uri
    end
end

function mt:removeFile(uri)
    local name = uriDecode(uri):string():lower()
    self.files[name] = nil
end

function mt:searchPath(str)
    str = str:gsub('%.', '/')
    local searchers = {}
    for i, luapath in ipairs(self.luapath) do
        searchers[i] = luapath:gsub('%?', str):lower()
    end
    local results = {}
    for filename, uri in pairs(self.files) do
        for _, searcher in ipairs(searchers) do
            if filename:sub(-#searcher) == searcher then
                results[#results+1] = uri
            end
        end
    end
    return results[1]
end

return function (name, uri)
    local workspace = setmetatable({
        name = name,
        files = {},
        luapath = {
            '?.lua',
            '?/init.lua',
            '?/?.lua',
        },
    }, mt)
    workspace:init(uri)
    return workspace
end
