local files = require 'files'
local await = require 'await'
local noder = require 'core.noder'

local globalsMap = {}
local subscribe  = {}

local function popGlobals(uri)
    
end

local function pushGlobals(uri)
    local state = files.getState(uri)
    if not state then
        return
    end
    noder.compileNodes(state.ast)
    
end

local m = {}

files.watch(function (ev, uri)
    if ev == 'update' then
        popGlobals(uri)
        await.delay()
        pushGlobals(uri)
    end
end)

return m
