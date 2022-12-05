local type           = type
local next           = next
local pairs          = pairs
local ipairs         = ipairs
local rawget         = rawget
local rawset         = rawset
local pcall          = pcall
local tostring       = tostring
local select         = select
local stderr         = io.stderr
local sformat        = string.format
local getregistry    = debug.getregistry
local getmetatable   = debug.getmetatable
local getupvalue     = debug.getupvalue
---@diagnostic disable-next-line: deprecated
local getuservalue   = debug.getuservalue or debug.getfenv
local getlocal       = debug.getlocal
local getinfo        = debug.getinfo
local maxinterger    = 10000
local mathType       = math.type
local _G             = _G
local registry       = getregistry()
local ccreate        = coroutine.create

_ENV = nil

local hasPoint       = pcall(sformat, '%p', _G)
local multiUserValue = not pcall(getuservalue, stderr, '')

local function getPoint(obj)
    if hasPoint then
        return ('%p'):format(obj)
    else
        local mt = getmetatable(obj)
        local ts
        if mt then
            ts = rawget(mt, '__tostring')
            if ts then
                rawset(mt, '__tostring', nil)
            end
        end
        local name = tostring(obj)
        if ts then
            rawset(mt, '__tostring', ts)
        end
        return name:match(': (.+)')
    end
end

local function formatObject(obj, tp, ext)
    local text = ('%s:%s'):format(tp, getPoint(obj))
    if ext then
        text = ('%s(%s)'):format(text, ext)
    end
    return text
end

local function isInteger(obj)
    if mathType then
        return mathType(obj) == 'integer'
    else
        return obj % 1 == 0
    end
end

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
        if isInteger(obj) then
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
            return formatObject(obj, 'function', 'C')
        elseif info.what == 'main' then
            return formatObject(obj, 'function', 'main')
        else
            return formatObject(obj, 'function', ('%s:%d-%d'):format(info.source, info.linedefined, info.lastlinedefined))
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
            return formatObject(obj, 'table', id)
        else
            return formatObject(obj, 'table')
        end
    elseif tp == 'userdata' then
        local id = getTostring(obj)
        if id then
            return formatObject(obj, 'userdata', id)
        else
            return formatObject(obj, 'userdata')
        end
    else
        return formatObject(obj, tp)
    end
end

local _private = {}

---@generic T
---@param o T
---@return T
local function private(o)
    if not o then
        return nil
    end
    _private[o] = true
    return o
end

local m = private {}

m._ignoreMainThread = true

