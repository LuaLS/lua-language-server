ls.vm.registerCoderProvider('cat', function (coder, source)
    ---@cast source LuaParser.Node.Cat
    coder:compile(source.value)
end)

ls.vm.registerCoderProvider('catstateclass', function (coder, source)
    ---@cast source LuaParser.Node.CatStateClass

    local classParams = {
        qid = string.format('%q', source.classID.id),
        class = coder:getKey(source),
        location = coder:makeLocationCode(source),
    }

    coder:addLine('{class} = rt.class {qid}' % classParams)
    coder:addLine('{class}:setLocation {location}' % classParams)

    if source.typeParams then
        for i, param in ipairs(source.typeParams) do
            coder:compile(param)
            coder:addLine('{class}:addTypeParam({param})' % {
                class = coder:getKey(source),
                param = coder:getKey(param),
            })
            coder:addLine('')
        end
    end

    if source.extends then
        for i, extend in ipairs(source.extends) do
            coder:compile(extend)
            coder:addLine('{class}:addExtends({extend})' % {
                class  = coder:getKey(source),
                extend = coder:getKey(extend),
            })
            coder:addLine('')
        end
    end

    coder:addDisposer('{class}:dispose()' % classParams)

    coder:setBlockKV('lastClass', classParams)

    coder:clearCatGroup()
    coder:addToCatGroup(source.parent)
end)

ls.vm.registerCoderProvider('catstatefield', function (coder, source)
    ---@cast source LuaParser.Node.CatStateField

    local classParams = coder:getBlockKV('lastClass')

    local key = coder:getKey(source.key)
    coder:compile(source.key)

    local value = coder:getKey(source.value)
    coder:compile(source.value)

    if not classParams then
        return
    end

    local field = coder:getKey(source)
    coder:addLine([[
{field} = rt.field({key}, {value}):setLocation {location}
]] % {
        field = field,
        key = key,
        value = value,
        location = coder:makeLocationCode(source),
    })

    coder:addLine('{class}:addField({field})' % {
        class = classParams.class,
        field = field,
    })

    -- coder:addDisposer('{class}:removeField({field})' % {
    --     class = classParams.class,
    --     field = field,
    -- })
end)

---@param coder VM.Coder
---@param source { id: string }
local function compileID(coder, source)
    coder:addLine('{key} = rt.value {name:q}' % {
        key = coder:getKey(source),
        name = source.id,
    })
end

ls.vm.registerCoderProvider('catfieldname', function (coder, source)
    ---@cast source LuaParser.Node.CatFieldName

    compileID(coder, source)
end)

ls.vm.registerCoderProvider('catid', function (coder, source)
    ---@cast source LuaParser.Node.CatID

    if source.generic then
        coder:addLine('{id} = {generic}' % {
            id      = coder:getKey(source),
            generic = coder:getKey(source.generic),
        })
    else
        if source.optional then
            coder:addLine('{id} = rt.type {name:q} | rt.NIL' % {
                id = coder:getKey(source),
                name = source.id,
            })
        else
            coder:addLine('{id} = rt.type {name:q}' % {
                id = coder:getKey(source),
                name = source.id,
            })
        end
    end
end)

ls.vm.registerCoderProvider('catstateparam', function (coder, source)
    ---@cast source LuaParser.Node.CatStateParam

    if source.value then
        coder:compile(source.value)
    end

    coder:addToCatGroup(source.parent, true)
end)

ls.vm.registerCoderProvider('catstatereturn', function (coder, source)
    ---@cast source LuaParser.Node.CatStateReturn

    coder:compile(source.value)

    coder:addToCatGroup(source.parent, true)
end)

ls.vm.registerCoderProvider('catstatealias', function (coder, source)
    ---@cast source LuaParser.Node.CatStateAlias

    coder:addLine('{alias} = rt.alias({name:q})' % {
        alias = coder:getKey(source),
        name  = source.aliasID.id,
    })

    if source.typeParams then
        for i, param in ipairs(source.typeParams) do
            coder:compile(param)
            coder:addLine('{alias}:addTypeParam({param})' % {
                alias = coder:getKey(source),
                param = coder:getKey(param),
            })
            coder:addLine('')
        end
    end

    if source.extends then
        coder:compile(source.extends)
        coder:addLine('{alias}:setValue({value})' % {
            alias = coder:getKey(source),
            value = coder:getKey(source.extends),
        })
    end

    coder:addDisposer('{alias}:dispose()' % {
        alias = coder:getKey(source),
        name  = source.aliasID.id,
    })

    coder:addToCatGroup(source.parent, true)
end)

ls.vm.registerCoderProvider('catinteger', function (coder, source)
    ---@cast source LuaParser.Node.CatInteger

    coder:addLine('{key} = rt.value({value})' % {
        key = coder:getKey(source),
        value = source.value,
    })
end)

ls.vm.registerCoderProvider('catstring', function (coder, source)
    ---@cast source LuaParser.Node.CatString

    coder:addLine('{key} = rt.value {value:q}' % {
        key = coder:getKey(source),
        value = source.value,
    })
end)

ls.vm.registerCoderProvider('catunion', function (coder, source)
    ---@cast source LuaParser.Node.CatUnion

    local parts = {}
    for i, v in ipairs(source.exps) do
        coder:compile(v)
        parts[i] = coder:getKey(v)
    end

    coder:addLine('{key} = rt.union { {parts} }' % {
        key = coder:getKey(source),
        parts = table.concat(parts, ', '),
    })
end)

