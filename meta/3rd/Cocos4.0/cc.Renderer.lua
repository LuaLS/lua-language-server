---@meta

---@class cc.Renderer 
local Renderer={ }
cc.Renderer=Renderer




---* Get winding mode.<br>
---* return The winding mode.
---@return int
function Renderer:getWinding () end
---* 
---@return int
function Renderer:getDrawnVertices () end
---*  Renders into the GLView all the queued `RenderCommand` objects 
---@return self
function Renderer:render () end
---*  Creates a render queue and returns its Id 
---@return int
function Renderer:createRenderQueue () end
---* Get whether stencil test is enabled or not.<br>
---* return true if stencil test is enabled, false otherwise.
---@return boolean
function Renderer:getStencilTest () end
---* Get the render target flag.<br>
---* return The render target flag.
---@return int
function Renderer:getRenderTargetFlag () end
---* Get the clear flag.<br>
---* return The clear flag.
---@return int
function Renderer:getClearFlag () end
---* Get stencil reference value set by `setStencilCompareFunction`. <br>
---* return Stencil reference value.<br>
---* see `setStencilCompareFunction(backend::CompareFunction func, unsigned int ref, unsigned int readMask)`
---@return unsigned_int
function Renderer:getStencilReferenceValue () end
---* Get stencil attachment.<br>
---* return Stencil attachment.
---@return cc.Texture2D
function Renderer:getStencilAttachment () end
---* Fixed-function state<br>
---* param x The x coordinate of the upper-left corner of the viewport.<br>
---* param y The y coordinate of the upper-left corner of the viewport.<br>
---* param w The width of the viewport, in pixels.<br>
---* param h The height of the viewport, in pixels.
---@param x int
---@param y int
---@param w unsigned_int
---@param h unsigned_int
---@return self
function Renderer:setViewPort (x,y,w,h) end
---* Get the stencil readMask.<br>
---* return Stencil read mask.<br>
---* see `setStencilCompareFunction(backend::CompareFunction func, unsigned int ref, unsigned int readMask)`
---@return unsigned_int
function Renderer:getStencilReadMask () end
---* Get depth clear value.<br>
---* return Depth clear value. 
---@return float
function Renderer:getClearDepth () end
---* Set front and back function and reference value for stencil testing.<br>
---* param func Specifies the stencil test function.<br>
---* param ref Specifies the reference value for the stencil test. <br>
---* readMask Specifies a mask that is ANDed with both the reference value and the stored stencil value when the test is done. 
---@param func int
---@param ref unsigned_int
---@param readMask unsigned_int
---@return self
function Renderer:setStencilCompareFunction (func,ref,readMask) end
---* / Get viewport.
---@return cc.Viewport
function Renderer:getViewport () end
---* Get the index when the stencil buffer is cleared. <br>
---* return The index used when the stencil buffer is cleared. 
---@return unsigned_int
function Renderer:getClearStencil () end
---* Enable/disable stencil test. <br>
---* param value true means enable stencil test, otherwise false.
---@param value boolean
---@return self
function Renderer:setStencilTest (value) end
---* / Get the action to take when the stencil test fails. 
---@return int
function Renderer:getStencilFailureOperation () end
---* Get color attachment.<br>
---* return Color attachment.
---@return cc.Texture2D
function Renderer:getColorAttachment () end
---@overload fun(cc.RenderCommand:cc.RenderCommand,int:int):self
---@overload fun(cc.RenderCommand:cc.RenderCommand):self
---@param command cc.RenderCommand
---@param renderQueueID int
---@return self
function Renderer:addCommand (command,renderQueueID) end
---* Enable/disable depth test. <br>
---* param value true means enable depth test, otherwise false.
---@param value boolean
---@return self
function Renderer:setDepthTest (value) end
---* Fixed-function state<br>
---* param x, y Specifies the lower left corner of the scissor box<br>
---* param wdith Specifies the width of the scissor box<br>
---* param height Specifies the height of the scissor box
---@param x float
---@param y float
---@param width float
---@param height float
---@return self
function Renderer:setScissorRect (x,y,width,height) end
---* Get whether depth test state is enabled or disabled.<br>
---* return true if depth test is enabled, otherwise false.
---@return boolean
function Renderer:getDepthTest () end
---* 
---@return self
function Renderer:init () end
---* Enable/disable to update depth buffer. <br>
---* param value true means enable writing into the depth buffer, otherwise false.
---@param value boolean
---@return self
function Renderer:setDepthWrite (value) end
---* / Get the stencil action when the stencil test passes, but the depth test fails. 
---@return int
function Renderer:getStencilPassDepthFailureOperation () end
---* Fixed-function state<br>
---* param mode Controls if primitives are culled when front facing, back facing, or not culled at all.
---@param mode int
---@return self
function Renderer:setCullMode (mode) end
---*  Pops a group from the render queue 
---@return self
function Renderer:popGroup () end
---*  Pushes a group into the render queue 
---@param renderQueueID int
---@return self
function Renderer:pushGroup (renderQueueID) end
---* 
---@return cc.ScissorRect
function Renderer:getScissorRect () end
---* 
---@return boolean
function Renderer:getScissorTest () end
---* Get the stencil write mask.<br>
---* return Stencil write mask.<br>
---* see `setStencilWriteMask(unsigned int mask)`
---@return unsigned_int
function Renderer:getStencilWriteMask () end
---* 
---@param number int
---@return self
function Renderer:addDrawnBatches (number) end
---*  returns whether or not a rectangle is visible or not 
---@param transform mat4_table
---@param size size_table
---@return boolean
function Renderer:checkVisibility (transform,size) end
---* Set front and back stencil test actions.<br>
---* param stencilFailureOp Specifies the action to take when the stencil test fails. <br>
---* param depthFailureOp Specifies the stencil action when the stencil test passes, but the depth test fails. <br>
---* param stencilDepthPassOp Specifies the stencil action when both the stencil test and the depth test pass, or when the stencil test passes and either there is no depth buffer or depth testing is not enabled. 
---@param stencilFailureOp int
---@param depthFailureOp int
---@param stencilDepthPassOp int
---@return self
function Renderer:setStencilOperation (stencilFailureOp,depthFailureOp,stencilDepthPassOp) end
---* Get whether writing to depth buffer is enabled or not.<br>
---* return true if enable writing into the depth buffer, false otherwise.
---@return boolean
function Renderer:getDepthWrite () end
---* Get cull mode.<br>
---* return The cull mode.
---@return int
function Renderer:getCullMode () end
---* / Get the stencil test function.
---@return int
function Renderer:getStencilCompareFunction () end
---* Get color clear value.<br>
---* return Color clear value.
---@return color4f_table
function Renderer:getClearColor () end
---* Set depth compare function.<br>
---* param func Specifies the value used for depth buffer comparisons.
---@param func int
---@return self
function Renderer:setDepthCompareFunction (func) end
---* Control the front and back writing of individual bits in the stencil planes.<br>
---* param mask Specifies a bit mask to enable and disable writing of individual bits in the stencil planes.
---@param mask unsigned_int
---@return self
function Renderer:setStencilWriteMask (mask) end
---* / Get the stencil action when both the stencil test and the depth test pass, or when the stencil test passes and either there is no depth buffer or depth testing is not enabled. 
---@return int
function Renderer:getStencilDepthPassOperation () end
---* Enable/disable scissor test. <br>
---* param enabled true if enable scissor test, false otherwise.
---@param enabled boolean
---@return self
function Renderer:setScissorTest (enabled) end
---* Fixed-function state<br>
---* param winding The winding order of front-facing primitives.
---@param winding int
---@return self
function Renderer:setWinding (winding) end
---* Set clear values for each attachment.<br>
---* flags Flags to indicate which attachment clear value to be modified.<br>
---* color The clear color value.<br>
---* depth The clear depth value.<br>
---* stencil The clear stencil value.
---@param flags int
---@param color color4f_table
---@param depth float
---@param stencil unsigned_int
---@param globalOrder float
---@return self
function Renderer:clear (flags,color,depth,stencil,globalOrder) end
---* Set render targets. If not set, will use default render targets. It will effect all commands.<br>
---* flags Flags to indicate which attachment to be replaced.<br>
---* colorAttachment The value to replace color attachment, only one color attachment supported now.<br>
---* depthAttachment The value to repalce depth attachment.<br>
---* stencilAttachment The value to replace stencil attachment. Depth attachment and stencil attachment<br>
---* can be the same value.
---@param flags int
---@param colorAttachment cc.Texture2D
---@param depthAttachment cc.Texture2D
---@param stencilAttachment cc.Texture2D
---@return self
function Renderer:setRenderTarget (flags,colorAttachment,depthAttachment,stencilAttachment) end
---* Get depth attachment.<br>
---* return Depth attachment.
---@return cc.Texture2D
function Renderer:getDepthAttachment () end
---* 
---@param number int
---@return self
function Renderer:addDrawnVertices (number) end
---*  Cleans all `RenderCommand`s in the queue 
---@return self
function Renderer:clean () end
---* 
---@return int
function Renderer:getDrawnBatches () end
---* 
---@return self
function Renderer:clearDrawStats () end
---* Get depth compare function.<br>
---* return Depth compare function.
---@return int
function Renderer:getDepthCompareFunction () end
---* Constructor.
---@return self
function Renderer:Renderer () end