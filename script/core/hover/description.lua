local vm       = require 'vm'
local ws       = require 'workspace'
local furi     = require 'file-uri'
local files    = require 'files'
local searcher = require 'core.searcher'
local markdown = require 'provider.markdown'
local config   = require 'config'
local lang     = require 'language'
local util     = require 'utility'
local guide    = require 'parser.guide'
local noder    = require 'core.noder'

local function collectRequire(mode, literal)
    local rootPath = ws.path or ''
    local result, searchers
    if     mode == 'require' then
        result, searchers = ws.findUrisByRequirePath(literal)
    elseif mode == 'dofile'
    or     mode == 'loadfile' then
        result = ws.findUrisByFilePath(literal)
    end
    if result and #result > 0 then
        local shows = {}
        for i, uri in ipairs(result) do
            local searcher = searchers and searchers[uri]
            local path = furi.decode(uri)
            if path:sub(1, #rootPath) == rootPath then
                path = path:sub(#rootPath + 1)
            end
            path = path:gsub('^[/\\]*', '')
            if vm.isMetaFile(uri) then
                shows[i] = ('* [[meta]](%s)'):format(uri)
            elseif searcher then
                searcher = searcher:gsub('^[/\\]+', '')
                shows[i] = ('* [%s](%s) %s'):format(path, uri, lang.script('HOVER_USE_LUA_PATH', searcher))
            else
                shows[i] = ('* [%s](%s)'):format(path, uri)
            end
        end
        table.sort(shows)
        local md = markdown()
        md:add('md', table.concat(shows, '\n'))
        return md
    end
end

local function asStringInRequire(source, literal)
    local parent = source.parent
    if parent and parent.type == 'callargs' then
        local call = parent.parent
        local func = call.node
        local libName = vm.getLibraryName(func)
        if not libName then
            return
        end
        if libName == 'require'
        or libName == 'dofile'
        or libName == 'loadfile' then
            return collectRequire(libName, literal)
        end
    end
end

local function asStringView(source, literal)
    -- 内部包含转义符？
    local rawLen = source.finish - source.start - 2 * #source[2] + 1
    if  config.get 'Lua.hover.viewString'
    and (source[2] == '"' or source[2] == "'")
    and rawLen > #literal then
        local view = literal
        local max = config.get 'Lua.hover.viewStringMax'
        if #view > max then
            view = view:sub(1, max) .. '...'
        end
        local md = markdown()
        md:add('txt', view)
        return md
    end
end

local function asString(source)
    local literal = guide.getLiteral(source)
    if type(literal) ~= 'string' then
        return nil
    end
    return asStringInRequire(source, literal)
        or asStringView(source, literal)
end

local function getBindComment(source, docGroup, base)
    if source.type == 'setlocal'
    or source.type == 'getlocal' then
        source = source.node
    end
    if source.parent.type == 'funcargs' then
        return
    end
    local continue
    local lines
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.comment' then
            if not continue then
                continue = true
                lines = {}
            end
            if doc.comment.text:sub(1, 1) == '-' then
                lines[#lines+1] = doc.comment.text:sub(2)
            else
                lines[#lines+1] = doc.comment.text
            end
        elseif doc == base then
            break
        else
            continue = false
            if doc.type == 'doc.field'
            or doc.type == 'doc.class' then
                lines = nil
            end
        end
    end
    if source.comment then
        if not lines then
            lines = {}
        end
        lines[#lines+1] = source.comment.text
    end
    if not lines or #lines == 0 then
        return nil
    end
    return table.concat(lines, '\n')
end

local function tryDocClassComment(source)
    for _, def in ipairs(vm.getDefs(source)) do
        if def.type == 'doc.class.name'
        or def.type == 'doc.alias.name' then
            local class = noder.getDocState(def)
            local comment = getBindComment(class, class.bindGroup, class)
            if comment then
                return comment
            end
        end
    end
    if source.bindDocs then
        for _, doc in ipairs(source.bindDocs) do
            if doc.type == 'doc.class'
            or doc.type == 'doc.alias' then
                local comment = getBindComment(doc, source.bindDocs, doc)
                return comment
            end
        end
    end
end

local function tryDocModule(source)
    if not source.module then
        return
    end
    return collectRequire('require', source.module)
end

local function buildEnumChunk(docType, name)
    local enums = vm.getDocEnums(docType)
    if not enums or #enums == 0 then
        return
    end
    local types = {}
    for _, tp in ipairs(docType.types) do
        types[#types+1] = tp[1]
    end
    local lines = {}
    for _, typeUnit in ipairs(docType.types) do
        local comment = tryDocClassComment(typeUnit)
        if comment then
            for line in util.eachLine(comment) do
                lines[#lines+1] = ('-- %s'):format(line)
            end
        end
    end
    lines[#lines+1] = ('%s: %s'):format(name, table.concat(types))
    for _, enum in ipairs(enums) do
        local enumDes = ('   %s %s'):format(
                (enum.default    and '->')
            or (enum.additional and '+>')
            or ' |',
            enum[1]
        )
        if enum.comment then
            local first = true
            local len = #enumDes
            for comm in enum.comment:gmatch '[^\r\n]+' do
                if first then
                    first = false
                    enumDes = ('%s -- %s'):format(enumDes, comm)
                else
                    enumDes = ('%s\n%s -- %s'):format(enumDes, (' '):rep(len), comm)
                end
            end
        end
        lines[#lines+1] = enumDes
    end
    return table.concat(lines, '\n')
end

local function isFunction(source)
    if source.type == 'function' then
        return true
    end
    local value = searcher.getObjectValue(source)
    if not value then
        return false
    end
    return value.type == 'function'
end

local function getBindEnums(source, docGroup)
    if not isFunction(source) then
        return
    end

    local mark = {}
    local chunks = {}
    local returnIndex = 0
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.param' then
            local name = doc.param[1]
            if mark[name] then
                goto CONTINUE
            end
            mark[name] = true
            chunks[#chunks+1] = buildEnumChunk(doc.extends, name)
        elseif doc.type == 'doc.return' then
            for _, rtn in ipairs(doc.returns) do
                returnIndex = returnIndex + 1
                local name = rtn.name and rtn.name[1] or ('return #%d'):format(returnIndex)
                if mark[name] then
                    goto CONTINUE
                end
                mark[name] = true
                chunks[#chunks+1] = buildEnumChunk(rtn, name)
            end
        end
        ::CONTINUE::
    end
    if #chunks == 0 then
        return nil
    end
    return table.concat(chunks, '\n\n')
end

local function tryDocFieldUpComment(source)
    if source.type ~= 'doc.field.name' then
        return
    end
    local docField = source.parent
    if not docField.bindGroup then
        return
    end
    local comment = getBindComment(docField, docField.bindGroup, docField)
    return comment
end

local function getFunctionComment(source)
    local docGroup = source.bindDocs

    local hasReturnComment = false
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.return' and doc.comment then
            hasReturnComment = true
            break
        end
    end

    local md = markdown()
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.comment' then
            if doc.comment.text:sub(1, 1) == '-' then
                md:add('md', doc.comment.text:sub(2))
            else
                md:add('md', doc.comment.text)
            end
        elseif doc.type == 'doc.param' then
            if doc.comment then
                md:add('md', ('@*param* `%s` — %s'):format(
                    doc.param[1],
                    doc.comment.text
                ))
            end
        elseif doc.type == 'doc.return' then
            if hasReturnComment then
                local name = {}
                for _, rtn in ipairs(doc.returns) do
                    if rtn.name then
                        name[#name+1] = rtn.name[1]
                    end
                end
                if doc.comment then
                    if #name == 0 then
                        md:add('md', ('@*return* — %s'):format(doc.comment.text))
                    else
                        md:add('md', ('@*return* `%s` — %s'):format(table.concat(name, ','), doc.comment.text))
                    end
                else
                    if #name == 0 then
                        md:add('md', '@*return*')
                    else
                        md:add('md', ('@*return* `%s`'):format(table.concat(name, ',')))
                    end
                end
            end
        elseif doc.type == 'doc.overload' then
            md:splitLine()
        end
    end

    local enums = getBindEnums(source, docGroup)
    md:add('lua', enums)
    return md
end

local function tryDocComment(source)
    if not source.bindDocs then
        return
    end
    if not isFunction(source) then
        local comment = getBindComment(source, source.bindDocs)
        return comment
    end
    return getFunctionComment(source)
end

local function tryDocOverloadToComment(source)
    if source.type ~= 'doc.type.function' then
        return
    end
    local doc = source.parent
    if doc.type ~= 'doc.overload'
    or not doc.bindSources then
        return
    end
    for _, src in ipairs(doc.bindSources) do
        local md = tryDocComment(src)
        if md then
            return md
        end
    end
end

local function tyrDocParamComment(source)
    if source.type == 'setlocal'
    or source.type == 'getlocal' then
        source = source.node
    end
    if source.type ~= 'local' then
        return
    end
    if source.parent.type ~= 'funcargs' then
        return
    end
    for _, def in ipairs(vm.getDefs(source)) do
        if def.type == 'doc.param' then
            if def.comment then
                return def.comment.text
            end
        end
    end
end

return function (source)
    if source.type == 'string' then
        return asString(source)
    end
    if source.type == 'field' then
        source = source.parent
    end
    return tryDocOverloadToComment(source)
        or tryDocFieldUpComment(source)
        or tyrDocParamComment(source)
        or tryDocComment(source)
        or tryDocClassComment(source)
        or tryDocModule(source)
end
