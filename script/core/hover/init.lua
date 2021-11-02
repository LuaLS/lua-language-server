local files      = require 'files'
local vm         = require 'vm'
local getLabel   = require 'core.hover.label'
local getDesc    = require 'core.hover.description'
local util       = require 'utility'
local findSource = require 'core.find-source'
local markdown   = require 'provider.markdown'
local infer      = require 'core.infer'

---@async
local function getHover(source)
    local md        = markdown()
    local defMark   = {}
    local labelMark = {}
    local descMark  = {}

    ---@async
    local function addHover(def, checkLable)
        if defMark[def] then
            return
        end
        defMark[def] = true

        if checkLable then
            local label = getLabel(def)
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

    if infer.searchAndViewInfers(source) == 'function' then
        local hasFunc
        for _, def in ipairs(vm.getDefs(source)) do
            if def.type == 'function'
            or def.type == 'doc.type.function' then
                hasFunc = true
                addHover(def, true)
            end
        end
        if not hasFunc then
            addHover(source, true)
        end
    else
        addHover(source, true)
        for _, def in ipairs(vm.getDefs(source)) do
            local isFunction
            if def.type == 'function'
            or def.type == 'doc.type.function' then
                isFunction = true
            end
            addHover(def, isFunction)
        end
    end

    return md
end

local accept = {
    ['local']         = true,
    ['setlocal']      = true,
    ['getlocal']      = true,
    ['setglobal']     = true,
    ['getglobal']     = true,
    ['field']         = true,
    ['method']        = true,
    ['string']        = true,
    ['number']        = true,
    ['integer']       = true,
    ['doc.type.name'] = true,
    ['function']      = true,
    ['doc.module']    = true,
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
        hover:add('lua', util.dump(source, {
            deep = 1,
        }))
    end
    return hover, source
end

return {
    get   = getHover,
    byUri = getHoverByUri,
}
