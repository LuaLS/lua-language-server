local vm = require 'vm.vm'

---@alias vm.object parser.object | vm.generic

require 'vm.compiler'
require 'vm.value'
require 'vm.node'
require 'vm.def'
require 'vm.ref'
require 'vm.field'
require 'vm.doc'
require 'vm.type'
require 'vm.library'
require 'vm.tracer'
require 'vm.infer'
require 'vm.generic'
require 'vm.sign'
require 'vm.variable'
require 'vm.global'
require 'vm.function'
require 'vm.operator'
require 'vm.visible'
require 'vm.precompile'

return vm
