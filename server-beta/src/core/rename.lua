local files    = require 'files'
local searcher = require 'searcher'
local guide    = require 'parser.guide'

local function isValidName(str)
    return str:match '^[%a_][%w_]*$'
end

local function forceReplace(name)
    return true
end

local function ofLocal(source, newname, callback)
    if not isValidName(newname) and not forceReplace(newname) then
        return false
    end
    callback(source, source.start, source.finish, newname)
    if source.ref then
        for _, ref in ipairs(source.ref) do
            callback(ref, ref.start, ref.finish, newname)
        end
    end
end

local esc = {
    ["'"]  = [[\']],
    ['"']  = [[\"]],
    ['\r'] = [[\r]],
    ['\n'] = [[\n]],
}

local function toString(quo, newstr)
    if quo == "'" then
        return quo .. newstr:gsub([=[['\r\n]]=], esc) .. quo
    elseif quo == '"' then
        return quo .. newstr:gsub([=[["\r\n]]=], esc) .. quo
    else
        if newstr:find([[\r]], 1, true) then
            return toString('"', newstr)
        end
        local eqnum = #quo - 2
        local fsymb = ']' .. ('='):rep(eqnum) .. ']'
        if not newstr:find(fsymb, 1, true) then
            return quo .. newstr .. fsymb
        end
        for i = 0, 100 do
            local fsymb = ']' .. ('='):rep(i) .. ']'
            if not newstr:find(fsymb, 1, true) then
                local ssymb = '[' .. ('='):rep(i) .. '['
                return ssymb .. newstr .. fsymb
            end
        end
        return toString('"', newstr)
    end
end

local function renameField(source, newname, callback)
    if isValidName(newname) then
        callback(source, source.start, source.finish, newname)
        return true
    end
    local parent = source.parent
    if parent.type == 'setfield'
    or parent.type == 'getfield' then
        local dot = parent.dot
        local newstr = '[' .. toString('"', newname) .. ']'
        callback(source, dot.start, source.finish, newstr)
    elseif parent.type == 'tablefield' then
        local newstr = '[' .. toString('"', newname) .. ']'
        callback(source, source.start, source.finish, newstr)
    else
        if not forceReplace(newname) then
            return false
        end
        callback(source, source.start, source.finish, newname)
    end
    return true
end

local function renameGlobal(source, newname, callback)
    if isValidName(newname) then
        callback(source, source.start, source.finish, newname)
        return false
    end
    local newstr = '_ENV[' .. toString('"', newname) .. ']'
    callback(source, source.start, source.finish, newstr)
    return true
end

local function ofField(source, newname, callback)
    return searcher.eachRef(source, function (info)
        local src = info.source
        if     src.type == 'tablefield'
        or     src.type == 'getfield'
        or     src.type == 'setfield' then
            src = src.field
        elseif src.type == 'tableindex'
        or     src.type == 'getindex'
        or     src.type == 'setindex' then
            src = src.index
        elseif src.type == 'getmethod'
        or     src.type == 'setmethod' then
            src = src.method
        end
        if src.type == 'string' then
            local quo = src[2]
            local text = toString(quo, newname)
            callback(src, src.start, src.finish, text)
            return
        elseif src.type == 'field'
        or     src.type == 'method' then
            local suc = renameField(src, newname, callback)
            if not suc then
                return false
            end
        elseif src.type == 'setglobal'
        or     src.type == 'getglobal' then
            local suc = renameGlobal(src, newname, callback)
            if not suc then
                return false
            end
        end
    end)
end

local function rename(source, newname, callback)
    if source.type == 'label'
    or source.type == 'goto' then
        if not isValidName(newname) and not forceReplace(newname)then
            return false
        end
        searcher.eachRef(source, function (info)
            callback(info.source, info.source.start, info.source.finish, newname)
        end)
    end
    if     source.type == 'local' then
        return ofLocal(source, newname, callback)
    elseif source.type == 'setlocal'
    or     source.type == 'getlocal' then
        return ofLocal(source.node, newname, callback)
    elseif source.type == 'field'
    or     source.type == 'method'
    or     source.type == 'tablefield'
    or     source.type == 'string'
    or     source.type == 'setglobal'
    or     source.type == 'getglobal' then
        return ofField(source, newname, callback)
    end
    return true
end

return function (uri, pos, newname)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local results = {}

    local ok = true
    guide.eachSourceContain(ast.ast, pos, function(source)
        local suc = rename(source, newname, function (target, start, finish, text)
            results[#results+1] = {
                start  = start,
                finish = finish,
                text   = text,
                uri    = guide.getRoot(target).uri,
            }
        end)
        if suc == false then
            ok = false
        end
    end)
    if not ok then
        return nil
    end
    if #results == 0 then
        return nil
    end
    return results
end
