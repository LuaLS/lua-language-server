local lclient  = require 'lclient'
local furi     = require 'file-uri'
local ws       = require 'workspace'
local files    = require 'files'
local util     = require 'utility'
local lang     = require 'language'
local config   = require 'config.config'
local await    = require 'await'
local progress = require 'progress'
local fs       = require 'bee.filesystem'

local doc = {}

---Find file 'doc.json'.
---@return fs.path
local function findDocJson()
    local doc_json_path
    if type(DOC_UPDATE) == 'string' then
        doc_json_path = fs.canonical(fs.path(DOC_UPDATE)) .. '/doc.json'
    else
        doc_json_path = fs.current_path() .. '/doc.json'
    end
    if fs.exists(doc_json_path) then
        return doc_json_path
    else
        error(string.format('Error: File "%s" not found.', doc_json_path))
    end
end

---@return string # path of 'doc.json'
---@return string # path to be documented
local function getPathDocUpdate()
    local doc_json_path = findDocJson()
    local ok, doc_path = pcall(
        function ()
            local json = require('json')
            local json_file = io.open(doc_json_path:string(), 'r'):read('*all')
            local json_data = json.decode(json_file)
            for _, section in ipairs(json_data) do
                if section.type == 'luals.config' then
                    return section.DOC
                end
            end
        end)
    if ok then
        local doc_json_dir = doc_json_path:string():gsub('/doc.json', '')
        return doc_json_dir, doc_path
    else
        error(string.format('Error: Cannot update "%s".', doc_json_path))
    end
end

---clones a module and assigns any internal upvalues pointing to the module to the new clone
---useful for sandboxing
---@param tbl any module to be cloned
---@return any module_clone the cloned module
local function reinstantiateModule(tbl, _new_module, _old_module, _has_seen)
    _old_module = _old_module or tbl --remember old module only at root
    _has_seen = _has_seen or {} --remember visited indecies
    if(type(tbl) == 'table') then
        if _has_seen[tbl] then return _has_seen[tbl] end
        local clone = {}
        _has_seen[tbl] = true
        for key, value in pairs(tbl) do
            clone[key] = reinstantiateModule(value, _new_module or clone, _old_module, _has_seen)
        end
        setmetatable(clone, getmetatable(tbl))
        return clone
    elseif(type(tbl) == 'function') then
        local func = tbl
        if _has_seen[func] then return _has_seen[func] end --copy function pointers instead of building clones
        local upvalues = {}
        local i = 1
        while true do
            local label, value = debug.getupvalue(func, i)
            if not value then break end
            upvalues[i] = value == _old_module and _new_module or value
            i = i + 1
        end
        local new_func = load(string.dump(func))--, 'function@reinstantiateModule()', 'b', _ENV)
        assert(new_func, 'could not load dumped function')
        for index, upvalue in ipairs(upvalues) do
            debug.setupvalue(new_func, index, upvalue)
        end
        _has_seen[func] = new_func
        return new_func
    else
        return tbl
    end
end

--these modules need to be loaded by the time this function is created
--im leaving them here since this is a pretty strange function that might get moved somewhere else later
--so make sure to bring these with you!
require 'workspace'
require 'vm'
require 'parser.guide'
require 'core.hover.description'
require 'core.hover.label'
require 'json-beautify'
require 'utility'
require 'provider.markdown'

---Gets config file's doc gen overrides.
---@return table dirty_module clone of the export module modified by user buildscript
local function injectBuildScript()
    local sub_path = config.get(ws.rootUri, 'Lua.docScriptPath')
    local module = reinstantiateModule( ( require 'cli.doc.export' ) )
    --if default, then no build script modifications
    if sub_path == '' then
        return module
    end
    local resolved_path = fs.absolute(fs.path(DOC)):string() .. sub_path
    local f <close> = io.open(resolved_path, 'r')
    if not f then
        error('could not open config file at '..tostring(resolved_path))
    end
    --include all `require`s in script.cli.doc.export in enviroment
    --NOTE: allows access to the global enviroment!
    local data, err = loadfile(resolved_path, 't', setmetatable({
            export = module,

            ws       = require 'workspace',
            vm       = require 'vm',
            guide    = require 'parser.guide',
            getDesc  = require 'core.hover.description',
            getLabel = require 'core.hover.label',
            jsonb    = require 'json-beautify',
            util     = require 'utility',
            markdown = require 'provider.markdown'
        },
        {__index = _G}))
    if err or not data then
        error(err, 0)
    end
    data()
    return module
