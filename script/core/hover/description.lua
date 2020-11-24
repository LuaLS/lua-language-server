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
            for i, uri in ipairs(result) do
                local searcher = searchers and furi.decode(searchers[uri])
                uri = files.getOriginUri(uri)
                local path = furi.decode(uri)
                if files.eq(path:sub(1, #rootPath), rootPath) then
                    path = path:sub(#rootPath + 1)
                end
                path = path:gsub('^[/\\]*', '')
                if vm.isMetaFile(uri) then
                    result[i] = ('* [[meta]](%s)'):format(uri)
                elseif searcher then
                    searcher = searcher:sub(#rootPath + 1)
                    searcher = ws.normalize(searcher)
                    result[i] = ('* [%s](%s) %s'):format(path, uri, lang.script('HOVER_USE_LUA_PATH', searcher))
                else
                    result[i] = ('* [%s](%s)'):format(path, uri)
                end
            end
            table.sort(result)
            local md = markdown()
            md:add('md', table.concat(result, '\n'))
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

local function getBindComment(docGroup, base)
    local continue
    local lines
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.comment' then
            if not continue then
                continue = true
                lines = {}
            end
            lines[#lines+1] = doc.comment.text:sub(2)
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
    if #enums == 0 then
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

local function getBindEnums(docGroup)
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
                local name = rtn.name and rtn.name[1] or ('(return %d)'):format(returnIndex)
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
    local comment = getBindComment(source.bindGroup, source)
    return comment
end

local function tryDocComment(source)
    if not source.bindDocs then
        return
    end
    local comment = getBindComment(source.bindDocs)
    local enums   = getBindEnums(source.bindDocs)
    local md = markdown()
    if comment then
        md:add('md', comment)
    end
    if enums then
        md:add('lua', enums)
    end
    return md:string()
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

return function (source)
    if source.type == 'string' then
        return asString(source)
    end
    return tryDocOverloadToComment(source)
        or tryDocFieldUpComment(source)
        or tryDocComment(source)
end
