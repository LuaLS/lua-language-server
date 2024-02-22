local util  = require 'utility'
local scope = require 'workspace.scope'
local guide = require 'parser.guide'
local config = require 'config'
---@class vm
local vm    = require 'vm.vm'

---@type table<string, vm.global>
local allGlobals = {}
---@type table<uri, table<string, boolean>>
local globalSubs = util.multiTable(2)

---@class parser.object
---@field package _globalBase parser.object
---@field package _globalBaseMap table<string, parser.object>
---@field global vm.global

---@class vm.global.link
---@field sets parser.object[]
---@field gets parser.object[]

---@class vm.global
---@field links table<uri, vm.global.link>
---@field setsCache? table<uri, parser.object[]>
---@field cate vm.global.cate
local mt = {}
mt.__index = mt
mt.type = 'global'
mt.name = ''

---@param uri    uri
---@param source parser.object
function mt:addSet(uri, source)
    local link = self.links[uri]
    link.sets[#link.sets+1] = source
    self.setsCache = nil
end

---@param uri    uri
---@param source parser.object
function mt:addGet(uri, source)
    local link = self.links[uri]
    link.gets[#link.gets+1] = source
end

---@param suri uri
---@return parser.object[]
function mt:getSets(suri)
    if not self.setsCache then
        self.setsCache = {}
    end
    local scp = scope.getScope(suri)
    local cacheUri = scp.uri or '<callback>'
    if self.setsCache[cacheUri] then
        return self.setsCache[cacheUri]
    end
    local clock = os.clock()
    self.setsCache[cacheUri] = {}
    local cache = self.setsCache[cacheUri]
    for uri, link in pairs(self.links) do
        if link.sets then
            if scp:isVisible(uri) then
                for _, source in ipairs(link.sets) do
                    cache[#cache+1] = source
                end
            end
        end
    end
    local cost = os.clock() - clock
    if cost > 0.1 then
        log.warn('global-manager getSets costs', cost, self.name)
    end
    return cache
end

---@return parser.object[]
function mt:getAllSets()
    if not self.setsCache then
        self.setsCache = {}
    end
    local cache = self.setsCache['*']
    if cache then
        return cache
    end
    cache = {}
    self.setsCache['*'] = cache
    for _, link in pairs(self.links) do
        if link.sets then
            for _, source in ipairs(link.sets) do
                cache[#cache+1] = source
            end
        end
    end
    return cache
end

---@param uri uri
function mt:dropUri(uri)
    self.links[uri] = nil
    self.setsCache = nil
end

---@return string
function mt:getName()
    return self.name
end

---@return string
function mt:getCodeName()
    return (self.name:gsub(vm.ID_SPLITE, '.'))
end

---@return string
function mt:asKeyName()
    return self.cate .. '|' .. self.name
end

---@return string
function mt:getKeyName()
    return self.name:match('[^' .. vm.ID_SPLITE .. ']+$')
end

---@return string?
function mt:getFieldName()
    return self.name:match(vm.ID_SPLITE .. '(.-)$')
end

---@return boolean
function mt:isAlive()
    return next(self.links) ~= nil
end

---@param uri uri
---@return parser.object?
function mt:getParentBase(uri)
    local parentID = self.name:match('^(.-)' .. vm.ID_SPLITE)
    if not parentID then
        return nil
    end
    local parentName = self.cate .. '|' .. parentID
    local global = allGlobals[parentName]
    if not global then
        return nil
    end
    local link = global.links[uri]
    if not link then
        return nil
    end
    local luckyBoy = link.sets[1] or link.gets[1]
    if not luckyBoy then
        return nil
    end
    return vm.getGlobalBase(luckyBoy)
end

---@param cate vm.global.cate
---@return vm.global
local function createGlobal(name, cate)
    return setmetatable({
        name  = name,
        cate  = cate,
        links = util.multiTable(2, function ()
            return {
                sets = {},
                gets = {},
            }
        end),
    }, mt)
end

---@class parser.object
---@field package _globalNode vm.global|false
---@field package _enums?     parser.object[]

local compileObject
local compilerGlobalSwitch = util.switch()
    : case 'local'
    : call(function (source)
        if source.special ~= '_G' then
            return
        end
        if source.ref then
            for _, ref in ipairs(source.ref) do
                compileObject(ref)
            end
        end
    end)
    : case 'getlocal'
    : call(function (source)
        if source.special ~= '_G' then
            return
        end
        if not source.next then
            return
        end
        compileObject(source.next)
    end)
    : case 'setglobal'
    : call(function (source)
        local uri    = guide.getUri(source)
        local name   = guide.getKeyName(source)
        if not name then
            return
        end
        local global = vm.declareGlobal('variable', name, uri)
        global:addSet(uri, source)
        source._globalNode = global
    end)
    : case 'getglobal'
    : call(function (source)
        local uri    = guide.getUri(source)
        local name   = guide.getKeyName(source)
        if not name then
            return
        end
        local global = vm.declareGlobal('variable', name, uri)
        global:addGet(uri, source)
        source._globalNode = global

        local nxt = source.next
        if nxt then
            compileObject(nxt)
        end
    end)
    : case 'setfield'
    : case 'setmethod'
    : case 'setindex'
    ---@param source parser.object
    : call(function (source)
        local name
        local keyName = guide.getKeyName(source)
        if not keyName then
            return
        end
        if source.node._globalNode then
            local parentName = source.node._globalNode:getName()
            if parentName == '_G' then
                name = keyName
            else
                name = ('%s%s%s'):format(parentName, vm.ID_SPLITE, keyName)
            end
        elseif source.node.special == '_G' then
            name = keyName
        end
        if not name then
            return
        end
        local uri    = guide.getUri(source)
        local global = vm.declareGlobal('variable', name, uri)
        global:addSet(uri, source)
        source._globalNode = global
    end)
    : case 'getfield'
    : case 'getmethod'
    : case 'getindex'
    ---@param source parser.object
    : call(function (source)
        local name
        local keyName = guide.getKeyName(source)
        if not keyName then
            return
        end
        if source.node._globalNode then
            local parentName = source.node._globalNode:getName()
            if parentName == '_G' then
                name = keyName
            else
                name = ('%s%s%s'):format(parentName, vm.ID_SPLITE, keyName)
            end
        elseif source.node.special == '_G' then
            name = keyName
        end
        local uri    = guide.getUri(source)
        local global = vm.declareGlobal('variable', name, uri)
        global:addGet(uri, source)
        source._globalNode = global

        local nxt = source.next
        if nxt then
            compileObject(nxt)
        end
    end)
    : case 'call'
    : call(function (source)
        if source.node.special == 'rawset'
        or source.node.special == 'rawget' then
            if not source.args then
                return
            end
            local g     = source.args[1]
            local key   = source.args[2]
            if g and key and g.special == '_G' then
                local name = guide.getKeyName(key)
                if name then
                    local uri    = guide.getUri(source)
                    local global = vm.declareGlobal('variable', name, uri)
                    if source.node.special == 'rawset' then
                        global:addSet(uri, source)
                        source.value = source.args[3]
                    else
                        global:addGet(uri, source)
                    end
                    source._globalNode = global

                    local nxt = source.next
                    if nxt then
                        compileObject(nxt)
                    end
                end
            end
        end
    end)
    : case 'doc.class'
    ---@param source parser.object
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = guide.getKeyName(source)
        if not name then
            return
        end
        local class = vm.declareGlobal('type', name, uri)
        class:addSet(uri, source)
        source._globalNode = class

        if source.signs then
            local sign = vm.createSign()
            vm.setSign(source, sign)
            for _, obj in ipairs(source.signs) do
                sign:addSign(vm.compileNode(obj))
            end
            if source.extends then
                for _, ext in ipairs(source.extends) do
                    if ext.type == 'doc.type.table' then
                        vm.setGeneric(ext, vm.createGeneric(ext, sign))
                    end
                end
            end
        end
    end)
    : case 'doc.alias'
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = guide.getKeyName(source)
        if not name then
            return
        end
        local alias = vm.declareGlobal('type', name, uri)
        alias:addSet(uri, source)
        source._globalNode = alias

        if source.signs then
            source._sign = vm.createSign()
            for _, sign in ipairs(source.signs) do
                source._sign:addSign(vm.compileNode(sign))
            end
            source.extends._generic = vm.createGeneric(source.extends, source._sign)
        end
    end)
    : case 'doc.enum'
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = guide.getKeyName(source)
        if not name then
            return
        end
        local enum = vm.declareGlobal('type', name, uri)
        enum:addSet(uri, source)
        source._globalNode = enum

        local tbl = source.bindSource
        if not tbl then
            return
        end
        source._enums = {}
        if vm.docHasAttr(source, 'key') then
            for _, field in ipairs(tbl) do
                if     field.type == 'tablefield' then
                    source._enums[#source._enums+1] = {
                        type   = 'doc.type.string',
                        start  = field.field.start,
                        finish = field.field.finish,
                        [1]    = field.field[1],
                    }
                elseif field.type == 'tableindex' then
                    source._enums[#source._enums+1] = {
                        type   = 'doc.type.string',
                        start  = field.index.start,
                        finish = field.index.finish,
                        [1]    = field.index[1],
                    }
                end
            end
        else
            for _, field in ipairs(tbl) do
                if     field.type == 'tablefield' then
                    source._enums[#source._enums+1] = field
                    local subType = vm.declareGlobal('type', name .. '.' .. field.field[1], uri)
                    subType:addSet(uri, field)
                elseif field.type == 'tableindex' then
                    source._enums[#source._enums+1] = field
                    if field.index.type == 'string' then
                        local subType = vm.declareGlobal('type', name .. '.' .. field.index[1], uri)
                        subType:addSet(uri, field)
                    end
                end
            end
        end
    end)
    : case 'doc.type.name'
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = source[1]
        if name == '_' then
            return
        end
        if name == 'self' then
            return
        end
        local type = vm.declareGlobal('type', name, uri)
        type:addGet(uri, source)
        source._globalNode = type
    end)
    : case 'doc.extends.name'
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = source[1]
        local class = vm.declareGlobal('type', name, uri)
        class:addGet(uri, source)
        source._globalNode = class
    end)


---@alias vm.global.cate '"variable"' | '"type"'

---@param cate vm.global.cate
---@param name string
---@param uri? uri
---@return vm.global
function vm.declareGlobal(cate, name, uri)
    local key = cate .. '|' .. name
    if uri then
        globalSubs[uri][key] = true
    end
    if not allGlobals[key] then
        allGlobals[key] = createGlobal(name, cate)
    end
    return allGlobals[key]
end

---@param cate   vm.global.cate
---@param name   string
---@param field? string
---@return vm.global?
function vm.getGlobal(cate, name, field)
    local key = cate .. '|' .. name
    if field then
        key = key .. vm.ID_SPLITE .. field
    end
    return allGlobals[key]
end

---@param cate   vm.global.cate
---@param name   string
---@return vm.global[]
function vm.getGlobalFields(cate, name)
    local globals = {}
    local key = cate .. '|' .. name

    local clock = os.clock()
    for gid, global in pairs(allGlobals) do
        if  gid ~= key
        and util.stringStartWith(gid, key)
        and gid:sub(#key + 1, #key + 1) == vm.ID_SPLITE
        and not gid:find(vm.ID_SPLITE, #key + 2) then
            globals[#globals+1] = global
        end
    end
    local cost = os.clock() - clock
    if cost > 0.1 then
        log.warn('global-manager getFields costs', cost)
    end

    return globals
end

---@param cate   vm.global.cate
---@return vm.global[]
function vm.getGlobals(cate)
    local globals = {}

    local clock = os.clock()
    for gid, global in pairs(allGlobals) do
        if  util.stringStartWith(gid, cate)
        and not gid:find(vm.ID_SPLITE) then
            globals[#globals+1] = global
        end
    end
    local cost = os.clock() - clock
    if cost > 0.1 then
        log.warn('global-manager getGlobals costs', cost)
    end

    return globals
end

---@return table<string, vm.global>
function vm.getAllGlobals()
    return allGlobals
end

---@param suri uri
---@param cate   vm.global.cate
---@return parser.object[]
function vm.getGlobalSets(suri, cate)
    local globals = vm.getGlobals(cate)
    local result = {}
    for _, global in ipairs(globals) do
        local sets = global:getSets(suri)
        for _, set in ipairs(sets) do
            result[#result+1] = set
        end
    end
    return result
end

---@param suri uri
---@param cate vm.global.cate
---@param name string
---@return boolean
function vm.hasGlobalSets(suri, cate, name)
    local global = vm.getGlobal(cate, name)
    if not global then
        return false
    end
    local sets = global:getSets(suri)
    if #sets == 0 then
        return false
    end
    return true
end

---@param src parser.object
local function checkIsUndefinedGlobal(src)
    local key = src[1]

    local uri = guide.getUri(src)
    local dglobals = util.arrayToHash(config.get(uri, 'Lua.diagnostics.globals'))
    local rspecial = config.get(uri, 'Lua.runtime.special')

    local node = src.node
    return src.type == 'getglobal' and key and not (
        dglobals[key] or
        rspecial[key] or
        node.tag ~= '_ENV' or
        vm.hasGlobalSets(uri, 'variable', key)
    )
end

---@param src parser.object
---@return boolean
function vm.isUndefinedGlobal(src)
    local node = vm.compileNode(src)
    if node.undefinedGlobal == nil then
        node.undefinedGlobal = checkIsUndefinedGlobal(src)
    end
    return node.undefinedGlobal
end

---@param source parser.object
function compileObject(source)
    if source._globalNode ~= nil then
        return
    end
    source._globalNode = false
    compilerGlobalSwitch(source.type, source)
end

---@param source parser.object
---@return vm.global?
function vm.getGlobalNode(source)
    return source._globalNode or nil
end

---@param source parser.object
---@return parser.object[]?
function vm.getEnums(source)
    return source._enums
end

---@param source parser.object
---@return boolean
function vm.compileByGlobal(source)
    local global = vm.getGlobalNode(source)
    if not global then
        return false
    end
    vm.setNode(source, global)
    if global.cate == 'variable' then
        if guide.isAssign(source) then
            if vm.bindDocs(source) then
                return true
            end
            if source.value and source.value.type ~= 'nil' then
                vm.setNode(source, vm.compileNode(source.value))
                return true
            end
        else
            if vm.bindAs(source) then
                return true
            end
            local node = vm.traceNode(source)
            if node then
                vm.setNode(source, node, true)
                return true
            end
        end
    end
    local globalBase = vm.getGlobalBase(source)
    if not globalBase then
        return false
    end
    local globalNode = vm.compileNode(globalBase)
    vm.setNode(source, globalNode, true)
    return true
end

---@param source parser.object
---@return parser.object?
function vm.getGlobalBase(source)
    if source._globalBase then
        return source._globalBase
    end
    local global = vm.getGlobalNode(source)
    if not global then
        return nil
    end
    ---@cast source parser.object
    local root = guide.getRoot(source)
    if not root._globalBaseMap then
        root._globalBaseMap = {}
    end
    local name = global:asKeyName()
    if not root._globalBaseMap[name] then
        ---@diagnostic disable-next-line: missing-fields
        root._globalBaseMap[name] = {
            type   = 'globalbase',
            parent = root,
            global = global,
            start  = 0,
            finish = 0,
        }
    end
    source._globalBase = root._globalBaseMap[name]
    return source._globalBase
end

---@param source parser.object
local function compileAst(source)
    local env = guide.getENV(source)
    if not env then
        return
    end
    compileObject(env)
    guide.eachSpecialOf(source, 'rawset', function (src)
        compileObject(src.parent)
    end)
    guide.eachSpecialOf(source, 'rawget', function (src)
        compileObject(src.parent)
    end)
    guide.eachSourceTypes(source.docs, {
        'doc.class',
        'doc.alias',
        'doc.type.name',
        'doc.extends.name',
        'doc.enum',
    }, function (src)
        compileObject(src)
    end)
end

---@param uri uri
local function dropUri(uri)
    local globalSub = globalSubs[uri]
    globalSubs[uri] = nil
    for key in pairs(globalSub) do
        local global = allGlobals[key]
        if global then
            global:dropUri(uri)
            if not global:isAlive() then
                allGlobals[key] = nil
            end
        end
    end
end

return {
    compileAst = compileAst,
    dropUri    = dropUri,
}
