local ctypes = { TESTMODE = false }

local inspect = require("inspect")
local utility = require 'utility'
local util = require 'plugins.ffi.c-parser.util'
local typed = require("plugins.ffi.c-parser.typed")

local equal_declarations

local add_type = typed("TypeList, string, CType -> ()", function (lst, name, typ)
    lst[name] = typ
    table.insert(lst, { name = name, type = typ })
end)

-- Compare two lists of declarations
local equal_lists = typed("array, array -> boolean", function (l1, l2)
    if #l1 ~= #l2 then
        return false
    end
    for i, p1 in ipairs(l1) do
        local p2 = l2[i]
        if not equal_declarations(p1, p2) then
            return false
        end
    end
    return true
end)

equal_declarations = function (t1, t2)
    if type(t1) == "string" or type(t2) == "nil" then
        return t1 == t2
    end
    if not equal_declarations(t1.type, t2.type) then
        return false
    end
    --    if not equal_lists(t1.name, t2.name) then
    --        return false
    --    end
    if t1.type == "struct" then
        if t1.name ~= t2.name then
            return false
        end
    elseif t1.type == "function" then
        if not equal_declarations(t1.ret.type, t2.ret.type) then
            return false
        end
        if not equal_lists(t1.params, t2.params) then
            return false
        end
        if t1.vararg ~= t2.vararg then
            return false
        end
    end
    return true
end

local function is_modifier(str)
    return str == "*" or str == "restrict" or str == "const"
end

local function extract_modifiers(ret_pointer, items)
    while is_modifier(items[1]) do
        table.insert(ret_pointer, table.remove(items, 1))
    end
end

local function get_name(name_src)
    local ret_pointer = {}
    if name_src == nil then
        return false, "could not find a name: " .. inspect(name_src), nil
    end
    local name
    local indices = {}
    if type(name_src) == "string" then
        if is_modifier(name_src) then
            table.insert(ret_pointer, name_src)
        else
            name = name_src
        end
    else
        name_src = name_src.declarator or name_src
        if type(name_src[1]) == "table" then
            extract_modifiers(ret_pointer, name_src[1])
        else
            extract_modifiers(ret_pointer, name_src)
        end
        for _, part in ipairs(name_src) do
            if part.idx then
                table.insert(indices, part.idx)
            end
        end
        name = name_src.name
    end
    return true, name, ret_pointer, next(indices) and indices
end

local get_type
local get_fields

local convert_value = typed("TypeList, table -> CType?, string?", function (lst, src)
    local name = nil
    local ret_pointer = {}
    local idxs = nil

    if type(src.id) == "table" or type(src.ids) == "table" then
        src.id = util.expandSingle(src.id)
        src.ids = util.expandSingle(src.ids)
        -- FIXME multiple ids, e.g.: int *x, y, *z;
        local ok
---@diagnostic disable-next-line: cast-local-type
        ok, name, ret_pointer, idxs = get_name(src.id or src.ids)
        if not ok then
            return nil, name
        end
    end

    local typ, err = get_type(lst, src, ret_pointer)
    if not typ then
        return nil, err
    end

    return typed.table("CType", {
        name = name,
        type = typ,
        idxs = idxs,
    }), nil
end)

local function convert_fields(lst, field_src, fields)
    if field_src.ids then
        for i, id in ipairs(field_src.ids) do
            id.type = utility.deepCopy(field_src.type)
            if id.type and id[1] then
                for i, v in ipairs(id[1]) do
                    table.insert(id.type, v)
                end
                if id[1].idx then
                    id.isarray = true
                end
                id[1] = nil
            end
            table.insert(fields, id)
        end
        return true
    end
end

-- Interpret field data from `field_src` and add it to `fields`.
local function add_to_fields(lst, field_src, fields)
    if type(field_src) == "table" and not field_src.ids then
        assert(field_src.type.type == "union")
        local subfields, err = get_fields(lst, field_src.type.fields)
        if not subfields then
            return nil, err
        end
        for _, subfield in ipairs(subfields) do
            table.insert(fields, subfield)
        end
        return true
    end

    if convert_fields(lst, field_src, fields) then
        return true
    end
    local field, err = convert_value(lst, field_src)
    if not field then
        return nil, err
    end
end

get_fields = function (lst, fields_src)
    local fields = {}
    for _, field_src in ipairs(fields_src) do
        local ok, err = add_to_fields(lst, field_src, fields)
        if not ok then
            return false, err
        end
    end
    return fields
end

local function get_enum_items(_, values)
    local items = {}
    for _, v in ipairs(values) do
        -- TODO store enum actual values
        table.insert(items, { name = v.id, value = v.value })
    end
    return items
end

local function getAnonymousID(t)
    local v = tostring(t)
    local _, e = v:find("table: 0x", 0, true)
    return v:sub(e + 1)
end