ls.vm.registerCoderProvider('catintersection', function (coder, source)
    ---@cast source LuaParser.Node.CatIntersection

    local parts = {}
    for i, v in ipairs(source.exps) do
        coder:compile(v)
        parts[i] = coder:getKey(v)
    end

    coder:addLine('{key} = rt.intersection { {parts} }' % {
        key = coder:getKey(source),
        parts = table.concat(parts, ', '),
    })
end)

ls.vm.registerCoderProvider('catarray', function (coder, source)
    ---@cast source LuaParser.Node.CatArray

    coder:compile(source.node)

    coder:addLine('{key} = rt.array({value})' % {
        key   = coder:getKey(source),
        value = coder:getKey(source.node),
    })
end)

ls.vm.registerCoderProvider('cattable', function (coder, source)
    ---@cast source LuaParser.Node.CatTable

    coder:addLine('{key} = rt.table()' % {
        key = coder:getKey(source),
    })

    for i, field in ipairs(source.fields) do
        coder:compile(field)
        coder:addLine('{table}:addField({field})' % {
            table = coder:getKey(source),
            field = coder:getKey(field),
        })
        coder:addLine('')
    end
end)

ls.vm.registerCoderProvider('cattablefield', function (coder, source)
    ---@cast source LuaParser.Node.CatTableField

    coder:compile(source.key)
    coder:compile(source.value)

    coder:addLine([[
{field} = rt.field({key}, {value}):setLocation {location}
]] % {
        field    = coder:getKey(source),
        key      = coder:getKey(source.key),
        value    = coder:getKey(source.value),
        location = coder:makeLocationCode(source.key),
    })
end)

ls.vm.registerCoderProvider('cattablefieldid', function (coder, source)
    ---@cast source LuaParser.Node.CatTableFieldID

    compileID(coder, source)
end)

ls.vm.registerCoderProvider('cattuple', function (coder, source)
    ---@cast source LuaParser.Node.CatTuple

    local parts = {}
    for i, item in ipairs(source.exps) do
        coder:compile(item)
        parts[i] = coder:getKey(item)
    end

    coder:addLine('{key} = rt.tuple { {parts} }' % {
        key = coder:getKey(source),
        parts = table.concat(parts, ', '),
    })
end)

ls.vm.registerCoderProvider('catcall', function (coder, source)
    ---@cast source LuaParser.Node.CatCall

    coder:compile(source.node)
    local args = {}
    for i, arg in ipairs(source.args) do
        coder:compile(arg)
        args[i] = coder:getKey(arg)
    end

    coder:addLine('{key} = rt.call({type:q}, { {args} })' % {
        key  = coder:getKey(source),
        type = source.node.id,
        args = table.concat(args, ', '),
    })
end)

ls.vm.registerCoderProvider('catfunction', function (coder, source)
    ---@cast source LuaParser.Node.CatFunction

    coder:addLine('{key} = rt.func()' % {
        key = coder:getKey(source),
    })

    if source.async then
        coder:addLine('{func}:setAsync()' % {
            func = coder:getKey(source),
        })
    end

    if source.typeParams then
        coder:addLine('')
        for _, typeParam in ipairs(source.typeParams) do
            coder:compile(typeParam)
            coder:addLine('{func}:addTypeParam({param})' % {
                func  = coder:getKey(source),
                param = coder:getKey(typeParam),
            })
        end
    end

    if source.params then
        for _, param in ipairs(source.params) do
            coder:addLine('')
            coder:compile(param.value)
            coder:addLine('{func}:addParamDef({name:q}, {param}, {optional:q})' % {
                func     = coder:getKey(source),
                name     = param.name.id,
                param    = coder:getKey(param.value),
                optional = param.optional,
            })
        end
    end

    if source.returns then
        for _, ret in ipairs(source.returns) do
            coder:addLine('')
            coder:compile(ret.value)
            coder:addLine('{func}:addReturnDef({name:q}, {param}, {optional:q})' % {
                func     = coder:getKey(source),
                name     = ret.name and ret.name.id or nil,
                param    = coder:getKey(ret.value),
                optional = ret.optional,
            })
        end
    end
end)

ls.vm.registerCoderProvider('catgeneric', function (coder, source)
    ---@cast source LuaParser.Node.CatGeneric

    if source.extends then
        coder:compile(source.extends)
        coder:addLine('{key} = rt.generic({name:q}, {extends})' % {
            key     = coder:getKey(source),
            name    = source.id.id,
            extends = coder:getKey(source.extends),
        })
    else
        coder:addLine('{key} = rt.generic {name:q}' % {
            key = coder:getKey(source),
            name = source.id.id,
        })
    end
end)

ls.vm.registerCoderProvider('catindex', function (coder, source)
    ---@cast source LuaParser.Node.CatIndex

    coder:compile(source.node)
    coder:compile(source.index)

    coder:addLine('{key} = rt.index({node}, {index})' % {
        key   = coder:getKey(source),
        node  = coder:getKey(source.node),
        index = coder:getKey(source.index),
    })
end)

ls.vm.registerCoderProvider('catstatetype', function (coder, source)
    ---@cast source LuaParser.Node.CatStateType

    coder:compile(source.exp)

    coder:addToCatGroup(source.parent, true)
end)

ls.vm.registerCoderProvider('catstategeneric', function (coder, source)
    ---@cast source LuaParser.Node.CatStateGeneric

    if not source.typeParams then
        return
    end
    for i, typeParam in ipairs(source.typeParams) do
        coder:compile(typeParam)
    end

    coder:addToCatGroup(source.parent, true)
end)
