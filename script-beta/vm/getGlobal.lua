local vm = require 'vm.vm'

function vm.getGlobal(source)
    vm.getGlobals(source)
    return vm.cache.getGlobal[source]
end
