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
    if #source > 0 and next(source, #source) == nil then
        new = {}
        for i = 1, #source do
            new[i] = packObject(source[i], mark)
        end
    else
        for k, v in pairs(source) do
            if type(k) == 'number' then
                k = ('[%d]'):format(k)
            end
            if k == 'parent'
            or k == 'typeGeneric'
            or k == 'originalComment'
            or k == 'node'
            or k == 'class'
            or k:find '_'
            or k:find 'Cache'
            or k:find 'bind' then
                goto CONTINUE
            end
            new[k] = packObject(v, mark)
            ::CONTINUE::
        end
    end
    new['*view*'] = vm.viewObject(source, rootUri)
    return new
end

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

---@param global vm.global
local function collect(global)
    if guide.isBasicType(global.name) then
        return
    end
    local result = {
        name    = global.name,
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
            desc    = getDesc(set),
            extends = getExtends(set),
        }
        ::CONTINUE::
    end
    if #result.defines == 0 then
        return
    end
    results[#results+1] = result
    vm.getClassFields(rootUri, global, nil, false, function (source)
        local field = {}
        result.fields[#result.fields+1] = field
        if source.type == 'doc.field' then
            ---@cast source parser.object
            field.type    = source.type
            field.key     = vm.viewObject(source.field, rootUri)
            field.file    = guide.getUri(source)
            field.start   = source.start
            field.finish  = source.finish
            field.desc    = getDesc(source)
            field.extends = packObject(source.extends)
            return
        end
        print(1)
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
