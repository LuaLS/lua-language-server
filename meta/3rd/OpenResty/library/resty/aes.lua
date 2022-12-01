---@meta

local aes={}

---@alias resty.aes.cipher.name
---| '"ecb"'
---| '"cbc"'
---| '"cfb1"'
---| '"cfb128"'
---| '"cfb8"'
---| '"ctr"
---| '"gcm"'
---| '"ofb"'

---@alias resty.aes.cipher.size '128'|'192'|'256'

---@class resty.aes.cipher : table
---@field size   resty.aes.cipher.size
---@field cipher resty.aes.cipher.name
---@field method userdata

---@param  size    resty.aes.cipher.size # cipher size (default `128`)
---@param  cipher? resty.aes.cipher.name # cipher name (default `"cbc"`)
---@return resty.aes.cipher?
function aes.cipher(size, cipher) end

---@class resty.aes.hash_table : table
---@field iv      string
---@field method? fun(key:string):string

---@class resty.aes.hash_cdata : userdata

---@type table<string, resty.aes.hash_cdata>
aes.hash = {}
aes.hash.sha1={}
aes.hash.md5={}
aes.hash.sha224={}
aes.hash.sha512={}
aes.hash.sha256={}
aes.hash.sha384={}

---@alias resty.aes.hash resty.aes.hash_cdata|resty.aes.hash_table

---@param key             string               encryption key
---@param salt?           string               if provided, must be exactly 8 characters in length
---@param cipher?         resty.aes.cipher     (default is 128 CBC)
---@param hash?           resty.aes.hash       (default is md5)
---@param hash_rounds?    number               (default: `1`)
---@param iv_len?         number
---@param enable_padding? boolean              (default: `true`)
---
---@return resty.aes?
---@return string? error
function aes:new(key, salt, cipher, hash, hash_rounds, iv_len, enable_padding) end

---@class resty.aes : table
local aes_ctx = {}

--- Decrypt a string
---
---@param  s       string
---@param  tag?    string
---@return string? decrypted
---@return string? error
function aes_ctx:decrypt(s, tag) end


--- Encrypt a string.
---
---@param  s       string
---@return string? encrypted
---@return string? error
function aes_ctx:encrypt(s) end

return aes