local get_composite_type = typed("TypeList, string?, string, array, string, function -> CType, string",
    function (lst, specid, spectype, parts, partsfield, get_parts)
        local name = specid
        local key = spectype .. "@" .. (name or ctypes.TESTMODE and 'anonymous' or getAnonymousID(parts))

        if not lst[key] then
            -- Forward declaration
            lst[key] = typed.table("CType", {
                type = spectype,
                name = name,
            })
        end

        if parts then
            local err
            parts, err = get_parts(lst, parts)
            if not parts then
                return nil, err
            end
        end

        local typ = typed.table("CType", {
            type = spectype,
            name = name,
            [partsfield] = parts,
        })

        if lst[key] then
            if typ[partsfield] and lst[key][partsfield] and not equal_declarations(typ, lst[key]) then
                return nil, "redeclaration for " .. key
            end
        end
        add_type(lst, key, typ)

        return typ, key
    end)

local function get_structunion(lst, spec)
    if spec.fields and not spec.fields[1] then
        spec.fields = { spec.fields }
    end
    return get_composite_type(lst, spec.id, spec.type, spec.fields, "fields", get_fields)
end

local function get_enum(lst, spec)
    if spec.values and not spec.values[1] then
        spec.values = { spec.values }
    end
    local typ, key = get_composite_type(lst, spec.id, spec.type, spec.values, "values", get_enum_items)
    if typ.values then
        for _, value in ipairs(typ.values) do
            add_type(lst, value.name, typ)
        end
    end
    return typ, key
end

local function refer(lst, item, get_fn)
    if item.id and not item.fields then
        local key = item.type .. "@" .. item.id
        local su_typ = lst[key]
        if not su_typ then
            return {
                type = item.type,
                name = { item.id },
            }
        end
        return su_typ
    else
        local typ, key = get_fn(lst, item)
        if not typ then
            return nil, key
        end
        return typ
    end
end

local calculate

local function binop(val, fn)
    local e1, e2 = calculate(val[1]), calculate(val[2])
    if type(e1) == "number" and type(e2) == "number" then
        return fn(e1, e2)
    else
        return { e1, e2, op = val.op }
    end
end

calculate = function (val)
    if type(val) == "string" then
        return tonumber(val)
    end
    if val.op == "+" then
        return binop(val, function (a, b) return a + b end)
    elseif val.op == "-" then
        return binop(val, function (a, b) return a - b end)
    elseif val.op == "*" then
        return binop(val, function (a, b) return a * b end)
    elseif val.op == "/" then
        return binop(val, function (a, b) return a / b end)
    else
        return val
    end
end

local base_types = {
    ["char"] = true,
    ["const"] = true,
    ["bool"] = true,
    ["double"] = true,
    ["float"] = true,
    ["int"] = true,
    ["long"] = true,
    ["short"] = true,
    ["signed"] = true,
    ["__signed"] = true,
    ["__signed__"] = true,
    ["unsigned"] = true,
    ["void"] = true,
    ["volatile"] = true,
    ["ptrdiff_t"] = true,
    ["size_t"] = true,
    ["ssize_t"] = true,
    ["wchar_t"] = true,
    ["int8_t"] = true,
    ["int16_t"] = true,
    ["int32_t"] = true,
    ["int64_t"] = true,
    ["uint8_t"] = true,
    ["uint16_t"] = true,
    ["uint32_t"] = true,
    ["uint64_t"] = true,
    ["intptr_t"] = true,
    ["uintptr_t"] = true,
    ["__int8"] = true,
    ["__int16"] = true,
    ["__int32"] = true,
    ["__int64"] = true,
    ["_Bool"] = true,
    ["__ptr32"] = true,
    ["__ptr64"] = true,
    ["_Complex"] = true,
    ["complex"] = true,
    ["__complex"] = true,
    ["__complex__"] = true,
    ["*"] = true,
}

local qualifiers = {
    ["extern"] = true,
    ["static"] = true,
    ["typedef"] = true,
    ["restrict"] = true,
    ["inline"] = true,
    ["register"] = true,
}

get_type = function (lst, spec, ret_pointer)
    local tarr = {}
    if type(spec.type) == "string" then
        spec.type = { spec.type }
    end
    if spec.type and not spec.type[1] then
        spec.type = { spec.type }
    end
    for _, part in ipairs(spec.type or spec) do
        if qualifiers[part] then
            -- skip
        elseif base_types[part] then
            table.insert(tarr, part)
        elseif lst[part] and lst[part].type == "typedef" then
            table.insert(tarr, part)
        elseif type(part) == "table" and part.type == "struct" or part.type == "union" then
            local su_typ, err = refer(lst, part, get_structunion)
            if not su_typ then
                return nil, err or "failed to refer struct"
            end
            table.insert(tarr, su_typ)
        elseif type(part) == "table" and part.type == "enum" then
            local en_typ, err = refer(lst, part, get_enum)
            if not en_typ then
                return nil, err or "failed to refer enum"
            end
            table.insert(tarr, en_typ)
        else
            return nil, "FIXME unknown type " .. inspect(spec)
        end
    end
    if #ret_pointer > 0 then
        for _, item in ipairs(ret_pointer) do
            if type(item) == "table" and item.idx then
                table.insert(tarr, { idx = calculate(item.idx) })
            else
                table.insert(tarr, item)
            end
        end
    end
    return tarr, nil
end

