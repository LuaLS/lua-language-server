-- Handles loading environment arguments

---Convert a string to boolean
---@param v string
local function strToBool(v)
    return v == "true"
end

---ENV args are defined here.
---- `name` is the ENV arg name
---- `key` is the value used to index `_G` for setting the argument
---- `converter` if present, will be used to convert the string value into another type
---@type { name: string, key: string, converter: fun(value: string): any }[]
local vars = {
    {
        name = "LLS_CHECK_LEVEL",
        key = "CHECKLEVEL",
    },
    {
        name = "LLS_CHECK_PATH",
        key = "CHECK",
    },
    {
        name = "LLS_CONFIG_PATH",
        key = "CONFIGPATH",
    },
    {
        name = "LLS_DOC_OUT_PATH",
        key = "DOC_OUT_PATH",
    },
    {
        name = "LLS_DOC_PATH",
        key = "DOC",
    },
    {
        name = "LLS_FORCE_ACCEPT_WORKSPACE",
        key = "FORCE_ACCEPT_WORKSPACE",
        converter = strToBool,
    },
    {
        name = "LLS_LOCALE",
        key = "LOCALE",
    },
    {
        name = "LLS_LOG_LEVEL",
        key = "LOGLEVEL",
    },
    {
        name = "LLS_LOG_PATH",
        key = "LOGPATH",
    },
    {
        name = "LLS_META_PATH",
        key = "METAPATH",
    },
}

for _, var in ipairs(vars) do
    local value = os.getenv(var.name)
    if value then
        if var.converter then
            value = var.converter(value)
        end

        _G[var.key] = value
    end
end
