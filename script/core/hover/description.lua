local vm       = require 'vm'
local ws       = require 'workspace'
local furi     = require 'file-uri'
local files    = require 'files'
local guide    = require 'parser.guide'
local markdown = require 'provider.markdown'
local config   = require 'config'
local lang     = require 'language'

local function asStringInRequire(source, literal)
    local rootPath = ws.path or ''
    local parent = source.parent
    if parent and parent.type == 'callargs' then
        local result, searchers
        local call = parent.parent
        local func = call.node
        local libName = vm.getLibraryName(func)
        if not libName then
            return
        end
        if     libName == 'require' then
            result, searchers = ws.findUrisByRequirePath(literal)
        elseif libName == 'dofile'
        or     libName == 'loadfile' then
            result = ws.findUrisByFilePath(literal)
        end
        if result and #result > 0 then
            local shows = {}
            for i, uri in ipairs(result) do
                local searcher = searchers and searchers[uri]
                uri = files.getOriginUri(uri)
                local path = furi.decode(uri)
                if files.eq(path:sub(1, #rootPath), rootPath) then
                    path = path:sub(#rootPath + 1)
                end
                path = path:gsub('^[/\\]*', '')
                if vm.isMetaFile(uri) then
                    shows[i] = ('* [[meta]](%s)'):format(uri)
                elseif searcher then
                    searcher = searcher:sub(#rootPath + 1)
                    searcher = ws.normalize(searcher)
                    searcher = searcher:gsub('^[/\\]+', '')
                    shows[i] = ('* [%s](%s) %s'):format(path, uri, lang.script('HOVER_USE_LUA_PATH', searcher))
                else
                    shows[i] = ('* [%s](%s)'):format(path, uri)
                end
            end
            table.sort(shows)
            local md = markdown()
            md:add('md', table.concat(shows, '\n'))
            return md:string()
        end
    end
end

local function asStringView(source, literal)
    -- 内部包含转义符？
    local rawLen = source.finish - source.start - 2 * #source[2] + 1
    if  config.config.hover.viewString
    and (source[2] == '"' or source[2] == "'")
    and rawLen > #literal then
        local view = literal
        local max = config.config.hover.viewStringMax
        if #view > max then
            view = view:sub(1, max) .. '...'
        end
        local md = markdown()
        md:add('txt', view)
        return md:string()
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
        end
    end
    if not lines or #lines == 0 then
        return nil
    end
    return table.concat(lines, '\n')
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
    lines[#lines+1] = ('%s: %s'):format(name, table.concat(types))
    for _, enum in ipairs(enums) do
        lines[#lines+1] = ('   %s %s%s'):format(
               (enum.default    and '->')
            or (enum.additional and '+>')
            or ' |',
            enum[1],
            enum.comment and (' -- %s'):format(enum.comment) or ''
        )
    end
    return table.concat(lines, '\n')
end

local function isFunction(source)
    if source.type == 'function' then
        return true
    end
    local value = guide.getObjectValue(source)
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
    if source.type ~= 'doc.field' then
        return
    end
    if not source.bindGroup then
        return
    end
    local comment = getBindComment(source, source.bindGroup, source)
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

    local comments = {}
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.comment' then
            if doc.comment.text:sub(1, 1) == '-' then
                comments[#comments+1] = doc.comment.text:sub(2)
            else
                comments[#comments+1] = doc.comment.text
            end
        elseif doc.type == 'doc.param' then
            if doc.comment then
                comments[#comments+1] = ('@*param* `%s` — %s'):format(
                    doc.param[1],
                    doc.comment.text
                )
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
                        comments[#comments+1] = ('@*return* — %s'):format(doc.comment.text)
                    else
                        comments[#comments+1] = ('@*return* `%s` — %s'):format(table.concat(name, ','), doc.comment.text)
                    end
                else
                    if #name == 0 then
                        comments[#comments+1] = '@*return*'
                    else
                        comments[#comments+1] = ('@*return* `%s`'):format(table.concat(name, ','))
                    end
                end
            end
        end
    end
    comments = table.concat(comments, "\n\n")

    local enums = getBindEnums(source, docGroup)
    if comments == "" and not enums then
        return
    end
    local md = markdown()
    if comments ~= "" then
        md:add('md', comments)
    end
    if enums then
        md:add('lua', enums)
    end
    return md:string()
end

local function tryDocComment(source)
    if not source.bindDocs then
        return
    end
    if not isFunction(source) then
        local comment = getBindComment(source, source.bindDocs)
        if not comment then
            return
        end
        local md = markdown()
        md:add('md', "---")
        md:add('md', comment)
        return md:string()
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
    if not source.bindDocs then
        return
    end
    for _, doc in ipairs(source.bindDocs) do
        if doc.type == 'doc.param' then
            if doc.param[1] == source[1] then
                if doc.comment then
                    return doc.comment.text
                end
                break
            end
        end
    end
end

return function (source)
    if source.type == 'string' then
        return asString(source)
    end
    return tryDocOverloadToComment(source)
        or tryDocFieldUpComment(source)
        or tyrDocParamComment(source)
        or tryDocComment(source)
end