local function is_void(param)
    return #param.type == 1 and param.type[1] == "void"
end

local get_params = typed("TypeList, array -> array, boolean", function (lst, params_src)
    local params = {}
    local vararg = false

    assert(not params_src.param)

    for _, param_src in ipairs(params_src) do
        if param_src == "..." then
            vararg = true
        else
            local param, err = convert_value(lst, param_src.param)
            if not param then
                return nil, err
            end
            if not is_void(param) then
                table.insert(params, param)
            end
        end
    end
    return params, vararg
end)

local register_many = function (register_item_fn, lst, ids, spec)
    for _, id in ipairs(ids) do
        local ok, err = register_item_fn(lst, id, spec)
        if not ok then
            return false, err
        end
    end
    return true, nil
end

local register_decl_item = function (lst, id, spec)
    local ok, name, ret_pointer, idxs = get_name(id.decl)
    if not ok then
        return false, name
    end
    assert(name)
    local ret_type, err = get_type(lst, spec, ret_pointer)
    if not ret_type then
        return false, err
    end
    local typ
    if id.decl.params then
        local params, vararg = get_params(lst, id.decl.params)
        if not params then
            return false, vararg
        end
        typ = typed.table("CType", {
            type = "function",
            name = name,
            idxs = idxs,
            ret = {
                type = ret_type,
            },
            params = params,
            vararg = vararg,
        })
    else
        typ = typed.table("CType", {
            type = ret_type,
            name = name,
            idxs = idxs,
        })
    end

    if lst[name] then
        if not equal_declarations(lst[name], typ) then
            return false,
                "inconsistent declaration for " .. name .. " - " .. inspect(lst[name]) .. " VERSUS " .. inspect(typ)
        end
    end
    add_type(lst, name, typ)

    return true, nil
end

local register_decls = function (lst, ids, spec)
    return register_many(register_decl_item, lst, ids, spec)
end

-- Convert an table produced by an `extern inline` declaration
-- into one compatible with `register_decl`.
local function register_function(lst, item)
    local id = {
        decl = {
            name = item.func.name,
            params = item.func.params,
        }
    }
    return register_decl_item(lst, id, item.spec)
end

local function register_static_function(lst, item)
    return true
end

local register_typedef_item = typed("TypeList, table, table -> boolean, string?", function (lst, id, spec)
    local ok, name, ret_pointer = get_name(id.decl)
    if not ok then
        return false, name or "failed"
    end
    local def, err = get_type(lst, spec, ret_pointer)
    if not def then
        return false, err or "failed"
    end
    local typ = typed.table("CType", {
        type = "typedef",
        name = name,
        def = def,
    })

    if lst[name] then
        if not equal_declarations(lst[name], typ) then
            return false,
                "inconsistent declaration for " .. name .. " - " .. inspect(lst[name]) .. " VERSUS " .. inspect(typ)
        end
    end
    add_type(lst, name, typ)

    return true, nil
end)

local register_typedefs = function (lst, item)
    return register_many(register_typedef_item, lst, item.ids, item.spec)
end

local function register_structunion(lst, item)
    return get_structunion(lst, item.spec)
end

local function register_enum(lst, item)
    return get_enum(lst, item.spec)
end

local function to_set(array)
    local set = {}
    for _, v in ipairs(array) do
        set[v] = true
    end
    return set
end

ctypes.register_types = typed("{Decl} -> TypeList?, string?", function (parsed)
    local lst = typed.table("TypeList", {})
    for _, item in ipairs(parsed) do
        typed.check(item.spec, "table")
        local spec_set = to_set(item.spec)
        if spec_set.extern and item.ids then
            local ok, err = register_decls(lst, item.ids, item.spec)
            if not ok then
                return nil, err or "failed extern"
            end
        elseif spec_set.extern and item.func then
            local ok, err = register_function(lst, item)
            if not ok then
                return nil, err or "failed extern"
            end
        elseif spec_set.static and item.func then
            local ok, err = register_static_function(lst, item)
            if not ok then
                return nil, err or "failed static function"
            end
        elseif spec_set.typedef then
            local ok, err = register_typedefs(lst, item)
            if not ok then
                return nil, err or "failed typedef"
            end
        else
            local expandSingle <const> = {
                ["struct"] = true,
                ["union"] = true,
                ["enum"] = true,
            }
            local spec = util.expandSingle(item.spec)
            if expandSingle[spec.type] then
                item.spec = spec
            end
            if item.spec.type == "struct" or item.spec.type == "union" then
                local ok, err = register_structunion(lst, item)
                if not ok then
                    return nil, err or "failed struct/union"
                end
            elseif item.spec.type == "enum" then
                local ok, err = register_enum(lst, item)
                if not ok then
                    return nil, err or "failed enum"
                end
            elseif not item.ids then
                -- forward declaration (e.g. "struct foo;")
            elseif item.ids then
                local ok, err = register_decls(lst, item.ids, item.spec)
                if not ok then
                    return nil, err or "failed declaration"
                end
            else
                return nil, "FIXME Uncategorized declaration: " .. inspect(item)
            end
        end
    end
    return lst, nil
end)

return ctypes
