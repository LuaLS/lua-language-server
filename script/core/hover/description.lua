local vm       = require 'vm'
local ws       = require 'workspace'
local markdown = require 'provider.markdown'
local config   = require 'config'
local lang     = require 'language'
local util     = require 'utility'
local guide    = require 'parser.guide'
local rpath    = require 'workspace.require-path'
local furi     = require 'file-uri'
local wssymbol = require 'core.workspace-symbol'

local function collectRequire(mode, literal, uri)
    local result, searchers
    if     mode == 'require' then
        result, searchers = rpath.findUrisByRequireName(uri, literal)
    elseif mode == 'dofile'
    or     mode == 'loadfile' then
        result = ws.findUrisByFilePath(literal)
    end
    if result and #result > 0 then
        local shows = {}
        for i, uri in ipairs(result) do
            local searcher = searchers and searchers[uri]
            local path = ws.getRelativePath(uri)
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
            return collectRequire(libName, literal, guide.getUri(source))
        end
    end
end

local function asStringView(source, literal)
    -- 内部包含转义符？
    if not source[2] then
        return
    end
    local rawLen = source.finish - source.start - 2 * #source[2]
    if  config.get(guide.getUri(source), 'Lua.hover.viewString')
    and (source[2] == '"' or source[2] == "'")
    and rawLen > #literal then
        local view = literal
        local max = config.get(guide.getUri(source), 'Lua.hover.viewStringMax')
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

---@param comment string
---@param suri uri
---@return string?
local function normalizeComment(comment, suri)
    if not comment then
        return nil
    end
    if comment:sub(1, 1) == '-' then
        comment = comment:sub(2)
    end
    if comment:sub(1, 1) == '@' then
        return nil
    end
    comment = comment:gsub('(%[.-%]%()(.-)(%))', function (left, path, right)
        local scheme = furi.split(path)
        if scheme
        -- strange way to check `C:/xxx.lua`
        and #scheme > 1 then
            return
        end
        local absPath = ws.getAbsolutePath(suri:gsub('/[^/]+$', ''), path)
        if not absPath then
            return
        end
        local uri     = furi.encode(absPath)
        return left .. uri .. right
    end)
    return comment
end

