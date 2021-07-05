---@meta

---@class cc.NavMesh :cc.Ref
local NavMesh={ }
cc.NavMesh=NavMesh




---*  remove a obstacle from navmesh. 
---@param obstacle cc.NavMeshObstacle
---@return self
function NavMesh:removeNavMeshObstacle (obstacle) end
---*  remove a agent from navmesh. 
---@param agent cc.NavMeshAgent
---@return self
function NavMesh:removeNavMeshAgent (agent) end
---*  update navmesh. 
---@param dt float
---@return self
function NavMesh:update (dt) end
---*  Check enabled debug draw. 
---@return boolean
function NavMesh:isDebugDrawEnabled () end
---*  add a agent to navmesh. 
---@param agent cc.NavMeshAgent
---@return self
function NavMesh:addNavMeshAgent (agent) end
---*  add a obstacle to navmesh. 
---@param obstacle cc.NavMeshObstacle
---@return self
function NavMesh:addNavMeshObstacle (obstacle) end
---*  Enable debug draw or disable. 
---@param enable boolean
---@return self
function NavMesh:setDebugDrawEnable (enable) end
---*  Internal method, the updater of debug drawing, need called each frame. 
---@param renderer cc.Renderer
---@return self
function NavMesh:debugDraw (renderer) end
---* Create navmesh<br>
---* param navFilePath The NavMesh File path.<br>
---* param geomFilePath The geometry File Path,include offmesh information,etc.
---@param navFilePath string
---@param geomFilePath string
---@return self
function NavMesh:create (navFilePath,geomFilePath) end
---* 
---@return self
function NavMesh:NavMesh () end