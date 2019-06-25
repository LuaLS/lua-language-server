local args = ...

require 'utility'
local fs = require 'bee.filesystem'
local glob = require 'glob'

local function scan(mode, root, pattern, options)
    OUT:push('log', 'Scanning:', root:string())
    OUT:push('log', 'Scan pattern:', table.dump(pattern))
    OUT:push('log', 'Scan options:', table.dump(options))
    local session = glob.gitignore(pattern, options)

    session:setInterface('type', function (path)
        local fullpath = root / path
        if not fs.exists(fullpath) then
            return nil
        end
        if fs.is_directory(fullpath) then
            return 'directory'
        else
            return 'file'
        end
        return nil
    end)
    session:setInterface('list', function (path)
        local fullpath = root / path
        if not fs.exists(fullpath) then
            return nil
        end
        local list = {}
        for child in fullpath:list_directory() do
            list[#list+1] = child:string()
        end
        return list
    end)

    session:scan(function (path)
        local ok, msg = IN:pop()
        if ok and msg == 'stop' then
            OUT:push 'stop'
            return
        end
        OUT:push(mode, fs.absolute(root / path):string())
    end)
end

for _, data in ipairs(args) do
    local root = fs.path(data.root)
    local suc, err = xpcall(scan, debug.traceback, data.mode, root, data.pattern, data.options)
    if not suc then
        ERR:push(err)
    end
end

OUT:push 'ok'
