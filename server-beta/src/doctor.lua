local type           = type
local next           = next
local ipairs         = ipairs
local rawget         = rawget
local pcall          = pcall
local getregistry    = debug.getregistry
local getmetatable   = debug.getmetatable
local getupvalue     = debug.getupvalue
local getuservalue   = debug.getuservalue
local getlocal       = debug.getlocal
local getinfo        = debug.getinfo
local maxinterger    = math.maxinteger
local mathType       = math.type
local tableConcat    = table.concat
local _G             = _G
local registry       = getregistry()
local tableSort      = table.sort

_ENV = nil

local m = {}

local function getTostring(obj)
    local mt = getmetatable(obj)
    if not mt then
        return nil
    end
    local toString = rawget(mt, '__tostring')
    if not toString then
        return nil
    end
    local suc, str = pcall(toString, obj)
    if not suc then
        return nil
    end
    if type(str) ~= 'string' then
        return nil
    end
    return str
end

local function formatName(obj)
    local tp = type(obj)
    if tp == 'nil' then
        return 'nil:nil'
    elseif tp == 'boolean' then
        if obj == true then
            return 'boolean:true'
        else
            return 'boolean:false'
        end
    elseif tp == 'number' then
        if mathType(obj) == 'integer' then
            return ('number:%d'):format(obj)
        else
            -- 如果浮点数可以完全表示为整数，那么就转换为整数
            local str = ('%.10f'):format(obj):gsub('%.?[0]+$', '')
            if str:find('.', 1, true) then
                -- 如果浮点数不能表示为整数，那么再加上它的精确表示法
                str = ('%s(%q)'):format(str, obj)
            end
            return 'number:' .. str
        end
    elseif tp == 'string' then
        local str = ('%q'):format(obj)
        if #str > 100 then
            local new = ('%s...(len=%d)'):format(str:sub(1, 100), #str)
            if #new < #str then
                str = new
            end
        end
        return 'string:' .. str
    elseif tp == 'function' then
        local info = getinfo(obj, 'S')
        if info.what == 'c' then
            return ('function:%p(C)'):format(obj)
        elseif info.what == 'main' then
            return ('function:%p(main)'):format(obj)
        else
            return ('function:%p(%s:%d-%d)'):format(obj, info.source, info.linedefined, info.lastlinedefined)
        end
    elseif tp == 'table' then
        local id = getTostring(obj)
        if not id then
            if obj == _G then
                id = '_G'
            elseif obj == registry then
                id = 'registry'
            end
        end
        if id then
            return ('table:%p(%s)'):format(obj, id)
        else
            return ('table:%p'):format(obj)
        end
    elseif tp == 'userdata' then
        local id = getTostring(obj)
        if id then
            return ('userdata:%p(%s)'):format(obj, id)
        else
            return ('userdata:%p'):format(obj)
        end
    else
        return ('%s:%p'):format(tp, obj)
    end
end

--- 内存快照
---@return table
function m.snapshot()
    local mark = {}
    local find

    local function findTable(t, result)
        result = result or {}
        local mt = getmetatable(t)
        local wk, wv
        if mt then
            local mode = rawget(mt, '__mode')
            if type(mode) == 'string' then
                if mode:find('k', 1, true) then
                    wk = true
                end
                if mode:find('v', 1, true) then
                    wv = true
                end
            end
        end
        for k, v in next, t do
            if not wk then
                local keyInfo = find(k)
                if keyInfo then
                    result[#result+1] = {
                        type = 'key',
                        name = formatName(k),
                        info = keyInfo,
                    }
                end
            end
            if not wv then
                local valueInfo = find(v)
                if valueInfo then
                    result[#result+1] = {
                        type = 'field',
                        name = formatName(k) .. '|' .. formatName(v),
                        info = valueInfo,
                    }
                end
            end
        end
        local MTInfo = find(getmetatable(t))
        if MTInfo then
            result[#result+1] = {
                type = 'metatable',
                name = '',
                info = MTInfo,
            }
        end
        if #result == 0 then
            return nil
        end
        return result
    end

    local function findFunction(f, result, trd, stack)
        result = result or {}
        for i = 1, maxinterger do
            local n, v = getupvalue(f, i)
            if not n then
                break
            end
            local valueInfo = find(v)
            if valueInfo then
                result[#result+1] = {
                    type = 'upvalue',
                    name = n,
                    info = valueInfo,
                }
            end
        end
        if trd then
            for i = 1, maxinterger do
                local n, l = getlocal(trd, stack, i)
                if not n then
                    break
                end
                local valueInfo = find(l)
                if valueInfo then
                    result[#result+1] = {
                        type = 'local',
                        name = n,
                        info = valueInfo,
                    }
                end
            end
        end
        if #result == 0 then
            return nil
        end
        return result
    end

    local function findUserData(u, result)
        result = result or {}
        for i = 1, maxinterger do
            local v, b = getuservalue(u, i)
            if not b then
                break
            end
            local valueInfo = find(v)
            if valueInfo then
                result[#result+1] = {
                    type = 'uservalue',
                    name = formatName(i),
                    info = valueInfo,
                }
            end
        end
        local MTInfo = find(getmetatable(u))
        if MTInfo then
            result[#result+1] = {
                type = 'metatable',
                name = '',
                info = MTInfo,
            }
        end
        if #result == 0 then
            return nil
        end
        return result
    end

    local function findThread(trd, result)
        -- 不查找主线程，主线程一定是临时的（视为弱引用）
        if trd == registry[1] then
            return nil
        end
        result = result or {}

        for i = 1, maxinterger do
            local info = getinfo(trd, i, 'Sf')
            if not info then
                break
            end
            local funcInfo = find(info.func, trd, i)
            if funcInfo then
                result[#result+1] = {
                    type = 'stack',
                    name = i .. '@' .. formatName(info.func),
                    info = funcInfo,
                }
            end
        end

        if #result == 0 then
            return nil
        end
        return result
    end

    function find(obj, trd, stack)
        if mark[obj] then
            return mark[obj]
        end
        local tp = type(obj)
        if tp == 'table' then
            mark[obj] = {}
            mark[obj] = findTable(obj, mark[obj])
        elseif tp == 'function' then
            mark[obj] = {}
            mark[obj] = findFunction(obj, mark[obj], trd, stack)
        elseif tp == 'userdata' then
            mark[obj] = {}
            mark[obj] = findUserData(obj, mark[obj])
        elseif tp == 'thread' then
            mark[obj] = {}
            mark[obj] = findThread(obj, mark[obj])
        else
            return nil
        end
        if mark[obj] then
            mark[obj].object = obj
        end
        return mark[obj]
    end

    return {
        name = formatName(registry),
        type = 'root',
        info = find(registry),
    }
end

--- 寻找对象的引用
---@return string
function m.catch(...)
    local targets = {}
    for _, target in ipairs {...} do
        targets[target] = true
    end
    local report = m.snapshot()
    local path = {}
    local result = {}
    local mark = {}

    local function push()
        result[#result+1] = tableConcat(path, ' => ')
    end

    local function search(t)
        path[#path+1] = ('(%s)%s'):format(t.type, t.name)
        local addTarget
        if targets[t.info.object] then
            targets[t.info.object] = nil
            addTarget = t.info.object
            push(t)
        end
        if not mark[t.info] then
            mark[t.info] = true
            for _, obj in ipairs(t.info) do
                search(obj)
            end
        end
        path[#path] = nil
        if addTarget then
            targets[addTarget] = true
        end
    end

    search(report)

    return result
end

--- 生成一个报告
---@return string
function m.report()
    local snapshot = m.snapshot()
    local cache = {}
    local mark = {}

    local function scan(t)
        local obj = t.info.object
        local tp = type(obj)
        if tp == 'table'
        or tp == 'userdata'
        or tp == 'function'
        or tp == 'string'
        or tp == 'thread' then
            local point = ('%p'):format(obj)
            if not cache[point] then
                cache[point] = {
                    point = point,
                    count = 0,
                    name  = formatName(obj),
                }
            end
            cache[point].count = cache[point].count + 1
        end
        if not mark[t.info] then
            mark[t.info] = true
            for _, child in ipairs(t.info) do
                scan(child)
            end
        end
    end

    scan(snapshot)

    local list = {}
    for _, info in next, cache do
        list[#list+1] = info
    end
    tableSort(list, function (a, b)
        return a.name < b.name
    end)
    return list
end

return m
