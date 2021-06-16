local files = require 'files'
local noder = require 'core.noder'

local globalsMap    = {}
local subscribeMap  = {}

local function popGlobals(uri)
    if not subscribeMap[uri] then
        return
    end
    for id in pairs(subscribeMap[uri]) do
        if globalsMap[id] then
            globalsMap[id][uri] = nil
        end
    end
    subscribeMap[uri] = nil
end

local function pushGlobals(uri)
    subscribeMap[uri] = {}
    local state = files.getState(uri)
    if not state then
        return
    end
    local nodes = noder.compileNodes(state.ast)
    for id in pairs(nodes) do
        if  id:sub(1, 2) == 'g:'
        and noder.getFirstID(id) == id then
            if not globalsMap[id] then
                globalsMap[id] = {}
            end
            globalsMap[id][uri] = true
            subscribeMap[uri][id] = true
        end
    end
end

files.watch(function (ev, uri)
    if ev == 'update' then
        popGlobals(uri)
        pushGlobals(uri)
    end
end)

local m = {}

function m.getUrisByID(id)
    return globalsMap[id]
end

return m
