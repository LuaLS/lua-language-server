local linker = require 'core.linker'
local guide  = require 'parser.guide'

local osClock = os.clock
local pairs   = pairs

local SEARCH_FLAG = {
    ['forward']  = 1 << 0,
    ['backward'] = 1 << 1,
}

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
function m.pushResult(status, mode, ref)
    local results = status.results
    if mode == 'def' then
        if ref.type == 'local'
        or ref.type == 'setlocal'
        or ref.type == 'setglobal'
        or ref.type == 'label'
        or ref.type == 'setfield'
        or ref.type == 'setmethod'
        or ref.type == 'setindex'
        or ref.type == 'tableindex'
        or ref.type == 'tablefield' then
            results[#results+1] = ref
        end
    elseif mode == 'ref' then
        if ref.type == 'local'
        or ref.type == 'setlocal'
        or ref.type == 'getlocal'
        or ref.type == 'setglobal'
        or ref.type == 'getglobal'
        or ref.type == 'label'
        or ref.type == 'goto'
        or ref.type == 'setfield'
        or ref.type == 'getfield'
        or ref.type == 'setmethod'
        or ref.type == 'getmethod'
        or ref.type == 'setindex'
        or ref.type == 'getindex'
        or ref.type == 'tableindex'
        or ref.type == 'tablefield' then
            results[#results+1] = ref
        end
    elseif mode == 'field' then
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
---@param source parser.guide.object
---@param mode   guide.searchmode
function m.searchRefs(status, source, mode)
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    local root = guide.getRoot(source)
    linker.compileLinks(root)

    if not linker.getLink(source) then
        return
    end

    local search

    local function seachSource(obj, field, flag)
        local link = linker.getLink(obj)
        if not link then
            return
        end
        local id = link.id
        if field then
            id = id .. field
        end
        search(id, nil, flag)
    end

    local function checkForward(link, field, flag)
        if not link.forward then
            return
        end
        for _, forwardSources in ipairs(link.forward) do
            seachSource(forwardSources, field, flag)
        end
    end

    local function checkBackward(link, field, flag)
        if not link.backward then
            return
        end
        for _, backSources in ipairs(link.backward) do
            seachSource(backSources, field, flag)
        end
    end

    ---@param id string
    ---@param expect string
    local function checkLastID(id, expect)
        local lastID = linker.getLastID(root, id)
        if not lastID then
            return
        end
        expect = expect:sub(#lastID + 2)
        pushQueue(lastID, expect)
    end

    local stackCount = 0
    local mark = {}
    search = function (id, field, flag)
        if mark[id] then
            return
        end
        mark[id] = true
        local links = linker.getLinksByID(root, id)
        if not links then
            return
        end
        stackCount = stackCount + 1
        if stackCount >= 10 then
            error('stack overflow')
        end
        flag = flag or 0
        for _, eachLink in ipairs(links) do
            if field == nil then
                m.pushResult(status, mode, eachLink.source)
            end
            if flag & SEARCH_FLAG.backward == 0 then
                checkForward(eachLink,  field, flag | SEARCH_FLAG.forward)
            end
            if flag & SEARCH_FLAG.forward  == 0 then
                checkBackward(eachLink, field, flag | SEARCH_FLAG.backward)
            end
        end
        local lastID = linker.getLastID(root, id)
        if lastID then
            local newField = id:sub(#lastID + 1)
            if field then
                newField = newField .. field
            end
            search(lastID, newField, flag)
        end
        --checkLastID(id, expect)
        stackCount = stackCount - 1
    end

    seachSource(source)
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
---@param obj       parser.guide.object
---@param interface table
---@param deep      integer
---@return parser.guide.object[]
---@return integer
function m.requestReference(obj, interface, deep)
    local status = m.status(nil, interface, deep)
    -- 根据 field 搜索引用
    m.searchRefs(status, obj, 'ref')

    return status.results, 0
end

return m
