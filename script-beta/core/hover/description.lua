local vm       = require 'vm'
local ws       = require 'workspace'
local furi     = require 'file-uri'
local files    = require 'files'
local guide    = require 'parser.guide'
local markdown = require 'provider.markdown'
local config   = require 'config'
local client   = require 'provider.client'
local lang     = require 'language'
local platform = require 'bee.platform'

local function asStringInRequire(source, literal)
    local parent = source.parent
    if parent and parent.type == 'callargs' then
        local result, searchers
        local call = parent.parent
        local func = call.node
        local lib = vm.getLibrary(func)
        if not lib then
            return
        end
        if     lib.name == 'require' then
            result, searchers = ws.findUrisByRequirePath(literal)
        elseif lib.name == 'dofile'
        or     lib.name == 'loadfile' then
            result = ws.findUrisByFilePath(literal)
        end
        if result and #result > 0 then
            for i, uri in ipairs(result) do
                local searcher = searchers and furi.decode(searchers[uri])
                uri = files.getOriginUri(uri)
                local path = furi.decode(uri)
                if files.eq(path:sub(1, #ws.path), ws.path) then
                    path = path:sub(#ws.path + 1)
                end
                path = path:gsub('^[/\\]*', '')
                if searcher then
                    searcher = searcher:sub(#ws.path + 1)
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

local function getDocFormater()
    local version = config.config.runtime.version
    if client.client() == 'vscode' then
        if version == 'Lua 5.1' then
            return 'HOVER_NATIVE_DOCUMENT_LUA51'
        elseif version == 'Lua 5.2' then
            return 'HOVER_NATIVE_DOCUMENT_LUA52'
        elseif version == 'Lua 5.3' then
            return 'HOVER_NATIVE_DOCUMENT_LUA53'
        elseif version == 'Lua 5.4' then
            return 'HOVER_NATIVE_DOCUMENT_LUA54'
        elseif version == 'LuaJIT' then
            return 'HOVER_NATIVE_DOCUMENT_LUAJIT'
        end
    else
        if version == 'Lua 5.1' then
            return 'HOVER_DOCUMENT_LUA51'
        elseif version == 'Lua 5.2' then
            return 'HOVER_DOCUMENT_LUA52'
        elseif version == 'Lua 5.3' then
            return 'HOVER_DOCUMENT_LUA53'
        elseif version == 'Lua 5.4' then
            return 'HOVER_DOCUMENT_LUA54'
        elseif version == 'LuaJIT' then
            return 'HOVER_DOCUMENT_LUAJIT'
        end
    end
end

local function buildLibEnum(enum)
    local line = {}
    if enum.default then
        line[#line+1] = '  ->'
    else
        line[#line+1] = '   |'
    end
    line[#line+1] = enum.enum
    if enum.description then
        line[#line+1] = '--'
        line[#line+1] = enum.description
    end
    return table.concat(line, ' ')
end

local function getArgType(value, name)
    if not value.args then
        return ''
    end
    for _, arg in ipairs(value.args) do
        if arg.name == name then
            if type(arg.type) == 'table' then
                return ' ' .. table.concat(arg.type, '|')
            else
                return arg.type and (' ' .. arg.type) or ''
            end
        end
    end
    return ''
end

local function buildLibEnums(value)
    local results = {}
    local sorts = {}

    for _, enum in ipairs(value.enums) do
        local name = enum.name
        if not results[name] then
            results[name] = { name .. ':' .. getArgType(value, name) }
            sorts[#sorts+1] = name
        end
        results[name][#results[name]+1] = buildLibEnum(enum)
    end

    local lines = {}
    for _, name in ipairs(sorts) do
        lines[#lines+1] = table.concat(results[name], '\n')
    end
    return table.concat(lines, '\n\n')
end

local function tryLibrary(source)
    local lib = vm.getLibrary(source)
    if not lib then
        return nil
    end
    local fmt = getDocFormater()
    local md = markdown()
    if lib.value.description then
        md:add('md', lib.value.description:gsub('%(doc%:(.-)%)', function (tag)
            if fmt then
                return '(' .. lang.script(fmt, tag) .. ')'
            end
        end))
    end
    if lib.value.enums then
        md:add('md', '-------------')
        md:add('lua', buildLibEnums(lib.value))
    end
    if lib.value.doc and fmt then
        md:add('md', ('[%s](%s)'):format(lang.script.HOVER_VIEW_DOCUMENTS, lang.script(fmt, 'pdf-' .. lib.value.doc)))
    end
    return md:string()
end

return function (source)
    if source.type == 'string' then
        return asString(source)
    end
    return tryLibrary(source)
end
