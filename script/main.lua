local class = require 'class'

Class = class.declare
New   = class.new

---@class LS
LS = {}

LS.gc      = require 'gc'
LS.timer   = require 'timer'
LS.inspect = require 'inspect'
LS.util    = require 'utility'
LS.fsu     = require 'fs-utility'
LS.furi    = require 'file-uri'
