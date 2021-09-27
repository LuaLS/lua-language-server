local searcher   = require 'core.searcher'
local files      = require 'files'
local vm         = require 'vm'
local define     = require 'proto.define'
local findSource = require 'core.find-source'
local util       = require 'utility'
local guide      = require 'parser.guide'

local function eachRef(source, callback)
    local results = vm.getRefs(source)
    for i = 1, #results do
        callback(results[i])
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
        eachRef(source.parent, callback)
    elseif source.type == 'getindex'
    or     source.type == 'setindex'
    or     source.type == 'tableindex' then
        eachRef(source, callback)
    elseif source.type == 'setglobal'
    or     source.type == 'getglobal' then
        eachRef(source, callback)
    elseif source.type == 'goto'
    or     source.type == 'label' then
        eachRef(source, callback)
    elseif source.type == 'string'
    and    source.parent
    and    source.parent.index == source then
        eachRef(source.parent, callback)
    elseif source.type == 'string'
    or     source.type == 'boolean'
    or     source.type == 'number'
    or     source.type == 'integer'
    or     source.type == 'nil' then
        callback(source)
    end
end

local function checkInIf(state, source, text, position)
    -- 检查 end
    local endB = guide.positionToOffset(state, source.finish)
    local endA = endB - #'end' + 1
    if  position >= source.finish - #'end'
    and position <= source.finish
    and text:sub(endA, endB) == 'end' then
        return true
    end
    -- 检查每个子模块
    for _, block in ipairs(source) do
        for i = 1, #block.keyword, 2 do
            local start  = block.keyword[i]
            local finish = block.keyword[i+1]
            if position >= start and position <= finish then
                return true
            end
        end
    end
    return false
end

local function makeIf(state, source, text, callback)
    -- end
    local endB = guide.positionToOffset(state, source.finish)
    local endA = endB - #'end' + 1
    if text:sub(endA, endB) == 'end' then
        callback(source.finish - #'end', source.finish)
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

local function findKeyWord(state, text, position, callback)
    guide.eachSourceContain(state.ast, position, function (source)
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
                if position >= start and position <= finish then
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
            local ok = checkInIf(state, source, text, position)
            if ok then
                makeIf(state, source, text, callback)
            end
        end
    end)
end

local function isRegion(str)
    if str:sub(1, #'region') == 'region'
    or str:sub(1, #'#region') == '#region' then
        return true
    end
    return false
end

local function isEndRegion(str)
    if str:sub(1, #'endregion') == 'endregion'
    or str:sub(1, #'#endregion') == '#endregion' then
        return true
    end
    return false
end

local function checkRegion(ast, text, offset, callback)
    local count
    local start, finish
    local selected
    for i, comment in ipairs(ast.comms) do
        if comment.type == 'comment.short' then
            if  comment.start <= offset
            and comment.finish >= offset then
                local ltext = comment.text:lower()
                ltext = util.trim(ltext, 'left')
                if isRegion(ltext) then
                    start = comment.start - 2
                    count = 1
                    selected = i
                elseif isEndRegion(ltext) then
                    finish = comment.finish
                    count = 1
                    selected = i
                else
                    return
                end
                break
            end
        end
    end
    if not selected then
        return
    end
    if start then
        for i = selected + 1, #ast.comms do
            local comment = ast.comms[i]
            if comment.type == 'comment.short' then
                local ltext = comment.text:lower()
                ltext = util.trim(ltext, 'left')
                if isRegion(ltext) then
                    count = count + 1
                elseif isEndRegion(ltext) then
                    count = count - 1
                    if count == 0 then
                        callback(start, comment.finish)
                        return
                    end
                end
            end
        end
    end
    if finish then
        for i = selected - 1, 1, -1 do
            local comment = ast.comms[i]
            if comment.type == 'comment.short' then
                local ltext = comment.text:lower()
                ltext = util.trim(ltext, 'left')
                if isEndRegion(ltext) then
                    count = count + 1
                elseif isRegion(ltext) then
                    count = count - 1
                    if count == 0 then
                        callback(comment.start - 2, finish)
                        return
                    end
                end
            end
        end
    end
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
    ['integer']     = true,
    ['nil']        = true,
}

local function isLiteralValue(source)
    if not guide.isLiteral(source) then
        return false
    end
    if source.parent and source.parent.index == source then
        return false
    end
    return true
end

return function (uri, offset)
    local state = files.getState(uri)
    if not state then
        return nil
    end
    local text = files.getText(uri)
    local results = {}
    local mark = {}

    local source = findSource(state, offset, accept)
    if source then
        local isGlobal  = guide.isGlobal(source)
        local isLiteral = isLiteralValue(source)
        find(source, uri, function (target)
            if not target then
                return
            end
            if target.dummy then
                return
            end
            if mark[target] then
                return
            end
            mark[target] = true
            if isGlobal ~= guide.isGlobal(target) then
                return
            end
            if isLiteral ~= isLiteralValue(target) then
                return
            end
            if uri ~= guide.getUri(target) then
                return
            end
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
            or     target.type == 'integer'
            or     target.type == 'nil' then
                kind   = define.DocumentHighlightKind.Text
            else
                return
            end
            if not target then
                return
            end
            results[#results+1] = {
                start  = target.start,
                finish = target.finish,
                kind   = kind,
            }
        end)
    end

    findKeyWord(state, text, offset, function (start, finish)
        results[#results+1] = {
            start  = start,
            finish = finish,
            kind   = define.DocumentHighlightKind.Write
        }
    end)

    checkRegion(state, text, offset, function (start, finish)
        results[#results+1] = {
            start  = start,
            finish = finish,
            kind   = define.DocumentHighlightKind.Text
        }
    end)

    if #results == 0 then
        return nil
    end
    return results
end
