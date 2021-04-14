local linker = require 'core.linker'
local guide  = require 'parser.guide'

local osClock = os.clock
local pairs   = pairs

local m = {}

-- TODO: compatible
m.getRoot           = guide.getRoot
m.eachSource        = guide.eachSource
m.eachSourceType    = guide.eachSourceType
m.eachSourceContain = guide.eachSourceContain
m.eachSourceBetween = guide.eachSourceBetween
m.getStartFinish    = guide.getStartFinish
m.isLiteral         = guide.isLiteral

---@alias guide.searchmode '"ref"'|'"def"'|'"field"'

---添加结果
---@param status guide.status
---@param mode   guide.searchmode
---@param ref    parser.guide.object
---@param simple table
function m.pushResult(status, mode, ref, simple)
    local results = status.results
    if mode == 'def' then
        if ref.type == 'setglobal'
        or ref.type == 'setlocal'
        or ref.type == 'local' then
            results[#results+1] = ref
        elseif ref.type == 'setfield'
        or     ref.type == 'tablefield' then
            results[#results+1] = ref
        elseif ref.type == 'setmethod' then
            results[#results+1] = ref
        elseif ref.type == 'setindex'
        or     ref.type == 'tableindex' then
            results[#results+1] = ref
        elseif ref.type == 'call' then
            if ref.node.special == 'rawset' then
                results[#results+1] = ref
            end
        elseif ref.type == 'function' then
            results[#results+1] = ref
        elseif ref.type == 'table' then
            results[#results+1] = ref
        elseif ref.type == 'doc.type.function'
        or     ref.type == 'doc.class.name'
        or     ref.type == 'doc.alias.name'
        or     ref.type == 'doc.field'
        or     ref.type == 'doc.type.table'
        or     ref.type == 'doc.type.array' then
            results[#results+1] = ref
        elseif ref.type == 'doc.type' then
            if #ref.enums > 0 or #ref.resumes > 0 then
                results[#results+1] = ref
            end
        end
        if ref.parent and ref.parent.type == 'return' then
            if m.getParentFunction(ref) ~= m.getParentFunction(simple.node) then
                results[#results+1] = ref
            end
        end
        if  m.isLiteral(ref)
        and ref.parent and ref.parent.type == 'callargs'
        and ref ~= simple.node then
            results[#results+1] = ref
        end
    elseif mode == 'ref' then
        if ref.type == 'setfield'
        or ref.type == 'getfield'
        or ref.type == 'tablefield' then
            results[#results+1] = ref
        elseif ref.type == 'setmethod'
        or     ref.type == 'getmethod' then
            results[#results+1] = ref
        elseif ref.type == 'setindex'
        or     ref.type == 'getindex'
        or     ref.type == 'tableindex' then
            results[#results+1] = ref
        elseif ref.type == 'setglobal'
        or     ref.type == 'getglobal'
        or     ref.type == 'local'
        or     ref.type == 'setlocal'
        or     ref.type == 'getlocal' then
            results[#results+1] = ref
        elseif ref.type == 'function' then
            results[#results+1] = ref
        elseif ref.type == 'table' then
            results[#results+1] = ref
        elseif ref.type == 'call' then
            if ref.node.special == 'rawset'
            or ref.node.special == 'rawget' then
                results[#results+1] = ref
            end
        elseif ref.type == 'doc.type.function'
        or     ref.type == 'doc.class.name'
        or     ref.type == 'doc.alias.name'
        or     ref.type == 'doc.field'
        or     ref.type == 'doc.type.table'
        or     ref.type == 'doc.type.array' then
            results[#results+1] = ref
        elseif ref.type == 'doc.type' then
            if #ref.enums > 0 or #ref.resumes > 0 then
                results[#results+1] = ref
            end
        end
        if ref.parent and ref.parent.type == 'return' then
            results[#results+1] = ref
        end
        if  guide.isLiteral(ref)
        and ref.parent
        and ref.parent.type == 'callargs'
        and ref ~= simple.node then
            results[#results+1] = ref
        end
    elseif mode == 'field' then
        if ref.type == 'setfield'
        or ref.type == 'getfield'
        or ref.type == 'tablefield' then
            results[#results+1] = ref
        elseif ref.type == 'setmethod'
        or     ref.type == 'getmethod' then
            results[#results+1] = ref
        elseif ref.type == 'setindex'
        or     ref.type == 'tableindex' then
            results[#results+1] = ref
        elseif ref.type == 'getindex' then
            -- do not trust `t[1]`
            if ref.index and ref.index.type == 'string' then
                results[#results+1] = ref
            end
        elseif ref.type == 'setglobal'
        or     ref.type == 'getglobal' then
            results[#results+1] = ref
        elseif ref.type == 'call' then
            if ref.node.special == 'rawset'
            or ref.node.special == 'rawget' then
                results[#results+1] = ref
            end
        elseif ref.type == 'doc.field' then
            results[#results+1] = ref
        end
    elseif mode == 'deffield' then
        if ref.type == 'setfield'
        or ref.type == 'tablefield' then
            results[#results+1] = ref
        elseif ref.type == 'setmethod' then
            results[#results+1] = ref
        elseif ref.type == 'setindex'
        or     ref.type == 'tableindex' then
            results[#results+1] = ref
        elseif ref.type == 'setglobal' then
            results[#results+1] = ref
        elseif ref.type == 'call' then
            if ref.node.special == 'rawset' then
                results[#results+1] = ref
            end
        elseif ref.type == 'doc.field' then
            results[#results+1] = ref
        end
    end
end

---获取uri
---@param  obj parser.guide.object
---@return uri
function m.getUri(obj)
    if obj.uri then
        return obj.uri
    end
    local root = m.getRoot(obj)
    if root then
        return root.uri
    end
    return ''
end

-- TODO
function m.findGlobals(root)
    linker.compileLinks(root)
    -- TODO
    return {}
end

-- TODO
function m.isGlobal(source)
    return false
end

---搜索对象的引用
---@param status guide.status
---@param obj    parser.guide.object
---@param mode   guide.searchmode
function m.searchRefs(status, obj, mode)
    local root = guide.getRoot(obj)
    linker.compileLinks(root)

    local links = linker.getLinkersBySource(obj)
    if links then
        for _, link in ipairs(links) do
            m.pushResult(status, mode, link.source)
        end
    end
end

---@class guide.status
---搜索结果
---@field results parser.guide.object[]

---创建搜索状态
---@param parentStatus guide.status
---@param interface table
---@param deep integer
---@return guide.status
function m.status(parentStatus, interface, deep)
    local status = {
        share     = parentStatus and parentStatus.share       or {
            count = 0,
            cacheLock = {},
        },
        depth     = parentStatus and (parentStatus.depth + 1) or 0,
        searchDeep= parentStatus and parentStatus.searchDeep  or deep or -999,
        interface = parentStatus and parentStatus.interface   or {},
        deep      = parentStatus and parentStatus.deep,
        clock     = parentStatus and parentStatus.clock       or osClock(),
        results   = {},
    }
    if interface then
        for k, v in pairs(interface) do
            status.interface[k] = v
        end
    end
    status.deep = status.depth <= status.searchDeep
    return status
end

--- 请求对象的引用
---@param obj parser.guide.object
---@param interface table
---@param deep integer
---@return parser.guide.object[]
---@return integer
function m.requestReference(obj, interface, deep)
    local status = m.status(nil, interface, deep)
    -- 根据 field 搜索引用
    m.searchRefs(status, obj, 'ref')

    return status.results, 0
end

return m
