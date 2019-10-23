local guide    = require 'parser.guide'
local checkSMT = require 'searcher.setmetatable'

local m = {}

function m:eachRef(source, callback)
    local node = source.node
    if     node.type == 'setfield'
    or     node.type == 'getfield'
    or     node.type == 'setmethod'
    or     node.type == 'getmethod'
    or     node.type == 'setindex'
    or     node.type == 'getindex' then
        local key = guide.getKeyName(node)
        self:eachField(node.node, key, function (info)
            if info.mode == 'set' or info.mode == 'get' then
                callback(info)
            end
        end)
    else
        self:eachRef(node, callback)
    end
end

function m:eachField(source, key, callback)
    local used = {}
    local found = false
    used[source] = true

    self:eachRef(source, function (info)
        local src = info.source
        used[src] = true
        local child, mode, value = self:childMode(src)
        if child then
            if key == guide.getKeyName(child) then
                callback {
                    uri    = self.uri,
                    source = child,
                    mode   = mode,
                }
            end
            if value then
                info.searcher:eachField(value, key, callback)
            end
            return
        end
        if src.type == 'getglobal' then
            local parent = src.parent
            child, mode = info.searcher:childMode(parent)
            if child then
                if key == guide.getKeyName(child) then
                    callback {
                        uri    = self.uri,
                        source = child,
                        mode   = mode,
                    }
                end
            end
        elseif src.type == 'setglobal' then
            info.searcher:eachField(src.value, key, callback)
        else
            info.searcher:eachField(src, key, callback)
        end
    end)

    checkSMT(self, key, used, found, callback)
end

function m:getValue(source)
    if source.type == 'setfield'
    or source.type == 'setmethod'
    or source.type == 'setindex' then
        return source.value and self:getValue(source.value)
    end
end

return m
