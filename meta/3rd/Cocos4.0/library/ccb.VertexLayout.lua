---@meta

---@class ccb.VertexLayout 
local VertexLayout={ }
ccb.VertexLayout=VertexLayout




---* Get vertex step function. Default value is VERTEX.<br>
---* return Vertex step function.<br>
---* note Used in metal.
---@return int
function VertexLayout:getVertexStepMode () end
---* Check if vertex layout has been set.
---@return boolean
function VertexLayout:isValid () end
---* Set stride of vertices.<br>
---* param stride Specifies the distance between the data of two vertices, in bytes.
---@param stride unsigned_int
---@return cc.backend.VertexLayout
function VertexLayout:setLayout (stride) end
---* Set attribute values to name.<br>
---* param name Specifies the attribute name.<br>
---* param index Specifies the index of the generic vertex attribute to be modified.<br>
---* param format Specifies how the vertex attribute data is laid out in memory.<br>
---* param offset Specifies the byte offset to the first component of the first generic vertex attribute.<br>
---* param needToBeNormallized Specifies whether fixed-point data values should be normalized (true) or converted directly as fixed-point values (false) when they are accessed.
---@param name string
---@param index unsigned_int
---@param format int
---@param offset unsigned_int
---@param needToBeNormallized boolean
---@return cc.backend.VertexLayout
function VertexLayout:setAttribute (name,index,format,offset,needToBeNormallized) end
---* Get the distance between the data of two vertices, in bytes.<br>
---* return The distance between the data of two vertices, in bytes.
---@return unsigned_int
function VertexLayout:getStride () end
---* 
---@return cc.backend.VertexLayout
function VertexLayout:VertexLayout () end