files   = {
  'resty/redis%.lua',
  'lib/resty/.*%.lua',
  'src/resty/.*%.lua',
  'lib/ngx.*/.*%.lua',
  'src/ngx.*/.*%.lua',
}

words = {
  'resty%.%w+',
  'ngx%.%w+',
}

config = {
    ["Lua.runtime.version"] = "LuaJIT",
    ["Lua.diagnostics.globals"] = {
        "ngx",
    },
}
