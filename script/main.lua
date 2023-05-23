local class = require 'class'

Class = class.declare
New   = class.new

---@class ls
ls = {}

ls.gc      = require 'gc'
ls.timer   = require 'timer'
ls.inspect = require 'inspect'
ls.util    = require 'utility'
ls.fsu     = require 'fs-utility'
ls.furi    = require 'file-uri'
