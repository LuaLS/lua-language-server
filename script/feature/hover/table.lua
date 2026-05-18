ls.feature.provider.hover(function (param, action)
    local snode = param.vm:getNode(param.source)
    if not snode then
        return
    end

    snode = snode:simplify()

    ---@param prefix string
    ---@param node Node.Table
    ---@param viewOptions? Node.Viewer.Options
    local function pushWithPrefix(prefix, node, viewOptions)
        local opts = { noFunctionDetail = true, inlineMax = 0 }
        if viewOptions then
            ls.util.tableMerge(opts, viewOptions)
        end
        local label = node:view(opts)
        if label == '{}' then
            return
        end

        action.push {
            label = prefix .. label
        }
    end

    ---@param source LuaParser.Node.Base
    ---@return boolean
    local function isTypeHover(source)
        if source.kind == 'catid' then
            return true
        end
        local variable = param.vm:getVariable(source)
        if not variable then
            return false
        end
        if variable.types then
            return true
        end
        return false
    end

    ---@param source LuaParser.Node.Base
    ---@return boolean
    local function isClassHover(source)
        local variable = param.vm:getVariable(source)
        if not variable then
            return false
        end
        if not variable.classes or variable.types then
            return false
        end
        -- 只对子类（有 extends）生效；根类定义显示所有字段
        for _, cls in ipairs(variable.classes) do
            if cls.extends and #cls.extends > 0 then
                return true
            end
        end
        return false
    end

    if snode.kind == 'type' then
        ---@cast snode Node.Type
        local value = snode.value
        if value.kind == 'table' then
            ---@cast value Node.Table
            if snode:isClassLike() then
                local viewOptions = isTypeHover(param.source)  and { hidePrivate = true }
                               or   isClassHover(param.source) and { hideOnlyPrivate = true }
                               or   nil
                pushWithPrefix('(class) ' .. snode:view() .. ' ', value, viewOptions)
                return
            end
        end
        return
    end

    snode:each('table', function (node)
        ---@cast node Node.Table
        if node == snode then
            return
        end

        pushWithPrefix('', node)
    end)
end)
