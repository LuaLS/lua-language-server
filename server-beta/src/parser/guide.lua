local error = error

_ENV = nil

local m = {}

local blockTypes = {
    ['while']       = true,
    ['in']          = true,
    ['loop']        = true,
    ['repeat']      = true,
    ['do']          = true,
    ['function']    = true,
    ['ifblock']     = true,
    ['elseblock']   = true,
    ['elseifblock'] = true,
    ['main']        = true,
}

local breakBlockTypes = {
    ['while']       = true,
    ['in']          = true,
    ['loop']        = true,
    ['repeat']      = true,
}

--- 寻找所在函数
function m.getParentFunction(root, obj)
    for _ = 1, 1000 do
        obj = root[obj.parent]
        if not obj then
            break
        end
        local tp = obj.type
        if tp == 'function' then
            return obj
        end
    end
    return nil
end

--- 寻找所在区块
function m.getBlock(root, obj)
    for _ = 1, 1000 do
        if not obj then
            return nil
        end
        local tp = obj.type
        if blockTypes[tp] then
            return obj
        end
        obj = root[obj.parent]
    end
    error('guide.getBlock overstack')
end

--- 寻找所在父区块
function m.getParentBlock(root, obj)
    for _ = 1, 1000 do
        obj = root[obj.parent]
        if not obj then
            return nil
        end
        local tp = obj.type
        if blockTypes[tp] then
            return obj
        end
    end
    error('guide.getParentBlock overstack')
end

--- 寻找所在可break的父区块
function m.getBreakBlock(root, obj)
    for _ = 1, 1000 do
        obj = root[obj.parent]
        if not obj then
            return nil
        end
        local tp = obj.type
        if breakBlockTypes[tp] then
            return obj
        end
        if tp == 'function' then
            return nil
        end
    end
    error('guide.getBreakBlock overstack')
end

--- 寻找函数的不定参数，返回不定参在第几个参数上，以及该参数对象。
--- 如果函数是主函数，则返回`0, nil`。
---@return table
---@return integer
function m.getFunctionVarArgs(root, func)
    if func.type == 'main' then
        return 0, nil
    end
    if func.type ~= 'function' then
        return nil, nil
    end
    local args = root[func.args]
    if not args then
        return nil, nil
    end
    for i = 1, #args do
        local arg = root[args[i]]
        if arg.type == '...' then
            return i, arg
        end
    end
    return nil, nil
end

--- 获取指定区块中可见的局部变量
---@param root table
---@param block table
---@param name string {comment = '变量名'}
---@param pos integer {comment = '可见位置'}
function m.getLocal(root, block, name, pos)
    block = m.getBlock(root, block)
    for _ = 1, 1000 do
        if not block then
            return nil
        end
        local locals = block.locals
        local res
        if not locals then
            goto CONTINUE
        end
        for i = 1, #locals do
            local loc = root[locals[i]]
            if loc.effect > pos then
                break
            end
            if loc[1] == name then
                if not res or res.effect < loc.effect then
                    res = loc
                end
            end
        end
        if res then
            return res
        end
        ::CONTINUE::
        block = m.getParentBlock(root, block)
    end
    error('guide.getLocal overstack')
end

--- 获取指定区块中可见的标签
---@param root table
---@param block table
---@param name string {comment = '标签名'}
function m.getLabel(root, block, name)
    block = m.getBlock(root, block)
    for _ = 1, 1000 do
        if not block then
            return nil
        end
        local labels = block.labels
        if labels then
            local label = labels[name]
            if label then
                return root[label]
            end
        end
        if block.type == 'function' then
            return nil
        end
        block = m.getParentBlock(root, block)
    end
    error('guide.getLocal overstack')
end

return m
