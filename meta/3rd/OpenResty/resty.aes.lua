---@meta
resty_aes={}
function resty_aes.cipher() end
resty_aes.hash={}
resty_aes.hash.sha1={}
resty_aes.hash.md5={}
resty_aes.hash.sha224={}
resty_aes.hash.sha512={}
resty_aes.hash.sha256={}
resty_aes.hash.sha384={}
function resty_aes.new(self, key, salt, _cipher, _hash, hash_rounds) end
function resty_aes.decrypt(self, s) end
resty_aes._VERSION="0.11"
function resty_aes.encrypt(self, s) end
return resty_aes