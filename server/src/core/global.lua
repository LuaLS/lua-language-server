local mt = {}
mt.__index = mt

function mt:clearGlobal(uri)
    self.get[uri] = nil
    self.set[uri] = nil
end

function mt:markSet(uri, k, v)
    local sets = self.set[uri]
    if not sets then
        sets = {}
        self.set[uri] = sets
    end
    sets[k] = v
end

function mt:markGet(uri, k)
    local gets = self.get[uri]
    if not gets then
        gets = {}
        self.get[uri] = gets
    end
    gets[k] = true
end

function mt:compileVM(uri, vm)
    local seted = {}
    for k, v in pairs(vm.results.globals) do
        seted[k] = true
        self:markSet(uri, k, v)
    end
    for k in next, vm.env.child do
        if not seted[k] then
            self:markGet(uri, k)
        end
    end

    local needReCompile = {}
    for otherUri, gets in pairs(self.get) do
        for key in pairs(seted) do
            if gets[key] ~= nil then
                needReCompile[#needReCompile+1] = otherUri
                goto CONTINUE
            end
        end
        ::CONTINUE::
    end

    return needReCompile
end

function mt:getGlobal(key)
    for _, sets in pairs(self.set) do
        local v = sets[key]
        if v ~= nil then
            return v
        end
    end
    return nil
end

return function ()
    return setmetatable({
        get = {},
        set = {},
    }, mt)
end
