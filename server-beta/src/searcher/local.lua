local guide = require 'parser.guide'
local checkSMT = require 'searcher.setmetatable'

local m = {}

function m:eachDef(source, callback)
    if source.tag ~= 'self' then
        callback {
            source = source,
            uri    = self.uri,
            mode   = 'local',
        }
    end
    if source.ref then
        for _, ref in ipairs(source.ref) do
            if ref.type == 'setlocal' then
                callback {
                    source = ref,
                    uri    = self.uri,
                    mode   = 'set',
                }
            end
        end
    end
    if source.tag == 'self' then
        local method = source.method
        local node = method.node
        self:eachDef(node, callback)
    end
end

function m:eachRef(source, callback)
    if source.tag ~= 'self' then
        callback {
            source = source,
            uri    = self.uri,
            mode   = 'local',
        }
    end
    if source.ref then
        for _, ref in ipairs(source.ref) do
            if ref.type == 'setlocal' then
                callback {
                    source = ref,
                    uri    = self.uri,
                    mode   = 'set',
                }
            elseif ref.type == 'getlocal' then
                callback {
                    source = ref,
                    uri    = self.uri,
                    mode   = 'get',
                }
            end
        end
    end
    if source.tag == 'self' then
        local method = source.method
        local node = method.node
        self:eachRef(node, callback)
    end
end

function m:eachField(source, key, callback)
    local used = {}
    used[source] = true
    local found = false
    local refs = source.ref
    if refs then
        for i = 1, #refs do
            local ref = refs[i]
            if ref.type == 'getlocal' then
                used[ref] = true
                local parent = ref.parent
                if key == guide.getKeyName(parent) then
                    if parent.type:sub(1, 3) == 'set' then
                        callback {
                            source = parent,
                            uri    = self.uri,
                            mode   = 'set',
                        }
                        found = true
                    else
                        callback {
                            source = parent,
                            uri    = self.uri,
                            mode   = 'get',
                        }
                    end
                end
            elseif ref.type == 'getglobal' then
                used[ref] = true
                if key == guide.getKeyName(ref) then
                    -- _ENV.XXX
                    callback {
                        source = ref,
                        uri    = self.uri,
                        mode   = 'get',
                    }
                end
            elseif ref.type == 'setglobal' then
                used[ref] = true
                -- _ENV.XXX = XXX
                if key == guide.getKeyName(ref) then
                    callback {
                        source = ref,
                        uri    = self.uri,
                        mode   = 'set',
                    }
                    found = true
                end
            end
        end
    end
    if source.tag == 'self' then
        local method = source.method
        local node = method.node
        self:eachField(node, key, function (info)
            callback(info)
            if info.mode == 'set' then
                found = true
            end
        end)
    end
    self:eachValue(source, function (info)
        local src = info.source
        if source ~= src then
            info.searcher:eachField(src, key, function (info)
                callback(info)
                if info.mode == 'set' then
                    found = true
                end
            end)
        end
    end)
    checkSMT(self, key, used, found, callback)
end

function m:eachValue(source, callback)
    callback {
        source = source,
        uri    = self.uri,
    }
    local refs = source.ref
    if refs then
        for i = 1, #refs do
            local ref = refs[i]
            if ref.type == 'setlocal' then
                self:eachValue(ref.value, callback)
            elseif ref.type == 'getlocal' then
                local parent = ref.parent
                if parent.type == 'setmethod' then
                    local func = parent.value
                    if func and func.locals then
                        callback {
                            source = func.locals[1],
                            uri    = self.uri,
                        }
                    end
                end
            end
        end
    end
    if source.value then
        self:eachValue(source.value, callback)
    end
end

return m