--- 获取内存快照，生成一个内部数据结构。
--- 一般不用这个API，改用 report 或 catch。
---@return table
m.snapshot = private(function ()
    if m._lastCache then
        return m._lastCache
    end

    local exclude = {}
    if m._exclude then
        for _, o in ipairs(m._exclude) do
            exclude[o] = true
        end
    end
    ---@generic T
    ---@param o T
    ---@return T
    local function private(o)
        if not o then
            return nil
        end
        exclude[o] = true
        return o
    end

    private(exclude)

    local find
    local mark = private {}

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
                    if wv then
                        find(v)
                        local valueResults = mark[v]
                        if valueResults then
                            valueResults[#valueResults+1] = private {
                                type = 'weakvalue-key',
                                name = formatName(t) .. '|' .. formatName(v),
                                info = keyInfo,
                            }
                        end
                    else
                        result[#result+1] = private {
                            type = 'key',
                            name = formatName(k),
                            info = keyInfo,
                        }
                    end
                end
            end
            if not wv then
                local valueInfo = find(v)
                if valueInfo then
                    if wk then
                        find(k)
                        local keyResults = mark[k]
                        if keyResults then
                            keyResults[#keyResults+1] = private {
                                type = 'weakkey-field',
                                name = formatName(t) .. '|' .. formatName(k),
                                info = valueInfo,
                            }
                        end
                    else
                        result[#result+1] = private {
                            type = 'field',
                            name = formatName(k) .. '|' .. formatName(v),
                            info = valueInfo,
                        }
                    end
                end
            end
        end
        local MTInfo = find(getmetatable(t))
        if MTInfo then
            result[#result+1] = private {
                type = 'metatable',
                name = '',
                info = MTInfo,
            }
        end
        return result
    end

    local function findFunction(f, result)
        result = result or {}
        for i = 1, maxinterger do
            local n, v = getupvalue(f, i)
            if not n then
                break
            end
            local valueInfo = find(v)
            if valueInfo then
                result[#result+1] = private {
                    type = 'upvalue',
                    name = n,
                    info = valueInfo,
                }
            end
        end
        return result
    end

    local function findUserData(u, result)
        result = result or {}
        local maxUserValue = multiUserValue and maxinterger or 1
        for i = 1, maxUserValue do
            local v, b = getuservalue(u, i)
            if not b then
                break
            end
            local valueInfo = find(v)
            if valueInfo then
                result[#result+1] = private {
                    type = 'uservalue',
                    name = formatName(i),
                    info = valueInfo,
                }
            end
        end
        local MTInfo = find(getmetatable(u))
        if MTInfo then
            result[#result+1] = private {
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
        if m._ignoreMainThread and trd == registry[1] then
            return nil
        end
        result = result or private {}

        for i = 1, maxinterger do
            local info = getinfo(trd, i, 'Sf')
            if not info then
                break
            end
            local funcInfo = find(info.func)
            if funcInfo then
                for ln = 1, maxinterger do
                    local n, l = getlocal(trd, i, ln)
                    if not n then
                        break
                    end
                    local valueInfo = find(l)
                    if valueInfo then
                        funcInfo[#funcInfo+1] = private {
                            type = 'local',
                            name = n,
                            info = valueInfo,
                        }
                    end
                end
                result[#result+1] = private {
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

    local function findMainThread()
        -- 不查找主线程，主线程一定是临时的（视为弱引用）
        if m._ignoreMainThread then
            return nil
        end
        local result = private {}

        for i = 1, maxinterger do
            local info = getinfo(i, 'Sf')
            if not info then
                break
            end
            local funcInfo = find(info.func)
            if funcInfo then
                for ln = 1, maxinterger do
                    local n, l = getlocal(i, ln)
                    if not n then
                        break
                    end
                    local valueInfo = find(l)
                    if valueInfo then
                        funcInfo[#funcInfo+1] = private {
                            type = 'local',
                            name = n,
                            info = valueInfo,
                        }
                    end
                end
                result[#result+1] = private {
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

    function find(obj)
        if mark[obj] then
            return mark[obj]
        end
        if exclude[obj] or _private[obj] then
            return nil
        end
        local tp = type(obj)
        if tp == 'table' then
            mark[obj] = private {}
            mark[obj] = findTable(obj, mark[obj])
        elseif tp == 'function' then
            mark[obj] = private {}
            mark[obj] = findFunction(obj, mark[obj])
        elseif tp == 'userdata' then
            mark[obj] = private {}
            mark[obj] = findUserData(obj, mark[obj])
        elseif tp == 'thread' then
            mark[obj] = private {}
            mark[obj] = findThread(obj, mark[obj])
        else
            return nil
        end
        if mark[obj] then
            mark[obj].object = obj
        end
        return mark[obj]
    end

    -- TODO: Lua 5.1中，主线程与_G都不在注册表里
    local result = private {
        name = formatName(registry),
        type = 'root',
        info = find(registry),
    }
    if not registry[1] then
        result.info[#result.info+1] = private {
            type = 'thread',
            name = 'main',
            info = findMainThread(),
        }
    end
    if not registry[2] then
        result.info[#result.info+1] = private {
            type = '_G',
            name = '_G',
            info = find(_G),
        }
    end
    for name, mt in next, private {
        ['nil']       = getmetatable(nil),
        ['boolean']   = getmetatable(true),
        ['number']    = getmetatable(0),
        ['string']    = getmetatable(''),
        ['function']  = getmetatable(function () end),
        ['thread']    = getmetatable(ccreate(function () end)),
    } do
        result.info[#result.info+1] = private {
            type = 'metatable',
            name = name,
            info = find(mt),
        }
    end
    if m._cache then
        m._lastCache = result
    end
    return result
end)

--- 遍历虚拟机，寻找对象的引用。
--- 输入既可以是对象实体，也可以是对象的描述（从其他接口的返回值中复制过来）。
--- 返回字符串数组的数组，每个字符串描述了如何从根节点引用到指定的对象。
--- 可以同时查找多个对象。
---@return string[][]
m.catch = private(function (...)
    local targets = {}
    for i = 1, select('#', ...) do
        local target = select(i, ...)
        if target ~= nil then
            targets[target] = true
        end
    end
    local report = m.snapshot()
    local path =   {}
    local result = {}
    local mark =   {}

    local function push()
        local resultPath = {}
        for i = 1, #path do
            resultPath[i] = path[i]
        end
        result[#result+1] = resultPath
    end

    local function search(t)
        path[#path+1] = ('(%s)%s'):format(t.type, t.name)
        local addTarget
        local point = getPoint(t.info.object)
        if targets[t.info.object] then
            targets[t.info.object] = nil
            addTarget = t.info.object
            push()
        end
        if targets[point] then
            targets[point] = nil
            addTarget = point
            push()
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
end)

---@alias report {point: string, count: integer, name: string, childs: integer}

--- 生成一个内存快照的报告。
--- 你应当将其输出到一个文件里再查看。
---@return report[]
m.report = private(function ()
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
            local point = getPoint(obj)
            if not cache[point] then
                cache[point] = {
                    point  = point,
                    count  = 0,
                    name   = formatName(obj),
                    childs = #t.info,
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
    for _, info in pairs(cache) do
        list[#list+1] = info
    end
    return list
end)

--- 在进行快照相关操作时排除掉的对象。
--- 你可以用这个功能排除掉一些数据表。
m.exclude = private(function (...)
    m._exclude = {...}
end)

--- 比较2个报告
---@return table
m.compare = private(function (old, new)
    local newHash = {}
    local ret = {}
    for _, info in ipairs(new) do
        newHash[info.point] = info
    end
    for _, info in ipairs(old) do
        if newHash[info.point] then
            ret[#ret + 1] = {
                old = info,
                new = newHash[info.point]
            }
        end
    end
    return ret
end)

--- 是否忽略主线程的栈
---@param flag boolean
m.ignoreMainThread = private(function (flag)
    m._ignoreMainThread = flag
end)

--- 是否启用缓存，启用后会始终使用第一次查找的结果，
--- 适用于连续查找引用。如果想要查找新的引用需要先关闭缓存。
---@param flag boolean
m.enableCache = private(function (flag)
    if flag then
        m._cache = true
    else
        m._cache = false
        m._lastCache = nil
    end
end)

--- 立即清除缓存
m.flushCache = private(function ()
    m._lastCache = nil
end)

private(getinfo(1, 'f').func)

return m
