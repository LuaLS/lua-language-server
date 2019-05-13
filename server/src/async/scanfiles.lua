local args = ...

local fs = require 'bee.filesystem'
local glob = require 'glob'
local root = fs.path(args.root)

local session = glob.gitignore(args.pattern, args.options)
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
    OUT:push('path', fs.absolute(root / path):string())
end)

OUT:push 'ok'