end

---runtime call for documentation exporting
---@async
---@param outputPath string
function doc.makeDoc(outputPath)
    ws.awaitReady(ws.rootUri)

    local expandAlias = config.get(ws.rootUri, 'Lua.hover.expandAlias')
    config.set(ws.rootUri, 'Lua.hover.expandAlias', false)
    local _ <close> = function ()
        config.set(ws.rootUri, 'Lua.hover.expandAlias', expandAlias)
    end

    await.sleep(0.1)

    -- ready --

    local prog <close> = progress.create(ws.rootUri, lang.script('CLI_DOC_WORKING'), 0)

    local dirty_export = injectBuildScript()

    local globals = dirty_export.gatherGlobals()

    local docs = dirty_export.makeDocs(globals, function (i, max)
        prog:setMessage(('%d/%d'):format(i, max))
        prog:setPercentage((i) / max * 100)
    end)

    local ok, outPaths, err = dirty_export.serializeAndExport(docs, outputPath)
    if not ok then
        error(err)
    end

    return table.unpack(outPaths)
end

---CLI call for documentation (parameter '--DOC=...' is passed to server)
function doc.runCLI()
    lang(LOCALE)

    if DOC_UPDATE then
        DOC_OUT_PATH, DOC = getPathDocUpdate()
    end

    if type(DOC) ~= 'string' then
        print(lang.script('CLI_CHECK_ERROR_TYPE', type(DOC)))
        return
    end

    local rootUri = furi.encode(fs.canonical(fs.path(DOC)):string())
    if not rootUri then
        print(lang.script('CLI_CHECK_ERROR_URI', DOC))
        return
    end

    print('root uri = ' .. rootUri)

    --- If '--configpath' is specified, get the folder path of the '.luarc.doc.json' configuration file (without the file name)
    --- 如果指定了'--configpath'，则获取`.luarc.doc.json` 配置文件的文件夹路径(不包含文件名）
    --- This option is passed into the callback function of the initialized method in provide.
    --- 该选项会被传入到`provide`中的`initialized`方法的回调函数中
    local luarcParentUri
    if CONFIGPATH then
        luarcParentUri = furi.encode(fs.absolute(fs.path(CONFIGPATH)):parent_path():string())
    end

    util.enableCloseFunction()

    local lastClock = os.clock()

    ---@async
    lclient():start(function (client)
        client:registerFakers()

        client:initialize {
            rootUri = rootUri,
            luarcParentUri = luarcParentUri,
        }
        io.write(lang.script('CLI_DOC_INITING'))

        config.set(nil, 'Lua.diagnostics.enable', false)
        config.set(nil, 'Lua.hover.expandAlias', false)

        ws.awaitReady(rootUri)
        await.sleep(0.1)

        --ready--

        local dirty_export = injectBuildScript()

        local globals = dirty_export.gatherGlobals()

        local docs = dirty_export.makeDocs(globals, function (i, max)
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
        end)
        io.write('\x0D')

        if not DOC_OUT_PATH then
            DOC_OUT_PATH = fs.current_path():string()
        end

        local ok, outPaths, err = dirty_export.serializeAndExport(docs, DOC_OUT_PATH)
        print(lang.script('CLI_DOC_DONE'))
        for i, path in ipairs(outPaths) do
            local this_err = (type(err) == 'table') and err[i] or nil
            print(this_err or files.normalize(path))
        end
    end)
end

return doc
