local guide      = require 'parser.guide'
local files      = require 'files'
local vm         = require 'vm'
local define     = require 'proto.define'
local findSource = require 'core.find-source'

local function eachRef(source, callback)
    local results = guide.requestReference(source)
    for i = 1, #results do
        callback(results[i])
    end
end

local function eachField(source, callback)
    if not source then
        return
    end
    local isGlobal = guide.isGlobal(source)
    local results = guide.requestReference(source)
    for i = 1, #results do
        local res = results[i]
        if isGlobal == guide.isGlobal(res) then
            callback(res)
        end
    end
end

local function eachLocal(source, callback)
    callback(source)
    if source.ref then
        for _, ref in ipairs(source.ref) do
            callback(ref)
        end
    end
end

local function find(source, uri, callback)
    if     source.type == 'local' then
        eachLocal(source, callback)
    elseif source.type == 'getlocal'
    or     source.type == 'setlocal' then
        eachLocal(source.node, callback)
    elseif source.type == 'field'
    or     source.type == 'method' then
        eachField(source.parent, callback)
    elseif source.type == 'getindex'
    or     source.type == 'setindex'
    or     source.type == 'tableindex' then
        eachField(source, callback)
    elseif source.type == 'setglobal'
    or     source.type == 'getglobal' then
        eachField(source, callback)
    elseif source.type == 'goto'
    or     source.type == 'label' then
        eachRef(source, callback)
    elseif source.type == 'string'
    and    source.parent
    and    source.parent.index == source then
        eachField(source.parent, callback)
    elseif source.type == 'string'
    or     source.type == 'boolean'
    or     source.type == 'number'
    or     source.type == 'nil' then
        callback(source)
    end
end

local function checkInIf(source, text, offset)
    -- 检查 end
    local endA = source.finish - #'end' + 1
    local endB = source.finish
    if  offset >= endA
    and offset <= endB
    and text:sub(endA, endB) == 'end' then
        return true
    end
    -- 检查每个子模块
    for _, block in ipairs(source) do
        for i = 1, #block.keyword, 2 do
            local start  = block.keyword[i]
            local finish = block.keyword[i+1]
            if offset >= start and offset <= finish then
                return true
            end
        end
    end
    return false
end

local function makeIf(source, text, callback)
    -- end
    local endA = source.finish - #'end' + 1
    local endB = source.finish
    if text:sub(endA, endB) == 'end' then
        callback(endA, endB)
    end
    -- 每个子模块
    for _, block in ipairs(source) do
        for i = 1, #block.keyword, 2 do
            local start  = block.keyword[i]
            local finish = block.keyword[i+1]
            callback(start, finish)
        end
    end
    return false
end

local function findKeyWord(ast, text, offset, callback)
    guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type == 'do'
        or source.type == 'function'
        or source.type == 'loop'
        or source.type == 'in'
        or source.type == 'while'
        or source.type == 'repeat' then
            local ok
            for i = 1, #source.keyword, 2 do
                local start  = source.keyword[i]
                local finish = source.keyword[i+1]
                if offset >= start and offset <= finish then
                    ok = true
                    break
                end
            end
            if ok then
                for i = 1, #source.keyword, 2 do
                    local start  = source.keyword[i]
                    local finish = source.keyword[i+1]
                    callback(start, finish)
                end
            end
        elseif source.type == 'if' then
            local ok = checkInIf(source, text, offset)
            if ok then
                makeIf(source, text, callback)
            end
        end
    end)
end

local accept = {
    ['label']      = true,
    ['goto']       = true,
    ['local']      = true,
    ['setlocal']   = true,
    ['getlocal']   = true,
    ['field']      = true,
    ['method']     = true,
    ['tablefield'] = true,
    ['setglobal']  = true,
    ['getglobal']  = true,
    ['string']     = true,
    ['boolean']    = true,
    ['number']     = true,
    ['nil']        = true,
}

return function (uri, offset)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local text = files.getText(uri)
    local results = {}
    local mark = {}

    local source = findSource(ast, offset, accept)
    if source then
        find(source, uri, function (target)
            local kind
            if     target.type == 'getfield' then
                target = target.field
                kind   = define.DocumentHighlightKind.Read
            elseif target.type == 'setfield'
            or     target.type == 'tablefield' then
                target = target.field
                kind   = define.DocumentHighlightKind.Write
            elseif target.type == 'getmethod' then
                target = target.method
                kind   = define.DocumentHighlightKind.Read
            elseif target.type == 'setmethod' then
                target = target.method
                kind   = define.DocumentHighlightKind.Write
            elseif target.type == 'getindex' then
                target = target.index
                kind   = define.DocumentHighlightKind.Read
            elseif target.type == 'field' then
                if target.parent.type == 'getfield' then
                    kind   = define.DocumentHighlightKind.Read
                else
                    kind   = define.DocumentHighlightKind.Write
                end
            elseif target.type == 'method' then
                if target.parent.type == 'getmethod' then
                    kind   = define.DocumentHighlightKind.Read
                else
                    kind   = define.DocumentHighlightKind.Write
                end
            elseif target.type == 'index' then
                if target.parent.type == 'getindex' then
                    kind   = define.DocumentHighlightKind.Read
                else
                    kind   = define.DocumentHighlightKind.Write
                end
            elseif target.type == 'index' then
                if target.parent.type == 'getindex' then
                    kind   = define.DocumentHighlightKind.Read
                else
                    kind   = define.DocumentHighlightKind.Write
                end
            elseif target.type == 'setindex'
            or     target.type == 'tableindex' then
                target = target.index
                kind   = define.DocumentHighlightKind.Write
            elseif target.type == 'getlocal'
            or     target.type == 'getglobal'
            or     target.type == 'goto' then
                kind   = define.DocumentHighlightKind.Read
            elseif target.type == 'setlocal'
            or     target.type == 'local'
            or     target.type == 'setglobal'
            or     target.type == 'label' then
                kind   = define.DocumentHighlightKind.Write
            elseif target.type == 'string'
            or     target.type == 'boolean'
            or     target.type == 'number'
            or     target.type == 'nil' then
                kind   = define.DocumentHighlightKind.Text
            else
                return
            end
            if mark[target] then
                return
            end
            mark[target] = true
            results[#results+1] = {
                start  = target.start,
                finish = target.finish,
                kind   = kind,
            }
        end)
    end

    findKeyWord(ast, text, offset, function (start, finish)
        results[#results+1] = {
            start  = start,
            finish = finish,
            kind   = define.DocumentHighlightKind.Write
        }
    end)

    if #results == 0 then
        return nil
    end
    return results
end
