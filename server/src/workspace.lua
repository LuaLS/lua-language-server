local fs = require 'bee.filesystem'

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
    local count = 0
    for path in io.scan(self.root) do
        if path:extension():string() == '.lua' then
            local uri = uriEncode(path)
            self.files[uri] = true
            count = count + 1
        end
    end
    log.info(('Found [%d] files'):format(count))
end

function mt:addFile(uri)
    if uri:sub(-4) == '.lua' then
        self.files[uri] = true
    end
end

function mt:removeFile(uri)
    self.files[uri] = nil
end

return function (name, uri)
    local workspace = setmetatable({
        name = name,
        files = {},
    }, mt)
    workspace:init(uri)
    return workspace
end
