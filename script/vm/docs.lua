local files = require 'files'
local await = require 'await'
local noder = require 'core.noder'

local docsMap      = {}
local subscribeMap = {}

local function popDocs(uri)
    if not subscribeMap[uri] then
        return
    end
    for id in pairs(subscribeMap[uri]) do
        if docsMap[id] then
            docsMap[id][uri] = nil
        end
    end
    subscribeMap[uri] = nil
end

local function pushDocs(uri)
    subscribeMap[uri] = {}
    local state = files.getState(uri)
    if not state then
        return
    end
    local nodes = noder.compileNodes(state.ast)
    for id in pairs(nodes) do
        if id:sub(1, 3) == 'dn:' then
            if not docsMap[id] then
                docsMap[id] = {}
            end
            docsMap[id][uri] = true
            subscribeMap[uri][id] = true
        end
    end
end

files.watch(function (ev, uri)
    if ev == 'update' then
        popDocs(uri)
        pushDocs(uri)
    end
end)

local m = {}

function m.getUrisByID(id)
    return docsMap[id]
end

return m
