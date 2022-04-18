---@class vm
local vm    = require 'vm.vm'
local guide = require 'parser.guide'

---@class vm.local-compiler
---@field loc      parser.object
---@field mainFunc parser.object
local mt = {}
mt.__index = mt
mt.index = 1


---@class parser.object
---@field _hasSorted      boolean

---@param source parser.object
local function sortRefs(source)
    if source._hasSorted then
        return
    end
    source._hasSorted = true
    table.sort(source.ref, function (a, b)
        return (a.range or a.start) < (b.range or b.start)
    end)
end

---@param loc         parser.object
---@param currentFunc parser.object
---@param callback    fun(src: parser.object, loc: parser.object)
function mt:_runFunction(loc, currentFunc, callback)
    while true do
        local ref = self.loc.ref[self.index]
        if not ref then
            break
        end
        if ref.start > currentFunc.finish then
            break
        end
        local func = guide.getParentFunction(ref)
        if func == currentFunc then
            callback(ref, loc)
            self.index = self.index + 1
            if ref.type == 'setlocal' then
                loc = ref
            end
        else
            self:_runFunction(loc, func, callback)
        end
    end
end

---@param callback fun(src: parser.object, loc: parser.object)
function mt:launch(callback)
    self:_runFunction(self.loc, self.mainFunc, callback)
end

---@param loc parser.object
---@return vm.local-compiler
function vm.createRunner(loc)
    local self = setmetatable({
        loc      = loc,
        mainFunc = guide.getParentFunction(loc),
    }, mt)

    sortRefs(loc)

    return self
end