local function getBindComment(source)
    local uri = guide.getUri(source)
    local lines = {}
    for _, docComment in ipairs(source.bindComments) do
        lines[#lines+1] = normalizeComment(docComment.comment.text, uri)
    end
    if not lines or #lines == 0 then
        return nil
    end
    return table.concat(lines, '\n')
end

---@async
local function packSee(see)
    local name = see.name[1]
    local buf  = {}
    local target
    for _, symbol in ipairs(wssymbol(name, guide.getUri(see))) do
        if symbol.name == name then
            target = symbol.source
            break
        end
    end
    if target then
        local row, col = guide.rowColOf(target.start)
        buf[#buf+1] = ('[%s](%s#%d#%d)'):format(name, guide.getUri(target), row + 1, col)
    else
        buf[#buf+1] = ('~%s~'):format(name)
    end
    if see.comment then
        buf[#buf+1] = ' '
        buf[#buf+1] = see.comment.text
    end
    return table.concat(buf)
end

---@async
local function lookUpDocSees(lines, docGroup)
    local sees = {}
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.see' then
            sees[#sees+1] = doc
        end
    end
    if #sees == 0 then
        return
    end
    if #sees == 1 then
        lines[#lines+1] = ('See: %s'):format(packSee(sees[1]))
        return
    end
    lines[#lines+1] = 'See:'
    for _, see in ipairs(sees) do
        lines[#lines+1] = ('  * %s'):format(packSee(see))
    end
end

---@async
local function lookUpDocComments(source)
    local docGroup = source.bindDocs
    if not docGroup then
        return
    end
    if source.type == 'setlocal'
    or source.type == 'getlocal' then
        source = source.node
    end
    if source.parent.type == 'funcargs' then
        return
    end
    local uri = guide.getUri(source)
    local lines = {}
    for _, doc in ipairs(docGroup) do
        if doc.type == 'doc.comment' then
            lines[#lines+1] = normalizeComment(doc.comment.text, uri)
        elseif doc.type == 'doc.type'
        or     doc.type == 'doc.public'
        or     doc.type == 'doc.protected'
        or     doc.type == 'doc.private' then
            if doc.comment then
                lines[#lines+1] = normalizeComment(doc.comment.text, uri)
            end
        elseif doc.type == 'doc.class' then
            for _, docComment in ipairs(doc.bindComments) do
                lines[#lines+1] = normalizeComment(docComment.comment.text, uri)
            end
        end
    end
    if source.comment then
        lines[#lines+1] = normalizeComment(source.comment.text, uri)
    end
    lookUpDocSees(lines, docGroup)
    if not lines or #lines == 0 then
        return nil
    end
    return table.concat(lines, '\n')
end

local function tryDocClassComment(source)
    for _, def in ipairs(vm.getDefs(source)) do
        if def.type == 'doc.class'
        or def.type == 'doc.alias'
        or def.type == 'doc.enum' then
            local comment = getBindComment(def)
            if comment then
                return comment
            end
        end
    end
end

local function tryDocModule(source)
    if not source.module then
        return
    end
    return collectRequire('require', source.module, guide.getUri(source))
end

local function buildEnumChunk(docType, name, uri)
    if not docType then
        return nil
    end
    local enums = {}
    local types = {}
    local lines = {}
    for _, tp in ipairs(vm.getDefs(docType)) do
        types[#types+1] = vm.getInfer(tp):view(guide.getUri(docType))
        if tp.type == 'doc.type.string'
        or tp.type == 'doc.type.integer'
        or tp.type == 'doc.type.boolean'
        or tp.type == 'doc.type.code' then
            enums[#enums+1] = tp
        end
        local comment = tryDocClassComment(tp)
        if comment then
            for line in util.eachLine(comment) do
                lines[#lines+1] = ('-- %s'):format(line)
            end
        end
    end
    if #enums == 0 then
        return nil
    end
    lines[#lines+1] = ('%s:'):format(name)
    for _, enum in ipairs(enums) do
        local enumDes = ('   %s %s'):format(
                (enum.default    and '->')
            or  (enum.additional and '+>')
            or  ' |',
            vm.getInfer(enum):view(uri)
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

local function getBindEnums(source, docGroup)
    if source.type ~= 'function' then
        return
    end

    local uri = guide.getUri(source)
    local mark = {}
    local chunks = {}
    local returnIndex = 0
    for _, doc in ipairs(docGroup) do
        if     doc.type == 'doc.param' then
            local name = doc.param[1]
            if name == '...' then
                name = '...(param)'
            end
            if mark[name] then
                goto CONTINUE
            end
            mark[name] = true
            chunks[#chunks+1] = buildEnumChunk(doc.extends, name, uri)
        elseif doc.type == 'doc.return' then
            for _, rtn in ipairs(doc.returns) do
                returnIndex = returnIndex + 1
                local name = rtn.name and rtn.name[1] or ('return #%d'):format(returnIndex)
                if name == '...' then
                    name = '...(return)'
                end
                if mark[name] then
                    goto CONTINUE
                end
                mark[name] = true
                chunks[#chunks+1] = buildEnumChunk(rtn, name, uri)
            end
        end
        ::CONTINUE::
    end
    if #chunks == 0 then
        return nil
    end
    return table.concat(chunks, '\n\n')
end

local function tryDocFieldComment(source)
    if source.type ~= 'doc.field' then
        return
    end
    if source.comment then
        return normalizeComment(source.comment.text, guide.getUri(source))
    end
    if source.bindGroup then
        return getBindComment(source)
    end
end

local function getFunctionComment(source, raw)
    local docGroup = source.bindDocs
    if not docGroup then
        return
    end

    local hasReturnComment = false
    for _, doc in ipairs(source.bindDocs) do
        if doc.type == 'doc.return' and doc.comment then
            hasReturnComment = true
            break
        end
    end

    local uri = guide.getUri(source)
    local md = markdown()
    for _, doc in ipairs(docGroup) do
        if     doc.type == 'doc.comment' then
            local comment = normalizeComment(doc.comment.text, uri)
            md:add('md', comment)
        elseif doc.type == 'doc.param' and not raw then
            if doc.comment then
                md:add('md', ('@*param* `%s` — %s'):format(
                    doc.param[1],
                    doc.comment.text
                ))
            end
        elseif doc.type == 'doc.return' and not raw then
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

    local comment = md:string()
    if comment == '' then
        return nil
    end
    return comment
end

---@async
local function tryDocComment(source, raw)
    local md = markdown()
    if source.value and source.value.type == 'function' then
        source = source.value
    end
    if source.type == 'function' then
        local comment = getFunctionComment(source, raw)
        md:add('md', comment)
        source = source.parent
    end
    local comment = lookUpDocComments(source)
    md:add('md', comment)
    if source.type == 'doc.alias' then
        local enums = buildEnumChunk(source, source.alias[1], guide.getUri(source))
        md:add('lua', enums)
    end
    if source.type == 'doc.enum' then
        local enums = buildEnumChunk(source, source.enum[1], guide.getUri(source))
        md:add('lua', enums)
    end
    local result = md:string()
    if result == '' then
        return nil
    end
    return result
end

---@async
local function tryDocOverloadToComment(source, raw)
    if source.type ~= 'doc.type.function' then
        return
    end
    local doc = source.parent
    if doc.type ~= 'doc.overload'
    or not doc.bindSource then
        return
    end
    local md = tryDocComment(doc.bindSource, raw)
    if md then
        return md
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
    for i = #source.bindDocs, 1, -1 do
        local doc = source.bindDocs[i]
        if  doc.type == 'doc.param'
        and doc.param[1] == source[1]
        and doc.comment then
            return doc.comment.text
        end
    end
end

---@param source parser.object
local function tryDocEnum(source)
    if source.type ~= 'doc.enum' then
        return
    end
    local tbl = source.bindSource
    if not tbl then
        return
    end
    if vm.docHasAttr(source, 'key') then
        local md = markdown()
        local keys = {}
        for _, field in ipairs(tbl) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                if not field.value then
                    goto CONTINUE
                end
                local key = guide.getKeyName(field)
                if not key then
                    goto CONTINUE
                end
                keys[#keys+1] = ('%q'):format(key)
                ::CONTINUE::
            end
        end
        md:add('lua', table.concat(keys, ' | '))
        return md:string()
    else
        local md = markdown()
        md:add('lua', '{')
        for _, field in ipairs(tbl) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                if not field.value then
                    goto CONTINUE
                end
                local key = guide.getKeyName(field)
                if not key then
                    goto CONTINUE
                end
                if field.value.type == 'integer'
                or field.value.type == 'string' then
                    md:add('lua', ('    %s: %s = %s,'):format(key, field.value.type, field.value[1]))
                end
                if field.value.type == 'binary'
                or field.value.type == 'unary' then
                    local number = vm.getNumber(field.value)
                    if number then
                        md:add('lua', ('    %s: %s = %s,'):format(key, math.tointeger(number) and 'integer' or 'number', number))
                    end
                end
                ::CONTINUE::
            end
        end
        md:add('lua', '}')
        return md:string()
    end
end

---@async
return function (source, raw)
    if source.type == 'string' then
        return asString(source)
    end
    if source.type == 'doc.tailcomment' then
        return source.text
    end
    if source.type == 'field' then
        source = source.parent
    end
    return tryDocOverloadToComment(source, raw)
        or tryDocFieldComment(source)
        or tyrDocParamComment(source)
        or tryDocComment(source, raw)
        or tryDocClassComment(source)
        or tryDocModule(source)
        or tryDocEnum(source)
end
