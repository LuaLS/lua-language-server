local lclient  = require 'lclient'
local furi     = require 'file-uri'
local ws       = require 'workspace'
local files    = require 'files'
local util     = require 'utility'
local json     = require 'json-beautify'
local lang     = require 'language'
local define   = require 'proto.define'
local config   = require 'config.config'
local await    = require 'await'
local vm       = require 'vm'
local guide    = require 'parser.guide'
local getDesc  = require 'core.hover.description'
local getLabel = require 'core.hover.label'

lang(LOCALE)

if type(DOC) ~= 'string' then
    print(lang.script('CLI_CHECK_ERROR_TYPE', type(DOC)))
    return
end

local rootUri = furi.encode(DOC)
if not rootUri then
    print(lang.script('CLI_CHECK_ERROR_URI', DOC))
    return
end

util.enableCloseFunction()

local lastClock = os.clock()
local results = {}

---@async
local function packObject(source, mark)
    if type(source) ~= 'table' then
        return source
    end
    if not mark then
        mark = {}
    end
    if mark[source] then
        return
    end
    mark[source] = true
    local new = {}
    if (#source > 0 and next(source, #source) == nil)
    or source.type == 'funcargs' then
        new = {}
        for i = 1, #source do
            new[i] = packObject(source[i], mark)
        end
    else
        for k, v in pairs(source) do
            if k == 'type'
            or k == 'name'
            or k == 'start'
            or k == 'finish'
            or k == 'types' then
                new[k] = packObject(v, mark)
            end
        end
        if source.type == 'function' then
            new['args'] = packObject(source.args, mark)
            local _, _, max = vm.countReturnsOfFunction(source)
            if max > 0 then
                new.returns = {}
                for i = 1, max do
                    local rtn = vm.getReturnOfFunction(source, i)
                    new.returns[i] = packObject(rtn)
                end
            end
            new['view'] = getLabel(source)
        end
        if source.type == 'doc.type.table' then
            new['fields'] = packObject(source.fields, mark)
        end
        if source.type == 'doc.field.name'
        or source.type == 'doc.type.arg.name' then
            new['[1]'] = packObject(source[1], mark)
            new['view'] = source[1]
        end
        if source.type == 'doc.type.function' then
            new['args'] = packObject(source.args, mark)
            if source.returns then
                new['returns'] = packObject(source.returns, mark)
            end
        end
        if source.bindDocs then
            new['desc'] = getDesc(source)
        end
        new['view'] = new['view'] or vm.getInfer(source):view(rootUri)
    end
    return new
end

---@async
local function getExtends(source)
    if source.type == 'doc.class' then
        if not source.extends then
            return nil
        end
        return packObject(source.extends)
    end
    if source.type == 'doc.alias' then
        if not source.extends then
            return nil
        end
        return packObject(source.extends)
    end
end

---@async
---@param global vm.global
local function collect(global)
    if guide.isBasicType(global.name) then
        return
    end
    local result = {
        name    = global.name,
        desc    = nil,
        defines = {},
        fields  = {},
    }
    for _, set in ipairs(global:getSets(rootUri)) do
        local uri = guide.getUri(set)
        if files.isLibrary(uri) then
            goto CONTINUE
        end
        result.defines[#result.defines+1] = {
            type    = set.type,
            file    = guide.getUri(set),
            start   = set.start,
            finish  = set.finish,
            extends = getExtends(set),
        }
        result.desc = result.desc or getDesc(set)
        ::CONTINUE::
    end
    if #result.defines == 0 then
        return
    end
    table.sort(result.defines, function (a, b)
        if a.file ~= b.file then
            return a.file < b.file
        end
        return a.start < b.start
    end)
    results[#results+1] = result
    ---@async
    ---@diagnostic disable-next-line: not-yieldable
    vm.getClassFields(rootUri, global, nil, false, function (source)
        if source.type == 'doc.field' then
            ---@cast source parser.object
            if files.isLibrary(guide.getUri(source)) then
                return
            end
            local field = {}
            result.fields[#result.fields+1] = field
            if source.field.type == 'doc.field.name' then
                field.name = source.field[1]
            else
                field.name = ('[%s]'):format(vm.viewObject(source.field, rootUri))
            end
            field.type    = source.type
            field.file    = guide.getUri(source)
            field.start   = source.start
            field.finish  = source.finish
            field.desc    = getDesc(source)
            field.extends = packObject(source.extends)
            return
        end
        if source.type == 'setfield'
        or source.type == 'setmethod' then
            ---@cast source parser.object
            if files.isLibrary(guide.getUri(source)) then
                return
            end
            local field = {}
            result.fields[#result.fields+1] = field
            field.name    = (source.field or source.method)[1]
            field.type    = source.type
            field.file    = guide.getUri(source)
            field.start   = source.start
            field.finish  = source.finish
            field.desc    = getDesc(source)
            field.extends = packObject(source.value)
            return
        end
        if source.type == 'tableindex' then
            ---@cast source parser.object
            if source.index.type ~= 'string' then
                return
            end
            if files.isLibrary(guide.getUri(source)) then
                return
            end
            local field = {}
            result.fields[#result.fields+1] = field
            field.name    = source.index[1]
            field.type    = source.type
            field.file    = guide.getUri(source)
            field.start   = source.start
            field.finish  = source.finish
            field.desc    = getDesc(source)
            field.extends = packObject(source.value)
            return
        end
    end)
    table.sort(result.fields, function (a, b)
        if a.name ~= b.name then
            return a.name < b.name
        end
        if a.file ~= b.file then
            return a.file < b.file
        end
        return a.start < b.start
    end)
end

---@async
lclient():start(function (client)
    client:registerFakers()

    client:initialize {
        rootUri = rootUri,
    }

    io.write(lang.script('CLI_DOC_INITING'))

    config.set(nil, 'Lua.diagnostics.enable', false)
    config.set(nil, 'Lua.hover.expandAlias', false)

    ws.awaitReady(rootUri)
    await.sleep(0.1)

    local globals = vm.getGlobals 'type'

    local max  = #globals
    for i, global in ipairs(globals) do
        collect(global)
        if os.clock() - lastClock > 0.2 then
            lastClock = os.clock()
            local output = '\x0D'
                        .. ('>'):rep(math.ceil(i / max * 20))
                        .. ('='):rep(20 - math.ceil(i / max * 20))
                        .. ' '
                        .. ('0'):rep(#tostring(max) - #tostring(i))
                        .. tostring(i) .. '/' .. tostring(max)
            io.write(output)
        end
    end
    io.write('\x0D')

    table.sort(results, function (a, b)
        return a.name < b.name
    end)
end)

local outpath = LOGPATH .. '/doc.json'
json.supportSparseArray = true
util.saveFile(outpath, json.beautify(results))

require 'cli.doc2md'
