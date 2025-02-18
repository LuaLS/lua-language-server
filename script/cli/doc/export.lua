---@diagnostic disable: await-in-sync, param-type-mismatch
local ws       = require 'workspace'
local vm       = require 'vm'
local guide    = require 'parser.guide'

local getDesc  = require 'core.hover.description'
local getLabel = require 'core.hover.label'
local jsonb    = require 'json-beautify'
local util     = require 'utility'
local markdown = require 'provider.markdown'
local fs       = require 'bee.filesystem'
local furi     = require 'file-uri'

---@alias doctype
---| 'doc.alias'
---| 'doc.class'
---| 'doc.field'
---| 'doc.field.name'
---| 'doc.type.arg.name'
---| 'doc.type.function'
---| 'doc.type.table'
---| 'funcargs'
---| 'function'
---| 'function.return'
---| 'global.type'
---| 'global.variable'
---| 'local'
---| 'luals.config'
---| 'self'
---| 'setfield'
---| 'setglobal'
---| 'setindex'
---| 'setmethod'
---| 'tableindex'
---| 'type'

---@class docUnion broadest possible collection of exported docs, these are never all together.
---@field [1] string in name when table, always the same as view
---@field args docUnion[] list of argument docs passed to function
---@field async boolean has @async tag
---@field defines docUnion[] list of places where this is doc is defined and how its defined there
---@field deprecated boolean has @deprecated tag
---@field desc string code commentary
---@field extends string | docUnion ? what type this 'is'. string:<Parent_Class> for type: 'type', docUnion for type: 'function', string<primative> for other type 's
---@field fields docUnion[] class's fields
---@field file string path to where this token is defined
---@field finish [integer, integer] 0-indexed [line, column] position of end of token
---@field name string canonical name
---@field rawdesc string same as desc, but may have other things for types doc.retun andr doc.param (unused?)
---@field returns docUnion | docUnion[] list of docs for return values. if singluar, then always {type: 'undefined'}? might be a bug.
---@field start [integer, integer] 0-indexed [line, column] position of start of token
---@field type doctype role that this token plays in documentation. different from the 'type'/'class' this token is
---@field types docUnion[] type union? unclear. seems to be related to alias, maybe
---@field view string full method name, class, basal type, or unknown. in name table same as [1]
---@field visible 'package'|'private'|'protected'|'public' visibilty tag

local export = {}

function export.getLocalPath(uri)
    local file_canonical = fs.canonical(furi.decode(uri)):string()
    local doc_canonical = fs.canonical(DOC):string()
    local relativePath = fs.relative(file_canonical, doc_canonical):string()
    if relativePath == "" or relativePath:sub(1, 2) == '..' then
        -- not under project directory
        return '[FOREIGN] ' .. file_canonical
    end
    return relativePath
end

function export.positionOf(rowcol)
    return type(rowcol) == 'table' and guide.positionOf(rowcol[1], rowcol[2]) or -1
end

function export.sortDoc(a,b)
    if a.name ~= b.name then
        return a.name < b.name
    end

    if a.file ~= b.file then
        return a.file < b.file
    end

    return export.positionOf(a.start) < export.positionOf(b.start)
end


