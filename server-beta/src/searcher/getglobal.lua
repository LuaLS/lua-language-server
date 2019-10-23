local guide    = require 'parser.guide'
local checkSMT = require 'searcher.setmetatable'

local m = {}

function m:eachDef(source, callback)
    -- _ENV
    local key = guide.getKeyName(source)
    self:eachField(source.node, key, function (info)
        if info.mode == 'set' then
            callback(info)
        end
    end)
    self:eachSpecial(function (name, src)
        if name == '_G' then
            local parent = src.parent
            if guide.getKeyName(parent) == key then
                callback {
                    source = parent,
                    uri    = self.uri,
                    mode   = 'set',
                }
            end
        elseif name == 'rawset' then
            local t, k = self:callArgOf(src.parent)
            if self:getSpecialName(t) == '_G'
            and guide.getKeyName(k) == key then
                callback {
                    source = src.parent,
                    uri    = self.uri,
                    mode   = 'set',
                }
            end
        end
    end)
end

function m:eachRef(source, callback)
    -- _ENV
    local key = guide.getKeyName(source)
    self:eachField(source.node, key, function (info)
        if info.mode == 'set' or info.mode == 'get' then
            callback(info)
        end
    end)
    self:eachSpecial(function (name, src)
        if name == '_G' then
            local parent = src.parent
            if guide.getKeyName(parent) == key then
                if parent.type:sub(1, 3) == 'set' then
                    callback {
                        source = parent,
                        uri    = self.uri,
                        mode   = 'set',
                    }
                else
                    callback {
                        source = parent,
                        uri    = self.uri,
                        mode   = 'get',
                    }
                end
            end
        elseif name == 'rawset' then
            local t, k = self:callArgOf(src.parent)
            if self:getSpecialName(t) == '_G'
            and guide.getKeyName(k) == key then
                callback {
                    source = src.parent,
                    uri    = self.uri,
                    mode   = 'set',
                }
            end
        elseif name == 'rawget' then
            local t, k = self:callArgOf(src.parent)
            if self:getSpecialName(t) == '_G'
            and guide.getKeyName(k) == key then
                callback {
                    source = src.parent,
                    uri    = self.uri,
                    mode   = 'set',
                }
            end
        end
    end)
end

function m:eachField(source, key, callback)
    local used = {}
    local found = false
    used[source] = true

    self:eachRef(source, function (info)
        local src = info.source
        used[src] = true
        local child, mode, value = info.searcher:childMode(src)
        if child then
            if key == guide.getKeyName(child) then
                callback {
                    source = child,
                    uri    = info.uri,
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
            child, mode, value = info.searcher:childMode(parent)
            if child then
                if key == guide.getKeyName(child) then
                    callback {
                        source = child,
                        uri    = info.uri,
                        mode   = mode,
                    }
                end
                if value then
                    info.searcher:eachField(value, key, callback)
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

function m:eachValue(source, callback)
    callback {
        source = source,
        uri    = self.uri,
    }
    if source.value then
        self:eachValue(source.value, callback)
    end
end

return m
