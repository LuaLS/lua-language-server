local vm    = require 'vm.vm'

vm.librarySourceCache = setmetatable({}, { __mode = 'kv'})

function vm.librarySource(lib)
    if not vm.librarySourceCache[lib] then
        vm.librarySourceCache[lib] = {
            type    = 'library',
            library = lib,
        }
    end
    return vm.librarySourceCache[lib]
end
