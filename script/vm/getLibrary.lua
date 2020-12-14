---@type vm
local vm      = require 'vm.vm'

function vm.getLibraryName(source, deep)
    local defs = vm.getDefs(source, deep)
    for _, def in ipairs(defs) do
        if def.special then
            return def.special
        end
    end
    return nil
end

local globalLibraryNames = {
    'arg', 'assert', 'error', 'collectgarbage', 'dofile', '_G', 'getfenv',
    'getmetatable', 'ipairs', 'load', 'loadfile', 'loadstring',
    'module', 'next', 'pairs', 'pcall', 'print', 'rawequal',
    'rawget', 'rawlen', 'rawset', 'select', 'setfenv',
    'setmetatable', 'tonumber', 'tostring', 'type', '_VERSION',
    'warn', 'xpcall', 'require', 'unpack', 'bit32', 'coroutine',
    'debug', 'io', 'math', 'os', 'package', 'string', 'table',
    'utf8',
}
local globalLibraryNamesMap
function vm.isGlobalLibraryName(name)
    if not globalLibraryNamesMap then
        globalLibraryNamesMap = {}
        for _, v in ipairs(globalLibraryNames) do
            globalLibraryNamesMap[v] = true
        end
    end
    return globalLibraryNamesMap[name] or false
end
