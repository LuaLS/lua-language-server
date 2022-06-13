---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'

---@alias vm.runner.callback fun(src: parser.object, node: vm.node)

---@class vm.runner
---@field _loc      parser.object
---@field _objs     parser.object[]
---@field _callback vm.runner.callback
local mt = {}
mt.__index = mt
mt._index = 1

---@return parser.object[]
function mt:_getCasts()
    local root = guide.getRoot(self._loc)
    if not root._casts then
        root._casts = {}
        local docs = root.docs
        for _, doc in ipairs(docs) do
            if doc.type == 'doc.cast' and doc.loc then
                root._casts[#root._casts+1] = doc
            end
        end
    end
    return root._casts
end

function mt:_collect()
    local startPos  = self._loc.start
    local finishPos = 0

    for _, ref in ipairs(self._loc.ref) do
        if ref.type == 'getlocal'
        or ref.type == 'setlocal' then
            self._objs[#self._objs+1] = ref
            if ref.start > finishPos then
                finishPos = ref.start
            end
        end
    end

    if #self._objs == 0 then
        return
    end

    local casts = self:_getCasts()
    for _, cast in ipairs(casts) do
        if  cast.loc[1] == self._loc[1]
        and cast.start > startPos
        and cast.finish < finishPos
        and guide.getLocal(self._loc, self._loc[1], cast.start) == self._loc then
            self._objs[#self._objs+1] = cast
        end
    end

    table.sort(self._objs, function (a, b)
        return (a.range or a.start) < (b.range or b.start)
    end)
end


---@param pos  integer
---@param node vm.node
---@return parser.object
---@return vm.node
function mt:_fastWard(pos, node)
    for i = self._index, #self._objs do
        local obj = self._objs[i]
        if obj.start > pos then
            self._index = i
            return obj, node
        end
        if obj.type == 'getlocal'
        or obj.type == 'setlocal' then
            node = self._callback(obj, node) or node
        else
            error('unexpected type: ' .. obj.type)
        end
    end
end

---@param block parser.object
---@param node  vm.node
function mt:_launchBlock(block, node)
    local top, topNode = self:_fastWard(block.start, node)
    if not top then
        return
    end
    for _, action in ipairs(block) do
        if action.finish < top.start then
            goto CONTINUE
        end
        top, topNode = self:_fastWard(action.finish, topNode)
        if not top then
            return
        end
        ::CONTINUE::
    end
    self:_fastWard(math.huge, topNode)
end

---@param loc parser.object
---@param callback vm.runner.callback
function vm.launchRunner(loc, callback)
    local self = setmetatable({
        _loc      = loc,
        _objs     = {},
        _callback = callback,
    }, mt)

    self:_collect()

    if #self._objs == 0 then
        return
    end

    self:_launchBlock(guide.getParentBlock(loc), vm.getNode(loc))
end
