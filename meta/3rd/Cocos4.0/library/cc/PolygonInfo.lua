---@meta

---@class cc.PolygonInfo 
local PolygonInfo={ }
cc.PolygonInfo=PolygonInfo




---* 
---@return string
function PolygonInfo:getFilename () end
---* get sum of all triangle area size<br>
---* return sum of all triangle area size
---@return float
function PolygonInfo:getArea () end
---* 
---@return rect_table
function PolygonInfo:getRect () end
---* 
---@param filename string
---@return self
function PolygonInfo:setFilename (filename) end
---* set the data to be a pointer to a number of Quads<br>
---* the member verts will not be released when this PolygonInfo destructs<br>
---* as the verts memory are managed by other objects<br>
---* param quad  a pointer to the V3F_C4B_T2F_Quad quads
---@param quads cc.V3F_C4B_T2F_Quad
---@param numberOfQuads int
---@return self
function PolygonInfo:setQuads (quads,numberOfQuads) end
---* get vertex count<br>
---* return number of vertices
---@return unsigned_int
function PolygonInfo:getVertCount () end
---* get triangles count<br>
---* return number of triangles
---@return unsigned_int
function PolygonInfo:getTrianglesCount () end
---* set the data to be a pointer to a quad<br>
---* the member verts will not be released when this PolygonInfo destructs<br>
---* as the verts memory are managed by other objects<br>
---* param quad  a pointer to the V3F_C4B_T2F_Quad object
---@param quad cc.V3F_C4B_T2F_Quad
---@return self
function PolygonInfo:setQuad (quad) end
---* set the data to be a pointer to a triangles<br>
---* the member verts will not be released when this PolygonInfo destructs<br>
---* as the verts memory are managed by other objects<br>
---* param triangles  a pointer to the TrianglesCommand::Triangles object
---@param triangles cc.TrianglesCommand.Triangles
---@return self
function PolygonInfo:setTriangles (triangles) end
---* 
---@param rect rect_table
---@return self
function PolygonInfo:setRect (rect) end
---* / @name Creators/ @{<br>
---* Creates an empty Polygon info<br>
---* memberof PolygonInfo<br>
---* return PolygonInfo object
---@return self
function PolygonInfo:PolygonInfo () end