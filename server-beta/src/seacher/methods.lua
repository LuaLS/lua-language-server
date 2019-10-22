local methods = {}

methods['local']      = require 'seacher.local'
methods['getlocal']   = require 'seacher.getlocal'
methods['setlocal']   = methods['getlocal']
methods['getglobal']  = require 'seacher.getglobal'
methods['setglobal']  = methods['getglobal']
methods['getfield']   = require 'seacher.getfield'
methods['setfield']   = methods['getfield']
methods['tablefield'] = require 'seacher.tablefield'
methods['getmethod']  = methods['getfield']
methods['setmethod']  = methods['getfield']
methods['getindex']   = methods['getfield']
methods['setindex']   = methods['getfield']
methods['field']      = require 'seacher.field'
methods['method']     = require 'seacher.method'
methods['index']      = require 'seacher.index'
methods['number']     = require 'seacher.number'
methods['boolean']    = require 'seacher.boolean'
methods['string']     = require 'seacher.string'
methods['table']      = require 'seacher.table'
methods['select']     = require 'seacher.select'
methods['goto']       = require 'seacher.goto'
methods['label']      = require 'seacher.label'

return methods
