---@meta

---@class cc.Director 
local Director={ }
cc.Director=Director




---*  Pauses the running scene.<br>
---* The running scene will be _drawed_ but all scheduled timers will be paused.<br>
---* While paused, the draw rate will be 4 FPS to reduce CPU consumption.
---@return self
function Director:pause () end
---*  Sets the EventDispatcher associated with this director.<br>
---* since v3.0<br>
---* js NA
---@param dispatcher cc.EventDispatcher
---@return self
function Director:setEventDispatcher (dispatcher) end
---*  The size in pixels of the surface. It could be different than the screen size.<br>
---* High-res devices might have a higher surface size than the screen size.<br>
---* Only available when compiled using SDK >= 4.0.<br>
---* since v0.99.4
---@param scaleFactor float
---@return self
function Director:setContentScaleFactor (scaleFactor) end
---* 
---@return float
function Director:getDeltaTime () end
---* Gets content scale factor.<br>
---* see Director::setContentScaleFactor()
---@return float
function Director:getContentScaleFactor () end
---*  Returns the size of the OpenGL view in pixels. 
---@return size_table
function Director:getWinSizeInPixels () end
---* Returns safe area rectangle of the OpenGL view in points.
---@return rect_table
function Director:getSafeAreaRect () end
---*  Sets the OpenGL default values.<br>
---* It will enable alpha blending, disable depth test.<br>
---* js NA
---@return self
function Director:setGLDefaultValues () end
---*  Sets the ActionManager associated with this director.<br>
---* since v2.0
---@param actionManager cc.ActionManager
---@return self
function Director:setActionManager (actionManager) end
---* Pops out all scenes from the stack until the root scene in the queue.<br>
---* This scene will replace the running one.<br>
---* Internally it will call `popToSceneStackLevel(1)`.
---@return self
function Director:popToRootScene () end
---* Adds a matrix to the top of specified type of matrix stack.<br>
---* param type Matrix type.<br>
---* param mat The matrix that to be added.<br>
---* js NA
---@param type int
---@param mat mat4_table
---@return self
function Director:loadMatrix (type,mat) end
---*  This object will be visited after the main scene is visited.<br>
---* This object MUST implement the "visit" function.<br>
---* Useful to hook a notification object, like Notifications (http:github.com/manucorporat/CCNotifications)<br>
---* since v0.99.5
---@return cc.Node
function Director:getNotificationNode () end
---*  Returns the size of the OpenGL view in points. 
---@return size_table
function Director:getWinSize () end
---* 
---@return cc.TextureCache
function Director:getTextureCache () end
---*  Whether or not the replaced scene will receive the cleanup message.<br>
---* If the new scene is pushed, then the old scene won't receive the "cleanup" message.<br>
---* If the new scene replaces the old one, the it will receive the "cleanup" message.<br>
---* since v0.99.0
---@return boolean
function Director:isSendCleanupToScene () end
---*  Returns visible origin coordinate of the OpenGL view in points. 
---@return vec2_table
function Director:getVisibleOrigin () end
---@overload fun(float:float):self
---@overload fun():self
---@param dt float
---@return self
function Director:mainLoop (dt) end
---* Gets Frame Rate.<br>
---* js NA
---@return float
function Director:getFrameRate () end
---*  Get seconds per frame. 
---@return float
function Director:getSecondsPerFrame () end
---* Clear all types of matrix stack, and add identity matrix to these matrix stacks.<br>
---* js NA
---@return self
function Director:resetMatrixStack () end
---* Converts an OpenGL coordinate to a screen coordinate.<br>
---* Useful to convert node points to window points for calls such as glScissor.
---@param point vec2_table
---@return vec2_table
function Director:convertToUI (point) end
---* Clones a specified type matrix and put it to the top of specified type of matrix stack.<br>
---* js NA
---@param type int
---@return self
function Director:pushMatrix (type) end
---*  Sets the default values based on the Configuration info. 
---@return self
function Director:setDefaultValues () end
---* 
---@return boolean
function Director:init () end
---*  Sets the Scheduler associated with this director.<br>
---* since v2.0
---@param scheduler cc.Scheduler
---@return self
function Director:setScheduler (scheduler) end
---* Gets the top matrix of specified type of matrix stack.<br>
---* js NA
---@param type int
---@return mat4_table
function Director:getMatrix (type) end
---* returns whether or not the Director is in a valid state
---@return boolean
function Director:isValid () end
---*  The main loop is triggered again.<br>
---* Call this function only if [stopAnimation] was called earlier.<br>
---* warning Don't call this function to start the main loop. To run the main loop call runWithScene.
---@return self
function Director:startAnimation () end
---*  Returns the Renderer associated with this director.<br>
---* since v3.0
---@return cc.Renderer
function Director:getRenderer () end
---* Get the GLView.<br>
---* lua NA
---@return cc.GLView
function Director:getOpenGLView () end
---*  Gets current running Scene. Director can only run one Scene at a time. 
---@return cc.Scene
function Director:getRunningScene () end
---*  Sets the glViewport.
---@return self
function Director:setViewport () end
---*  Stops the animation. Nothing will be drawn. The main loop won't be triggered anymore.<br>
---* If you don't want to pause your animation call [pause] instead.
---@return self
function Director:stopAnimation () end
---*  Pops out all scenes from the stack until it reaches `level`.<br>
---* If level is 0, it will end the director.<br>
---* If level is 1, it will pop all scenes until it reaches to root scene.<br>
---* If level is <= than the current stack level, it won't do anything.
---@param level int
---@return self
function Director:popToSceneStackLevel (level) end
---*  Resumes the paused scene.<br>
---* The scheduled timers will be activated again.<br>
---* The "delta time" will be 0 (as if the game wasn't paused).
---@return self
function Director:resume () end
---*  Whether or not `_nextDeltaTimeZero` is set to 0. 
---@return boolean
function Director:isNextDeltaTimeZero () end
---*  Sets clear values for the color buffers,<br>
---* value range of each element is [0.0, 1.0].<br>
---* js NA
---@param clearColor color4f_table
---@return self
function Director:setClearColor (clearColor) end
---*  Ends the execution, releases the running scene.<br>
---* lua endToLua
---@return self
function Director:endToLua () end
---* Sets the GLView. <br>
---* lua NA
---@param openGLView cc.GLView
---@return self
function Director:setOpenGLView (openGLView) end
---* Converts a screen coordinate to an OpenGL coordinate.<br>
---* Useful to convert (multi) touch coordinates to the current layout (portrait or landscape).
---@param point vec2_table
---@return vec2_table
function Director:convertToGL (point) end
---*  Removes all cocos2d cached data.<br>
---* It will purge the TextureCache, SpriteFrameCache, LabelBMFont cache<br>
---* since v0.99.3
---@return self
function Director:purgeCachedData () end
---*  How many frames were called since the director started 
---@return unsigned_int
function Director:getTotalFrames () end
---* Enters the Director's main loop with the given Scene.<br>
---* Call it to run only your FIRST scene.<br>
---* Don't call it if there is already a running scene.<br>
---* It will call pushScene: and then it will call startAnimation<br>
---* js NA
---@param scene cc.Scene
---@return self
function Director:runWithScene (scene) end
---* Sets the notification node.<br>
---* see Director::getNotificationNode()
---@param node cc.Node
---@return self
function Director:setNotificationNode (node) end
---*  Draw the scene.<br>
---* This method is called every frame. Don't call it manually.
---@return self
function Director:drawScene () end
---* 
---@return self
function Director:restart () end
---* Pops out a scene from the stack.<br>
---* This scene will replace the running one.<br>
---* The running scene will be deleted. If there are no more scenes in the stack the execution is terminated.<br>
---* ONLY call it if there is a running scene.
---@return self
function Director:popScene () end
---*  Adds an identity matrix to the top of specified type of matrix stack.<br>
---* js NA
---@param type int
---@return self
function Director:loadIdentityMatrix (type) end
---*  Whether or not displaying the FPS on the bottom-left corner of the screen. 
---@return boolean
function Director:isDisplayStats () end
---*  Sets OpenGL projection. 
---@param projection int
---@return self
function Director:setProjection (projection) end
---*  Returns the Console associated with this director.<br>
---* since v3.0<br>
---* js NA
---@return cc.Console
function Director:getConsole () end
---* Multiplies a matrix to the top of specified type of matrix stack.<br>
---* param type Matrix type.<br>
---* param mat The matrix that to be multiplied.<br>
---* js NA
---@param type int
---@param mat mat4_table
---@return self
function Director:multiplyMatrix (type,mat) end
---* Gets the distance between camera and near clipping frame.<br>
---* It is correct for default camera that near clipping frame is same as the screen.
---@return float
function Director:getZEye () end
---* Sets the delta time between current frame and next frame is 0.<br>
---* This value will be used in Schedule, and will affect all functions that are using frame delta time, such as Actions.<br>
---* This value will take effect only one time.
---@param nextDeltaTimeZero boolean
---@return self
function Director:setNextDeltaTimeZero (nextDeltaTimeZero) end
---*  Pops the top matrix of the specified type of matrix stack.<br>
---* js NA
---@param type int
---@return self
function Director:popMatrix (type) end
---* Returns visible size of the OpenGL view in points.<br>
---* The value is equal to `Director::getWinSize()` if don't invoke `GLView::setDesignResolutionSize()`.
---@return size_table
function Director:getVisibleSize () end
---*  Gets the Scheduler associated with this director.<br>
---* since v2.0
---@return cc.Scheduler
function Director:getScheduler () end
---* Suspends the execution of the running scene, pushing it on the stack of suspended scenes.<br>
---* The new scene will be executed.<br>
---* Try to avoid big stacks of pushed scenes to reduce memory allocation. <br>
---* ONLY call it if there is a running scene.
---@param scene cc.Scene
---@return self
function Director:pushScene (scene) end
---*  Gets the FPS value. 
---@return float
function Director:getAnimationInterval () end
---*  Whether or not the Director is paused. 
---@return boolean
function Director:isPaused () end
---*  Display the FPS on the bottom-left corner of the screen. 
---@param displayStats boolean
---@return self
function Director:setDisplayStats (displayStats) end
---*  Gets the EventDispatcher associated with this director.<br>
---* since v3.0<br>
---* js NA
---@return cc.EventDispatcher
function Director:getEventDispatcher () end
---*  Replaces the running scene with a new one. The running scene is terminated.<br>
---* ONLY call it if there is a running scene.<br>
---* js NA
---@param scene cc.Scene
---@return self
function Director:replaceScene (scene) end
---*  Sets the FPS value. FPS = 1/interval. 
---@param interval float
---@return self
function Director:setAnimationInterval (interval) end
---*  Gets the ActionManager associated with this director.<br>
---* since v2.0
---@return cc.ActionManager
function Director:getActionManager () end
---* Returns a shared instance of the director. <br>
---* js _getInstance
---@return self
function Director:getInstance () end