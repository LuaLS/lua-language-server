---@meta

---@class cc.Physics3DShape :cc.Ref
local Physics3DShape={ }
cc.Physics3DShape=Physics3DShape




---* 
---@return btCollisionShape
function Physics3DShape:getbtShape () end
---* 
---@param radius float
---@return boolean
function Physics3DShape:initSphere (radius) end
---* 
---@param ext vec3_table
---@return boolean
function Physics3DShape:initBox (ext) end
---* 
---@param radius float
---@param height float
---@return boolean
function Physics3DShape:initCapsule (radius,height) end
---* 
---@param radius float
---@param height float
---@return boolean
function Physics3DShape:initCylinder (radius,height) end
---* get shape type
---@return int
function Physics3DShape:getShapeType () end
---* create box shape<br>
---* param extent The extent of sphere.
---@param extent vec3_table
---@return self
function Physics3DShape:createBox (extent) end
---* create cylinder shape<br>
---* param radius The radius of cylinder.<br>
---* param height The height.
---@param radius float
---@param height float
---@return self
function Physics3DShape:createCylinder (radius,height) end
---* create convex hull<br>
---* param points The vertices of convex hull<br>
---* param numPoints The number of vertices.
---@param points vec3_table
---@param numPoints int
---@return self
function Physics3DShape:createConvexHull (points,numPoints) end
---* create capsule shape<br>
---* param radius The radius of capsule.<br>
---* param height The height (cylinder part).
---@param radius float
---@param height float
---@return self
function Physics3DShape:createCapsule (radius,height) end
---* create sphere shape<br>
---* param radius The radius of sphere.
---@param radius float
---@return self
function Physics3DShape:createSphere (radius) end
---* 
---@return self
function Physics3DShape:Physics3DShape () end