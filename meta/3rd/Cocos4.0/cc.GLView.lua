---@meta

---@class cc.GLView :cc.Ref
local GLView={ }
cc.GLView=GLView




---* Set the frame size of EGL view.<br>
---* param width The width of the fram size.<br>
---* param height The height of the fram size.
---@param width float
---@param height float
---@return self
function GLView:setFrameSize (width,height) end
---* Get the opengl view port rectangle.<br>
---* return Return the opengl view port rectangle.
---@return rect_table
function GLView:getViewPortRect () end
---* Get scale factor of the vertical direction.<br>
---* return Scale factor of the vertical direction.
---@return float
function GLView:getScaleY () end
---*  Only works on ios platform. Set Content Scale of the Factor. 
---@param t floa
---@return boolean
function GLView:setContentScaleFactor (t) end
---*  Only works on ios platform. Get Content Scale of the Factor. 
---@return float
function GLView:getContentScaleFactor () end
---*  Open or close IME keyboard , subclass must implement this method. <br>
---* param open Open or close IME keyboard.
---@param open boolean
---@return self
function GLView:setIMEKeyboardState (open) end
---* Gets safe area rectangle
---@return rect_table
function GLView:getSafeAreaRect () end
---* Set Scissor rectangle with points.<br>
---* param x Set the points of x.<br>
---* param y Set the points of y.<br>
---* param w Set the width of  the view port<br>
---* param h Set the Height of the view port.
---@param x float
---@param y float
---@param w float
---@param h float
---@return self
function GLView:setScissorInPoints (x,y,w,h) end
---*  Get the view name.<br>
---* return The view name.
---@return string
function GLView:getViewName () end
---*  Get whether opengl render system is ready, subclass must implement this method. 
---@return boolean
function GLView:isOpenGLReady () end
---* Hide or Show the mouse cursor if there is one.<br>
---* param isVisible Hide or Show the mouse cursor if there is one.
---@param l boo
---@return self
function GLView:setCursorVisible (l) end
---* Get the frame size of EGL view.<br>
---* In general, it returns the screen size since the EGL view is a fullscreen view.<br>
---* return The frame size of EGL view.
---@return size_table
function GLView:getFrameSize () end
---*  Set default window icon (implemented for windows and linux).<br>
---* On windows it will use icon from .exe file (if included).<br>
---* On linux it will use default window icon.
---@return self
function GLView:setDefaultIcon () end
---* Get scale factor of the horizontal direction.<br>
---* return Scale factor of the horizontal direction.
---@return float
function GLView:getScaleX () end
---* Get the visible origin point of opengl viewport.<br>
---* return The visible origin point of opengl viewport.
---@return vec2_table
function GLView:getVisibleOrigin () end
---*  Set zoom factor for frame. This methods are for<br>
---* debugging big resolution (e.g.new ipad) app on desktop.<br>
---* param zoomFactor The zoom factor for frame.
---@param t floa
---@return self
function GLView:setFrameZoomFactor (t) end
---*  Get zoom factor for frame. This methods are for<br>
---* debugging big resolution (e.g.new ipad) app on desktop.<br>
---* return The zoom factor for frame.
---@return float
function GLView:getFrameZoomFactor () end
---*  Get design resolution size.<br>
---* Default resolution size is the same as 'getFrameSize'.<br>
---* return The design resolution size.
---@return size_table
function GLView:getDesignResolutionSize () end
---@overload fun(string0:array_table):self
---@overload fun(string:string):self
---@param filename string
---@return self
function GLView:setIcon (filename) end
---*  When the window is closed, it will return false if the platforms is Ios or Android.<br>
---* If the platforms is windows or Mac,it will return true.<br>
---* return In ios and android it will return false,if in windows or Mac it will return true.
---@return boolean
function GLView:windowShouldClose () end
---*  Exchanges the front and back buffers, subclass must implement this method. 
---@return self
function GLView:swapBuffers () end
---* Set the design resolution size.<br>
---* param width Design resolution width.<br>
---* param height Design resolution height.<br>
---* param resolutionPolicy The resolution policy desired, you may choose:<br>
---* [1] EXACT_FIT Fill screen by stretch-to-fit: if the design resolution ratio of width to height is different from the screen resolution ratio, your game view will be stretched.<br>
---* [2] NO_BORDER Full screen without black border: if the design resolution ratio of width to height is different from the screen resolution ratio, two areas of your game view will be cut.<br>
---* [3] SHOW_ALL  Full screen with black border: if the design resolution ratio of width to height is different from the screen resolution ratio, two black borders will be shown.
---@param width float
---@param height float
---@param resolutionPolicy int
---@return self
function GLView:setDesignResolutionSize (width,height,resolutionPolicy) end
---*  Returns the current Resolution policy.<br>
---* return The current Resolution policy.
---@return int
function GLView:getResolutionPolicy () end
---*  Force destroying EGL view, subclass must implement this method. <br>
---* lua endToLua
---@return self
function GLView:endToLua () end
---*  Returns whether or not the view is in Retina Display mode.<br>
---* return Returns whether or not the view is in Retina Display mode.
---@return boolean
function GLView:isRetinaDisplay () end
---* Renders a Scene with a Renderer<br>
---* This method is called directly by the Director
---@param scene cc.Scene
---@param renderer cc.Renderer
---@return self
function GLView:renderScene (scene,renderer) end
---* Set opengl view port rectangle with points.<br>
---* param x Set the points of x.<br>
---* param y Set the points of y.<br>
---* param w Set the width of  the view port<br>
---* param h Set the Height of the view port.
---@param x float
---@param y float
---@param w float
---@param h float
---@return self
function GLView:setViewPortInPoints (x,y,w,h) end
---* Get the current scissor rectangle.<br>
---* return The current scissor rectangle.
---@return rect_table
function GLView:getScissorRect () end
---*  Get retina factor.<br>
---* return The retina factor.
---@return int
function GLView:getRetinaFactor () end
---*  Set the view name. <br>
---* param viewname A string will be set to the view as name.
---@param viewname string
---@return self
function GLView:setViewName (viewname) end
---* Get the visible rectangle of opengl viewport.<br>
---* return The visible rectangle of opengl viewport.
---@return rect_table
function GLView:getVisibleRect () end
---* Get the visible area size of opengl viewport.<br>
---* return The visible area size of opengl viewport.
---@return size_table
function GLView:getVisibleSize () end
---* Get whether GL_SCISSOR_TEST is enable.<br>
---* return Whether GL_SCISSOR_TEST is enable.
---@return boolean
function GLView:isScissorEnabled () end
---*  Polls the events. 
---@return self
function GLView:pollEvents () end
---*  Static method and member so that we can modify it on all platforms before create OpenGL context. <br>
---* param glContextAttrs The OpenGL context attrs.
---@param glContextAttrs GLContextAttrs
---@return self
function GLView:setGLContextAttrs (glContextAttrs) end
---*  Return the OpenGL context attrs. <br>
---* return Return the OpenGL context attrs.
---@return GLContextAttrs
function GLView:getGLContextAttrs () end