--- recursively generate documentation all parser objects downstream of `source`
---@async
---@param source parser.object | vm.global
---@param has_seen table? keeps track of visited nodes in documentation tree
---@return docUnion | [docUnion] | string | number | boolean | nil 
function export.documentObject(source, has_seen)
    --is this a primative type? then we dont need to process it.
    if type(source) ~= 'table' then return source end

    --set up/check recursion
    if not has_seen then has_seen = {} end
    if has_seen[source] then
        return nil
    end
    has_seen[source] = true

    --is this an array type? then process each array item and collect it
    if (#source > 0 and next(source, #source) == nil) then
        local objs = {} --make a pure numerical array
        for i, child in ipairs(source) do
            objs[i] = export.documentObject(child, has_seen)
        end
        return objs
    end

    --if neither, then this is a singular docUnion
    local obj = export.makeDocObject['INIT'](source, has_seen)

    --check if this source has a type (no type sources are usually autogen'd anon functions's return values that are not explicitly stated)
    if not obj.type then return obj end

    local res = export.makeDocObject[obj.type](source, obj, has_seen)
    if res == false then
        return nil
    end
    return res or obj
end

---Switch statement table. functions can be overriden by user file.
---@table
export.makeDocObject = setmetatable({}, {__index = function(t, k)
    return function()
        --print('DocError: no type "'..k..'"')
    end
end})

export.makeDocObject['INIT'] = function(source, has_seen)
    ---@as docUnion
    local ok, desc = pcall(getDesc, source)
    local rawok, rawdesc = pcall(getDesc, source, true)
    return {
        type = source.cate or source.type,
        name = export.documentObject((source.getCodeName and source:getCodeName()) or source.name, has_seen),
        start = source.start and {guide.rowColOf(source.start)},
        finish = source.finish and {guide.rowColOf(source.finish)},
        types = export.documentObject(source.types, has_seen),
        view = vm.getInfer(source):view(ws.rootUri),
        desc = ok and desc or nil,
        rawdesc = rawok and rawdesc or nil,
    }
end

export.makeDocObject['doc.alias'] = function(source, obj, has_seen)

end

export.makeDocObject['doc.field'] = function(source, obj, has_seen)
    if source.field.type == 'doc.field.name' then
        obj.name = source.field[1]
    else
        obj.name = ('[%s]'):format(vm.getInfer(source.field):view(ws.rootUri))
    end
    obj.file = export.getLocalPath(guide.getUri(source))
    obj.extends = source.extends and export.documentObject(source.extends, has_seen) --check if bug?
    obj.async = vm.isAsync(source, true) and true or false --if vm.isAsync(set, true) then result.defines[#result.defines].extends['async'] = true end
    obj.deprecated = vm.getDeprecated(source) and true or false --  if (depr and not depr.versions) the result.defines[#result.defines].extends['deprecated'] = true end
    obj.visible = vm.getVisibleType(source)
end

export.makeDocObject['doc.class'] = function(source, obj, has_seen)
    local extends = source.extends or source.value --doc.class or other
    local field = source.field or source.method 
    obj.name = type(field) == 'table' and field[1] or nil
    obj.file = export.getLocalPath(guide.getUri(source))
    obj.extends = extends and export.documentObject(extends, has_seen)
    obj.async = vm.isAsync(source, true) and true or false
    obj.deprecated = vm.getDeprecated(source) and true or false
    obj.visible = vm.getVisibleType(source)
end

export.makeDocObject['doc.field.name'] = function(source, obj, has_seen)
    obj['[1]'] = export.documentObject(source[1], has_seen)
    obj.view = source[1]
end

export.makeDocObject['doc.type.arg.name'] = export.makeDocObject['doc.field.name']

export.makeDocObject['doc.type.function'] = function(source, obj, has_seen)
    obj.args = export.documentObject(source.args, has_seen)
    obj.returns = export.documentObject(source.returns, has_seen)
end

export.makeDocObject['doc.type.table'] = function(source, obj, has_seen)
    obj.fields = export.documentObject(source.fields, has_seen)
end

export.makeDocObject['funcargs'] = function(source, obj, has_seen)
    local objs = {} --make a pure numerical array
    for i, child in ipairs(source) do
        objs[i] = export.documentObject(child, has_seen)
    end
    return objs
end

export.makeDocObject['function'] = function(source, obj, has_seen)
    obj.args = export.documentObject(source.args, has_seen)
    obj.view = getLabel(source, source.parent.type == 'setmethod', 1)
    local _, _, max = vm.countReturnsOfFunction(source)
    if max > 0 then obj.returns = {} end
    for i = 1, max do
        obj.returns[i] = export.documentObject(vm.getReturnOfFunction(source, i), has_seen) --check if bug?
    end
end

export.makeDocObject['function.return'] = function(source, obj, has_seen)
    obj.desc = source.comment and getDesc(source.comment)
    obj.rawdesc = source.comment and getDesc(source.comment, true)
end

export.makeDocObject['local'] = function(source, obj, has_seen)
    obj.name = source[1]
end

export.makeDocObject['self'] = export.makeDocObject['local']

export.makeDocObject['setfield'] = export.makeDocObject['doc.class']

export.makeDocObject['setglobal'] = export.makeDocObject['doc.class']

export.makeDocObject['setindex'] = export.makeDocObject['doc.class']

export.makeDocObject['setmethod'] = export.makeDocObject['doc.class']

export.makeDocObject['tableindex'] = function(source, obj, has_seen)
    obj.name = source.index[1]
end

export.makeDocObject['type'] = function(source, obj, has_seen)
    if export.makeDocObject['variable'](source, obj, has_seen) == false then
        return false
    end
    obj.fields = {}
    vm.getClassFields(ws.rootUri, source, vm.ANY, function (next_source, mark)
        if next_source.type == 'doc.field'
        or next_source.type == 'setfield'
        or next_source.type == 'setmethod'
        or next_source.type == 'tableindex'
        then
            table.insert(obj.fields, export.documentObject(next_source, has_seen))
        end
    end)
    table.sort(obj.fields, export.sortDoc)
end

export.makeDocObject['variable'] = function(source, obj, has_seen)
    obj.defines = {}
    for _, set in ipairs(source:getSets(ws.rootUri)) do
        if set.type == 'setglobal'
        or set.type == 'setfield'
        or set.type == 'setmethod'
        or set.type == 'setindex'
        or set.type == 'doc.alias'
        or set.type == 'doc.class'
        then
            table.insert(obj.defines, export.documentObject(set, has_seen))
        end
    end
    if #obj.defines == 0 then return false end
    table.sort(obj.defines, export.sortDoc)
end

---gathers the globals that are to be exported in documentation
---@async
---@return table globals
function export.gatherGlobals()
    local all_globals = vm.getAllGlobals()
    local globals = {}
    for _, g in pairs(all_globals) do
        table.insert(globals, g)
    end
    return globals
end

---builds a lua table of based on `globals` and their elements
---@async
---@param globals table
---@param callback fun(i, max)
function export.makeDocs(globals, callback)
    local docs = {}
    for i, global in ipairs(globals) do
        table.insert(docs, export.documentObject(global))
        callback(i, #globals)
    end
    docs[#docs+1] = export.getLualsConfig()
    table.sort(docs, export.sortDoc)
    return docs
end

function export.getLualsConfig()
    return {
        name = 'LuaLS',
        type = 'luals.config',
        DOC = fs.canonical(fs.path(DOC)):string(),
        defines = {},
        fields = {}
    }
end

---takes the table from `makeDocs`, serializes it, and exports it
---@async
---@param docs table
---@param outputDir string
---@return boolean ok, string[] outputPaths, (string|nil)[]? errs
function export.serializeAndExport(docs, outputDir)
    local jsonPath = outputDir .. '/doc.json'
    local mdPath = outputDir .. '/doc.md'

    --export to json
    local old_jsonb_supportSparseArray = jsonb.supportSparseArray
    jsonb.supportSparseArray = true
    local jsonOk, jsonErr = util.saveFile(jsonPath, jsonb.beautify(docs))
    jsonb.supportSparseArray = old_jsonb_supportSparseArray


    --export to markdown
    local md  = markdown()
    for _, class in ipairs(docs) do
        md:add('md', '# ' .. class.name)
        md:emptyLine()
        md:add('md', class.desc)
        md:emptyLine()
        if class.defines then
            for _, define in ipairs(class.defines) do
                if define.extends then
                    md:add('lua', define.extends.view)
                    md:emptyLine()
                end
            end
        end
        if class.fields then
            local mark = {}
            for _, field in ipairs(class.fields) do
                if not mark[field.name] then
                    mark[field.name] = true
                    md:add('md', '## ' .. field.name)
                    md:emptyLine()
                    md:add('lua', field.extends.view)
                    md:emptyLine()
                    md:add('md', field.desc)
                    md:emptyLine()
                end
            end
        end
        md:splitLine()
    end
    local mdOk, mdErr = util.saveFile(mdPath, md:string())

    --error checking save file
    if( not (jsonOk and mdOk) ) then
        return false, {jsonPath, mdPath}, {jsonErr, mdErr}
    end

    return true, {jsonPath, mdPath}
end

return export
