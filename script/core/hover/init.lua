local files      = require 'files'
local vm         = require 'vm'
local getLabel   = require 'core.hover.label'
local getDesc    = require 'core.hover.description'
local util       = require 'utility'
local findSource = require 'core.find-source'
local markdown   = require 'provider.markdown'
local guide      = require 'parser.guide'
local wssymbol   = require 'core.workspace-symbol'

---@async
local function getHover(source)
    local md        = markdown()
    local defMark   = {}
    local labelMark = {}
    local descMark  = {}

    if source.type == 'doc.see.name' then
        for _, symbol in ipairs(wssymbol(source[1], guide.getUri(source))) do
            if symbol.name == source[1] then
                source = symbol.source
                break
            end
        end
    end

    ---@async
    local function addHover(def, checkLable, oop)
        if defMark[def] then
            return
        end
        defMark[def] = true

        if checkLable then
            local label = getLabel(def, oop)
            if not labelMark[tostring(label)] then
                labelMark[tostring(label)] = true
                md:add('lua', label)
                md:splitLine()
            end
        end

        local desc  = getDesc(def)
        if not descMark[tostring(desc)] then
            descMark[tostring(desc)] = true
            md:add('md', desc)
            md:splitLine()
        end
    end

    local oop
    if vm.getInfer(source):view(guide.getUri(source)) == 'function' then
        local defs = vm.getDefs(source)
        -- make sure `function` is before `doc.type.function`
        local orders = {}
        for i, def in ipairs(defs) do
            if def.type == 'function' then
                orders[def] = i - 20000
            elseif def.type == 'doc.type.function' then
                orders[def] = i - 10000
            else
                orders[def] = i
            end
        end
        table.sort(defs, function (a, b)
            return orders[a] < orders[b]
        end)
        local hasFunc
        for _, def in ipairs(defs) do
            if guide.isOOP(def) then
                oop = true
            end
            if  def.type == 'function'
            and not vm.isVarargFunctionWithOverloads(def) then
                hasFunc = true
                addHover(def, true, oop)
            end
            if def.type == 'doc.type.function' then
                hasFunc = true
                addHover(def, true, oop)
            end
        end
        if not hasFunc then
            addHover(source, true, oop)
        end
    else
        addHover(source, true, oop)
        for _, def in ipairs(vm.getDefs(source)) do
            if def.type == 'global'
            or def.type == 'setlocal' then
                goto CONTINUE
            end
            if guide.isOOP(def) then
                oop = true
            end
            local isFunction
            if def.type == 'function'
            or def.type == 'doc.type.function' then
                isFunction = true
            end
            addHover(def, isFunction, oop)
            ::CONTINUE::
        end
    end

    return md
end

local accept = {
    ['local']          = true,
    ['setlocal']       = true,
    ['getlocal']       = true,
    ['setglobal']      = true,
    ['getglobal']      = true,
    ['field']          = true,
    ['method']         = true,
    ['string']         = true,
    ['number']         = true,
    ['integer']        = true,
    ['doc.type.name']  = true,
    ['doc.class.name'] = true,
    ['doc.enum.name']  = true,
    ['function']       = true,
    ['doc.module']     = true,
    ['doc.see.name']   = true,
}

---@async
local function getHoverByUri(uri, position)
    local ast = files.getState(uri)
    if not ast then
        return nil
    end
    local source = findSource(ast, position, accept)
    if not source then
        return nil
    end
    local hover = getHover(source)
    if SHOWSOURCE then
        hover:splitLine()
        hover:add('md', 'Source Info')
        hover:add('lua', util.dump(source, {
            deep = 1,
        }))
    end
    if SHOWNODE then
        hover:splitLine()
        hover:add('md', 'Node Info')
        hover:add('lua', util.dump(vm.compileNode(source), {
            deep = 1,
        }))
    end
    return hover, source
end

return {
    get   = getHover,
    byUri = getHoverByUri,
}
