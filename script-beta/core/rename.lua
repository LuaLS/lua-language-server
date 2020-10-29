local files      = require 'files'
local vm         = require 'vm'
local guide      = require 'parser.guide'
local proto      = require 'proto'
local define     = require 'proto.define'
local util       = require 'utility'
local findSource = require 'core.find-source'

local Forcing

local function askForcing(str)
    -- TODO 总是可以替换
    do return true end
    if TEST then
        return true
    end
    if Forcing ~= nil then
        return Forcing
    end
    local version = files.globalVersion
    -- TODO
    local item = proto.awaitRequest('window/showMessageRequest', {
        type    = define.MessageType.Warning,
        message = ('[%s]不是有效的标识符，是否强制替换？'):format(str),
        actions = {
            {
                title = '强制替换',
            },
            {
                title = '取消',
            },
        }
    })
    if version ~= files.globalVersion then
        Forcing = false
        proto.notify('window/showMessage', {
            type    = define.MessageType.Warning,
            message = '文件发生了变化，替换取消。'
        })
        return false
    end
    if not item then
        Forcing = false
        return false
    end
    if item.title == '强制替换' then
        Forcing = true
        return true
    else
        Forcing = false
        return false
    end
end

local function askForMultiChange(results, newname)
    -- TODO 总是可以替换
    do return true end
    if TEST then
        return true
    end
    local uris = {}
    for _, result in ipairs(results) do
        local uri = result.uri
        if not uris[uri] then
            uris[uri] = 0
            uris[#uris+1] = uri
        end
        uris[uri] = uris[uri] + 1
    end
    if #uris <= 1 then
        return true
    end

    local version = files.globalVersion
    -- TODO
    local item = proto.awaitRequest('window/showMessageRequest', {
        type    = define.MessageType.Warning,
        message = ('将修改 %d 个文件，共 %d 处。'):format(
            #uris,
            #results
        ),
        actions = {
            {
                title = '继续',
            },
            {
                title = '放弃',
            },
        }
    })
    if version ~= files.globalVersion then
        proto.notify('window/showMessage', {
            type    = define.MessageType.Warning,
            message = '文件发生了变化，替换取消。'
        })
        return false
    end
    if item and item.title == '继续' then
        local fileList = {}
        for _, uri in ipairs(uris) do
            fileList[#fileList+1] = ('%s (%d)'):format(uri, uris[uri])
        end

        log.debug(('Renamed [%s]\r\n%s'):format(newname, table.concat(fileList, '\r\n')))
        return true
    end
    return false
end

local function trim(str)
    return str:match '^%s*(%S+)%s*$'
end

local function isValidName(str)
    return str:match '^[%a_][%w_]*$'
end

local function isValidGlobal(str)
    for s in str:gmatch '[^%.]*' do
        if not isValidName(trim(s)) then
            return false
        end
    end
    return true
end

local function isValidFunctionName(str)
    if isValidGlobal(str) then
        return true
    end
    local pos = str:find(':', 1, true)
    if not pos then
        return false
    end
    return  isValidGlobal(trim(str:sub(1, pos-1)))
        and isValidName(trim(str:sub(pos+1)))
end

local function isFunctionGlobalName(source)
    local parent = source.parent
    if parent.type ~= 'setglobal' then
        return false
    end
    local value = parent.value
    if not value.type ~= 'function' then
        return false
    end
    return value.start <= parent.start
end

local function renameLocal(source, newname, callback)
    if isValidName(newname) then
        callback(source, source.start, source.finish, newname)
        return
    end
    if askForcing(newname) then
        callback(source, source.start, source.finish, newname)
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
        local newstr = '[' .. util.viewString(newname) .. ']'
        callback(source, dot.start, source.finish, newstr)
    elseif parent.type == 'tablefield' then
        local newstr = '[' .. util.viewString(newname) .. ']'
        callback(source, source.start, source.finish, newstr)
    elseif parent.type == 'getmethod' then
        if not askForcing(newname) then
            return false
        end
        callback(source, source.start, source.finish, newname)
    elseif parent.type == 'setmethod' then
        local uri = guide.getUri(source)
        local text = files.getText(uri)
        local func = parent.value
        -- function mt:name () end --> mt['newname'] = function (self) end
        local newstr = string.format('%s[%s] = function '
            , text:sub(parent.start, parent.node.finish)
            , util.viewString(newname)
        )
        callback(source, func.start, parent.finish, newstr)
        local pl = text:find('(', parent.finish, true)
        if pl then
            if func.args then
                callback(source, pl + 1, pl, 'self, ')
            else
                callback(source, pl + 1, pl, 'self')
            end
        end
    end
    return true
end

local function renameGlobal(source, newname, callback)
    if isValidGlobal(newname) then
        callback(source, source.start, source.finish, newname)
        return true
    end
    if isValidFunctionName(newname) then
        if not isFunctionGlobalName(source) then
            askForcing(newname)
        end
        callback(source, source.start, source.finish, newname)
        return true
    end
    local newstr = '_ENV[' .. util.viewString(newname) .. ']'
    -- function name () end --> _ENV['newname'] = function () end
    if source.value and source.value.type == 'function'
    and source.value.start < source.start then
        callback(source, source.value.start, source.finish, newstr .. ' = function ')
        return true
    end
    callback(source, source.start, source.finish, newstr)
    return true
end

local function ofLocal(source, newname, callback)
    renameLocal(source, newname, callback)
    if source.ref then
        for _, ref in ipairs(source.ref) do
            renameLocal(ref, newname, callback)
        end
    end
end

local function ofField(source, newname, callback)
    local key = guide.getKeyName(source)
    for _, src in ipairs(vm.getRefs(source, 'deep')) do
        if vm.getKeyName(src) ~= key then
            goto CONTINUE
        end
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
            local text = util.viewString(newname, quo)
            callback(src, src.start, src.finish, text)
            goto CONTINUE
        elseif src.type == 'field'
        or     src.type == 'method' then
            local suc = renameField(src, newname, callback)
            if not suc then
                goto CONTINUE
            end
        elseif src.type == 'setglobal'
        or     src.type == 'getglobal' then
            local suc = renameGlobal(src, newname, callback)
            if not suc then
                goto CONTINUE
            end
        end
        ::CONTINUE::
    end
end

local function ofLabel(source, newname, callback)
    if not isValidName(newname) and not askForcing(newname)then
        return false
    end
    for _, src in ipairs(vm.getRefs(source, 'deep')) do
        callback(src, src.start, src.finish, newname)
    end
end

local function rename(source, newname, callback)
    if source.type == 'label'
    or source.type == 'goto' then
        return ofLabel(source, newname, callback)
    elseif source.type == 'local' then
        return ofLocal(source, newname, callback)
    elseif source.type == 'setlocal'
    or     source.type == 'getlocal' then
        return ofLocal(source.node, newname, callback)
    elseif source.type == 'field'
    or     source.type == 'method'
    or     source.type == 'index' then
        return ofField(source, newname, callback)
    elseif source.type == 'tablefield'
    or     source.type == 'setglobal'
    or     source.type == 'getglobal' then
        return ofField(source, newname, callback)
    elseif source.type == 'string'
    or     source.type == 'number'
    or     source.type == 'boolean' then
        local parent = source.parent
        if not parent then
            return
        end
        if parent.type == 'setindex'
        or parent.type == 'getindex'
        or parent.type == 'tableindex' then
            return ofField(parent, newname, callback)
        end
    end
    return
end

local function prepareRename(source)
    if source.type == 'label'
    or source.type == 'goto'
    or source.type == 'local'
    or source.type == 'setlocal'
    or source.type == 'getlocal'
    or source.type == 'field'
    or source.type == 'method'
    or source.type == 'tablefield'
    or source.type == 'setglobal'
    or source.type == 'getglobal' then
        return source, source[1]
    elseif source.type == 'string'
    or     source.type == 'number'
    or     source.type == 'boolean' then
        local parent = source.parent
        if not parent then
            return nil
        end
        if parent.type == 'setindex'
        or parent.type == 'getindex'
        or parent.type == 'tableindex' then
            return source, source[1]
        end
        return nil
    end
    return nil
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
}

local m = {}

function m.rename(uri, pos, newname)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local source = findSource(ast, pos, accept)
    if not source then
        return nil
    end
    local results = {}
    local mark = {}

    vm.setSearchLevel(3)
    rename(source, newname, function (target, start, finish, text)
        if mark[start] then
            return
        end
        mark[start] = true
        results[#results+1] = {
            start  = start,
            finish = finish,
            text   = text,
            uri    = files.getOriginUri(guide.getUri(target)),
        }
    end)

    if Forcing == false then
        Forcing = nil
        return nil
    end

    if #results == 0 then
        return nil
    end

    if not askForMultiChange(results, newname) then
        return nil
    end

    return results
end

function m.prepareRename(uri, pos)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local source = findSource(ast, pos, accept)
    if not source then
        return
    end

    local res, text = prepareRename(source)
    if not res then
        return nil
    end

    return {
        start  = source.start,
        finish = source.finish,
        text   = text,
    }
end

return m
