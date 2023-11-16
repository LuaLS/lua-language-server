---@meta tools.json

---@class Json.Null

---@alias Json.Type Json.Null | boolean | string | number | table<string, Json.Type> | Json.Type[]

---@class Json
---@field null Json.Null
---@field supportSparseArray boolean
local M = {}

---@param v Json.Type
---@return string
function M.encode(v) end

---@param str string
---@return Json.Type
function M.decode(str) end

---@param str string
---@return Json.Type
function M.decode_jsonc(str) end

---@return table
function M.createEmptyObject() end

---@param t table
---@return boolean
function M.isObject(t) end

---@class Json.BeatifyOption
local beautifyOption = {
    newline = "\n",
    indent = "    ",
    depth = 0,
}

---@param v Json.Type
---@param option Json.BeatifyOption
---@return string
function M.beautify(v, option) end

---@alias Json.Patch Json.Patch.Add | Json.Patch.Remove | Json.Patch.Replace

---@alias Json.Patch.Add { op: 'add', path: string, value: Json.Type }
---@alias Json.Patch.Remove { op:'remove', path: string }
---@alias Json.Patch.Replace { op:'replace', path: string, value: Json.Type }

---@param str string
---@param patch Json.Patch
---@param option Json.BeatifyOption
function M.edit(str, patch, option) end

return M
