---@meta

---@class cc.AssetsManager :cc.Node
local AssetsManager={ }
cc.AssetsManager=AssetsManager




---* 
---@param storagePath char
---@return self
function AssetsManager:setStoragePath (storagePath) end
---* 
---@param packageUrl char
---@return self
function AssetsManager:setPackageUrl (packageUrl) end
---* 
---@return boolean
function AssetsManager:checkUpdate () end
---* 
---@return char
function AssetsManager:getStoragePath () end
---* 
---@return self
function AssetsManager:update () end
---*  @brief Sets connection time out in seconds
---@param timeout unsigned_int
---@return self
function AssetsManager:setConnectionTimeout (timeout) end
---* 
---@param versionFileUrl char
---@return self
function AssetsManager:setVersionFileUrl (versionFileUrl) end
---* 
---@return char
function AssetsManager:getPackageUrl () end
---*  @brief Gets connection time out in seconds
---@return unsigned_int
function AssetsManager:getConnectionTimeout () end
---* 
---@return string
function AssetsManager:getVersion () end
---* 
---@return char
function AssetsManager:getVersionFileUrl () end
---* 
---@return self
function AssetsManager:deleteVersion () end
---* 
---@param packageUrl char
---@param versionFileUrl char
---@param storagePath char
---@param errorCallback function
---@param progressCallback function
---@param successCallback function
---@return self
function AssetsManager:create (packageUrl,versionFileUrl,storagePath,errorCallback,progressCallback,successCallback) end
---* 
---@return self
function AssetsManager:AssetsManager () end