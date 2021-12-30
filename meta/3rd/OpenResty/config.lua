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

configs = {
    {
        key    = 'Lua.runtime.version',
        action = 'set',
        value  = 'LuaJIT',
    },
    {
        key    = 'Lua.diagnostics.globals',
        action = 'add',
        value  = 'ngx',
    },
}
