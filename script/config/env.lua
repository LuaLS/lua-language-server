-- Handles loading environment arguments

---ENV args are defined here.
---- `name` is the ENV arg name
---- `key` is the value used to index `_G` for setting the argument
---@type { name: string, key: string }[]
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
        key = "CONFIGPATH"
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
        key = "FORCE_ACCEPT_WORKSPACE"
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
        key = "METAPATH"
    }
}

for _, var in ipairs(vars) do
    local value = os.getenv(var.name)
    if value then
        _G[var.key] = value
    end
end
