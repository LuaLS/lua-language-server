local fs = require 'bee.filesystem'

local function decode(uri)
    -- Unix-like系统根是/
    if uri:sub(1, 9) == 'file:////' then
        return fs.path(uri:sub(9))
    end
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

local function encode(path)
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

return {
    encode = encode,
    decode = decode,
}
