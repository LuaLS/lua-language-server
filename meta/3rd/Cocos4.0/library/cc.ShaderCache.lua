---@meta

---@class cc.ShaderCache :cc.Ref
local ShaderCache={ }
cc.ShaderCache=ShaderCache




---* Remove all unused shaders.
---@return cc.backend.ShaderCache
function ShaderCache:removeUnusedShader () end
---*  purges the cache. It releases the retained instance. 
---@return cc.backend.ShaderCache
function ShaderCache:destroyInstance () end
---* Create a vertex shader module and add it to cache.<br>
---* If it is created before, then just return the cached shader module.<br>
---* param shaderSource The source code of the shader.
---@param shaderSource string
---@return cc.backend.ShaderModule
function ShaderCache:newVertexShaderModule (shaderSource) end
---* Create a fragment shader module.<br>
---* If it is created before, then just return the cached shader module.<br>
---* param shaderSource The source code of the shader.
---@param shaderSource string
---@return cc.backend.ShaderModule
function ShaderCache:newFragmentShaderModule (shaderSource) end
---*  returns the shared instance 
---@return cc.backend.ShaderCache
function ShaderCache:getInstance () end