---@meta
---@class crypt
local crypt = {}

---计算 hash
---@param key any
---@return string
function crypt.hashkey(key)
end
---生成一个8位的 key
---@return string
function crypt.randomkey()
end
---des 加密
---@param key number
---@param data string
---@param padding number | nil @对齐模式 默认 iso7816_4
---@return string
function crypt.desencode(key, data, padding)
end
---desc 解密
---@param key number
---@param data string
---@param padding number | nil @对齐模式 默认 iso7816_4
---@return string
function crypt.desdecode(key, data, padding)
end
---hex 编码
---@param data string
---@return string
function crypt.hexencode(data)
end
---hex 解码
---@param data string
---@return string
function crypt.hexdecode(data)
end
---hmac 签名
---@param challenge string @挑战消息
---@param secret string @密钥
---@return string
function crypt.hmac64(challenge, secret)
end
---hmac md5签名
---@param msg string
---@param secret string
---@return string
function crypt.hmac64_md5(msg, secret)
end
---dh交换
---@param key string
---@return string
function crypt.dhexchange(key)
end
---密钥计算
---@param dhkey string @经过 exchange 后的密钥
---@param selfkey string @原始
function crypt.dhsecret(dhkey, selfkey)
end
---base64编码
---@param msg string
---@return string
function crypt.base64encode(msg)
end
---base64解码
---@param msg string
---@return string
function crypt.base64decode(msg)
end
---sha1
---@param msg string
---@return string
function crypt.sha1(msg)
end
function crypt.hmac_sha1()
end
---hmac hash
---@param key string
---@param msg string
---@return string
function crypt.hmac_hash(key, msg)
end
---xor 字符串
---@param s1 string
---@param key string
---@return lightuserdata
function crypt.xor_str(s1, key)
end

return crypt
