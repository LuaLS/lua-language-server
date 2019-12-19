local guide   = require 'parser.guide'
local files   = require 'files'
local vm      = require 'vm.vm'

local function ofLocal(loc, callback)
    -- 方法中的 self 使用了一个虚拟的定义位置
    if loc.tag ~= 'self' then
        callback {
            source   = loc,
            mode     = 'declare',
        }
    end
    if loc.ref then
        for _, ref in ipairs(loc.ref) do
            if ref.type == 'getlocal' then
                callback {
                    source   = ref,
                    mode     = 'get',
                }
            elseif ref.type == 'setlocal' then
                callback {
                    source   = ref,
                    mode     = 'set',
                }
            end
        end
    end
    if loc.tag == '_ENV' and loc.ref then
        for _, ref in ipairs(loc.ref) do
            if ref.type == 'getlocal' then
                local parent = ref.parent
                if parent.type == 'getfield'
                or parent.type == 'getindex' then
                    if guide.getKeyName(parent) == '_G' then
                        callback {
                            source   = parent,
                            mode     = 'get',
                        }
                    end
                end
            elseif ref.type == 'getglobal' then
                if guide.getName(ref) == '_G' then
                    callback {
                        source   = ref,
                        mode     = 'get',
                    }
                end
            end
        end
    end
end

local function ofGlobal(source, callback)
    local key = guide.getKeyName(source)
    local node = source.node
    if node.tag == '_ENV' then
        local uris = files.findGlobals(key)
        for _, uri in ipairs(uris) do
            local ast = files.getAst(uri)
            local globals = vm.getGlobals(ast.ast)
            if globals and globals[key] then
                for _, info in ipairs(globals[key]) do
                    callback(info)
                end
            end
        end
    else
        vm.eachField(node, function (info)
            if key == info.key then
                callback {
                    source   = info.source,
                    mode     = info.mode,
                }
            end
        end)
    end
end

local function ofField(source, callback)
    local parent = source.parent
    local key    = guide.getKeyName(source)
    if parent.type == 'tablefield'
    or parent.type == 'tableindex' then
        local tbl = parent.parent
        vm.eachField(tbl, function (info)
            if key == info.key then
                callback {
                    source   = info.source,
                    mode     = info.mode,
                }
            end
        end)
    else
        local node = parent.node
        vm.eachField(node, function (info)
            if key == info.key then
                callback {
                    source   = info.source,
                    mode     = info.mode,
                }
            end
        end)
    end
end

local function ofLiteral(source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type == 'setindex'
    or parent.type == 'getindex'
    or parent.type == 'tableindex' then
        ofField(source, callback)
    end
end

local function ofLabel(source, callback)
    callback {
        source = source,
        mode   = 'set',
    }
    if source.ref then
        for _, ref in ipairs(source.ref) do
            callback {
                source = ref,
                mode   = 'get',
            }
        end
    end
end

local function ofGoTo(source, callback)
    local name = source[1]
    local label = guide.getLabel(source, name)
    if label then
        ofLabel(label, callback)
    end
end

local function eachRef(source, callback)
    local stype = source.type
    if     stype == 'local' then
        ofLocal(source, callback)
    elseif stype == 'getlocal'
    or     stype == 'setlocal' then
        ofLocal(source.node, callback)
    elseif stype == 'setglobal'
    or     stype == 'getglobal' then
        ofGlobal(source, callback)
    elseif stype == 'field'
    or     stype == 'method' then
        ofField(source, callback)
    elseif stype == 'setfield'
    or     stype == 'getfield'
    or     stype == 'tablefield' then
        ofField(source.field, callback)
    elseif stype == 'setmethod'
    or     stype == 'getmethod' then
        ofField(source.method, callback)
    elseif stype == 'number'
    or     stype == 'boolean'
    or     stype == 'string' then
        ofLiteral(source, callback)
    elseif stype == 'goto' then
        ofGoTo(source, callback)
    elseif stype == 'label' then
        ofLabel(source, callback)
    end
end

--- 获取所有的引用
function vm.eachRef(source, callback, max)
    local mark = {}
    local result = {}
    eachRef(source, function (info)
        local src = info.source
        if mark[src] then
            return
        end
        mark[src] = true
        callback(info)
    end)
end
