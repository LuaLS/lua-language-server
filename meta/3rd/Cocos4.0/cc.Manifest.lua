---@meta

---@class cc.Manifest :cc.Ref
local Manifest={ }
cc.Manifest=Manifest




---*  @brief Gets remote manifest file url.
---@return string
function Manifest:getManifestFileUrl () end
---*  @brief Check whether the version informations have been fully loaded
---@return boolean
function Manifest:isVersionLoaded () end
---*  @brief Check whether the manifest have been fully loaded
---@return boolean
function Manifest:isLoaded () end
---*  @brief Gets remote package url.
---@return string
function Manifest:getPackageUrl () end
---*  @brief Gets manifest version.
---@return string
function Manifest:getVersion () end
---*  @brief Gets remote version file url.
---@return string
function Manifest:getVersionFileUrl () end
---*  @brief Get the search paths list related to the Manifest.
---@return array_table
function Manifest:getSearchPaths () end