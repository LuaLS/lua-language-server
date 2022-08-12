---@meta

---@class cc.Skybox :cc.Node
local Skybox={ }
cc.Skybox=Skybox




---*  reload sky box after GLESContext reconstructed.
---@return self
function Skybox:reload () end
---* initialize with texture path
---@param positive_x string
---@param negative_x string
---@param positive_y string
---@param negative_y string
---@param positive_z string
---@param negative_z string
---@return boolean
function Skybox:init (positive_x,negative_x,positive_y,negative_y,positive_z,negative_z) end
---* texture getter and setter
---@param e cc.TextureCub
---@return self
function Skybox:setTexture (e) end
---@overload fun(string:string,string:string,string:string,string:string,string:string,string:string):self
---@overload fun():self
---@param positive_x string
---@param negative_x string
---@param positive_y string
---@param negative_y string
---@param positive_z string
---@param negative_z string
---@return self
function Skybox:create (positive_x,negative_x,positive_y,negative_y,positive_z,negative_z) end
---*  draw Skybox object 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function Skybox:draw (renderer,transform,flags) end
---* init Skybox.
---@return boolean
function Skybox:init () end
---* Constructor.
---@return self
function Skybox:Skybox () end