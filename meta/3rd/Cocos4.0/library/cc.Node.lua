---@meta

---@class cc.Node :cc.Ref
local Node={ }
cc.Node=Node




---@overload fun(cc.Node:cc.Node,int:int):self
---@overload fun(cc.Node:cc.Node):self
---@overload fun(cc.Node:cc.Node,int:int,string2:int):self
---@overload fun(cc.Node:cc.Node,int:int,string:string):self
---@param child cc.Node
---@param localZOrder int
---@param name string
---@return self
function Node:addChild (child,localZOrder,name) end
---@overload fun(string0:cc.Component):self
---@overload fun(string:string):self
---@param name string
---@return boolean
function Node:removeComponent (name) end
---* 
---@param physicsBody cc.PhysicsBody
---@return self
function Node:setPhysicsBody (physicsBody) end
---* Get the callback of event ExitTransitionDidStart.<br>
---* return std::function<void()>
---@return function
function Node:getOnExitTransitionDidStartCallback () end
---* Gets the description string. It makes debugging easier.<br>
---* return A string<br>
---* js NA<br>
---* lua NA
---@return string
function Node:getDescription () end
---* Sets the Y rotation (angle) of the node in degrees which performs a vertical rotational skew.<br>
---* The difference between `setRotationalSkew()` and `setSkew()` is that the first one simulate Flash's skew functionality,<br>
---* while the second one uses the real skew function.<br>
---* 0 is the default rotation angle.<br>
---* Positive values rotate node clockwise, and negative values for anti-clockwise.<br>
---* param rotationY    The Y rotation in degrees.<br>
---* warning The physics body doesn't support this.<br>
---* js setRotationY
---@param rotationY float
---@return self
function Node:setRotationSkewY (rotationY) end
---* If you want the opacity affect the color property, then set to true.<br>
---* param value A boolean value.
---@param value boolean
---@return self
function Node:setOpacityModifyRGB (value) end
---* Change node's cascadeOpacity property.<br>
---* param cascadeOpacityEnabled True to enable cascadeOpacity, false otherwise.
---@param cascadeOpacityEnabled boolean
---@return self
function Node:setCascadeOpacityEnabled (cascadeOpacityEnabled) end
---@overload fun():self
---@overload fun():self
---@return array_table
function Node:getChildren () end
---* Set the callback of event onExit.<br>
---* param callback A std::function<void()> callback.
---@param callback function
---@return self
function Node:setOnExitCallback (callback) end
---* Sets the ActionManager object that is used by all actions.<br>
---* warning If you set a new ActionManager, then previously created actions will be removed.<br>
---* param actionManager     A ActionManager object that is used by all actions.
---@param actionManager cc.ActionManager
---@return self
function Node:setActionManager (actionManager) end
---* Converts a local Vec2 to world space coordinates.The result is in Points.<br>
---* treating the returned/received node point as anchor relative.<br>
---* param nodePoint A given coordinate.<br>
---* return A point in world space coordinates, anchor relative.
---@param nodePoint vec2_table
---@return vec2_table
function Node:convertToWorldSpaceAR (nodePoint) end
---* Gets whether the anchor point will be (0,0) when you position this node.<br>
---* see `setIgnoreAnchorPointForPosition(bool)`<br>
---* return true if the anchor point will be (0,0) when you position this node.
---@return boolean
function Node:isIgnoreAnchorPointForPosition () end
---* Gets a child from the container with its name.<br>
---* param name   An identifier to find the child node.<br>
---* return a Node object whose name equals to the input parameter.<br>
---* since v3.2
---@param name string
---@return self
function Node:getChildByName (name) end
---* Update the displayed opacity of node with it's parent opacity;<br>
---* param parentOpacity The opacity of parent node.
---@param parentOpacity unsigned_char
---@return self
function Node:updateDisplayedOpacity (parentOpacity) end
---* 
---@return boolean
function Node:init () end
---* get & set camera mask, the node is visible by the camera whose camera flag & node's camera mask is true
---@return unsigned short
function Node:getCameraMask () end
---* Sets the rotation (angle) of the node in degrees.<br>
---* 0 is the default rotation angle.<br>
---* Positive values rotate node clockwise, and negative values for anti-clockwise.<br>
---* param rotation     The rotation of the node in degrees.
---@param rotation float
---@return self
function Node:setRotation (rotation) end
---* Changes the scale factor on Z axis of this node<br>
---* The Default value is 1.0 if you haven't changed it before.<br>
---* param scaleZ   The scale factor on Z axis.<br>
---* warning The physics body doesn't support this.
---@param scaleZ float
---@return self
function Node:setScaleZ (scaleZ) end
---* Sets the scale (y) of the node.<br>
---* It is a scaling factor that multiplies the height of the node and its children.<br>
---* param scaleY   The scale factor on Y axis.<br>
---* warning The physics body doesn't support this.
---@param scaleY float
---@return self
function Node:setScaleY (scaleY) end
---* Sets the scale (x) of the node.<br>
---* It is a scaling factor that multiplies the width of the node and its children.<br>
---* param scaleX   The scale factor on X axis.<br>
---* warning The physics body doesn't support this.
---@param scaleX float
---@return self
function Node:setScaleX (scaleX) end
---* Sets the X rotation (angle) of the node in degrees which performs a horizontal rotational skew.<br>
---* The difference between `setRotationalSkew()` and `setSkew()` is that the first one simulate Flash's skew functionality,<br>
---* while the second one uses the real skew function.<br>
---* 0 is the default rotation angle.<br>
---* Positive values rotate node clockwise, and negative values for anti-clockwise.<br>
---* param rotationX    The X rotation in degrees which performs a horizontal rotational skew.<br>
---* warning The physics body doesn't support this.<br>
---* js setRotationX
---@param rotationX float
---@return self
function Node:setRotationSkewX (rotationX) end
---* Removes all components
---@return self
function Node:removeAllComponents () end
---* 
---@param z int
---@return self
function Node:_setLocalZOrder (z) end
---* Modify the camera mask for current node.<br>
---* If applyChildren is true, then it will modify the camera mask of its children recursively.<br>
---* param mask A unsigned short bit for mask.<br>
---* param applyChildren A boolean value to determine whether the mask bit should apply to its children or not.
---@param mask unsigned short
---@param applyChildren boolean
---@return self
function Node:setCameraMask (mask,applyChildren) end
---* Returns a tag that is used to identify the node easily.<br>
---* return An integer that identifies the node.<br>
---* Please use `getTag()` instead.
---@return int
function Node:getTag () end
---* 
---@return cc.AffineTransform
function Node:getNodeToWorldAffineTransform () end
---* Returns the world affine transform matrix. The matrix is in Pixels.<br>
---* return transformation matrix, in pixels.
---@return mat4_table
function Node:getNodeToWorldTransform () end
---* Returns the position (X,Y,Z) in its parent's coordinate system.<br>
---* return The position (X, Y, and Z) in its parent's coordinate system.<br>
---* js NA
---@return vec3_table
function Node:getPosition3D () end
---* Removes a child from the container. It will also cleanup all running actions depending on the cleanup parameter.<br>
---* param child     The child node which will be removed.<br>
---* param cleanup   True if all running actions and callbacks on the child node will be cleanup, false otherwise.
---@param child cc.Node
---@param cleanup boolean
---@return self
function Node:removeChild (child,cleanup) end
---* Converts a Vec2 to world space coordinates. The result is in Points.<br>
---* param nodePoint A given coordinate.<br>
---* return A point in world space coordinates.
---@param nodePoint vec2_table
---@return vec2_table
function Node:convertToWorldSpace (nodePoint) end
---*  Returns the Scene that contains the Node.<br>
---* It returns `nullptr` if the node doesn't belong to any Scene.<br>
---* This function recursively calls parent->getScene() until parent is a Scene object. The results are not cached. It is that the user caches the results in case this functions is being used inside a loop.<br>
---* return The Scene that contains the node.
---@return cc.Scene
function Node:getScene () end
---*  Get the event dispatcher of scene.<br>
---* return The event dispatcher of scene.
---@return cc.EventDispatcher
function Node:getEventDispatcher () end
---* Changes the X skew angle of the node in degrees.<br>
---* The difference between `setRotationalSkew()` and `setSkew()` is that the first one simulate Flash's skew functionality<br>
---* while the second one uses the real skew function.<br>
---* This angle describes the shear distortion in the X direction.<br>
---* Thus, it is the angle between the Y coordinate and the left edge of the shape<br>
---* The default skewX angle is 0. Positive values distort the node in a CW direction.<br>
---* param skewX The X skew angle of the node in degrees.<br>
---* warning The physics body doesn't support this.
---@param skewX float
---@return self
function Node:setSkewX (skewX) end
---* Changes the Y skew angle of the node in degrees.<br>
---* The difference between `setRotationalSkew()` and `setSkew()` is that the first one simulate Flash's skew functionality<br>
---* while the second one uses the real skew function.<br>
---* This angle describes the shear distortion in the Y direction.<br>
---* Thus, it is the angle between the X coordinate and the bottom edge of the shape.<br>
---* The default skewY angle is 0. Positive values distort the node in a CCW direction.<br>
---* param skewY    The Y skew angle of the node in degrees.<br>
---* warning The physics body doesn't support this.
---@param skewY float
---@return self
function Node:setSkewY (skewY) end
---* Set the callback of event onEnter.<br>
---* param callback A std::function<void()> callback.
---@param callback function
---@return self
function Node:setOnEnterCallback (callback) end
---* Removes all actions from the running action list by its flags.<br>
---* param flags   A flag field that removes actions based on bitwise AND.
---@param flags unsigned_int
---@return self
function Node:stopActionsByFlags (flags) end
---* 
---@param position vec2_table
---@return self
function Node:setNormalizedPosition (position) end
---* convenience methods which take a Touch instead of Vec2.<br>
---* param touch A given touch.<br>
---* return A point in world space coordinates.
---@param touch cc.Touch
---@return vec2_table
function Node:convertTouchToNodeSpace (touch) end
---@overload fun(boolean:boolean):self
---@overload fun():self
---@param cleanup boolean
---@return self
function Node:removeAllChildrenWithCleanup (cleanup) end
---* Set the callback of event EnterTransitionDidFinish.<br>
---* param callback A std::function<void()> callback.
---@param callback function
---@return self
function Node:setOnEnterTransitionDidFinishCallback (callback) end
---* 
---@param programState cc.backend.ProgramState
---@return self
function Node:setProgramState (programState) end
---@overload fun(cc.Node:cc.Node):self
---@overload fun():self
---@param ancestor cc.Node
---@return cc.AffineTransform
function Node:getNodeToParentAffineTransform (ancestor) end
---* Whether cascadeOpacity is enabled or not.<br>
---* return A boolean value.
---@return boolean
function Node:isCascadeOpacityEnabled () end
---* Sets the parent node.<br>
---* param parent    A pointer to the parent node.
---@param parent cc.Node
---@return self
function Node:setParent (parent) end
---*  Returns a string that is used to identify the node.<br>
---* return A string that identifies the node.<br>
---* since v3.2
---@return string
function Node:getName () end
---* Resumes all scheduled selectors, actions and event listeners.<br>
---* This method is called internally by onEnter.
---@return self
function Node:resume () end
---* Returns the rotation (X,Y,Z) in degrees.<br>
---* return The rotation of the node in 3d.<br>
---* js NA
---@return vec3_table
function Node:getRotation3D () end
---@overload fun(cc.Node:cc.Node):self
---@overload fun():self
---@param ancestor cc.Node
---@return mat4_table
function Node:getNodeToParentTransform (ancestor) end
---* converts a Touch (world coordinates) into a local coordinate. This method is AR (Anchor Relative).<br>
---* param touch A given touch.<br>
---* return A point in world space coordinates, anchor relative.
---@param touch cc.Touch
---@return vec2_table
function Node:convertTouchToNodeSpaceAR (touch) end
---* Converts a Vec2 to node (local) space coordinates. The result is in Points.<br>
---* param worldPoint A given coordinate.<br>
---* return A point in node (local) space coordinates.
---@param worldPoint vec2_table
---@return vec2_table
function Node:convertToNodeSpace (worldPoint) end
---*  Sets the position (x,y) using values between 0 and 1.<br>
---* The positions in pixels is calculated like the following:<br>
---* code pseudo code<br>
---* void setNormalizedPosition(Vec2 pos) {<br>
---* Size s = getParent()->getContentSize();<br>
---* _position = pos * s;<br>
---* }<br>
---* endcode<br>
---* param position The normalized position (x,y) of the node, using value between 0 and 1.
---@param position vec2_table
---@return self
function Node:setPositionNormalized (position) end
---* Pauses all scheduled selectors, actions and event listeners.<br>
---* This method is called internally by onExit.
---@return self
function Node:pause () end
---* If node opacity will modify the RGB color value, then you should override this method and return true.<br>
---* return A boolean value, true indicates that opacity will modify color; false otherwise.
---@return boolean
function Node:isOpacityModifyRGB () end
---@overload fun(float:float,float:float):self
---@overload fun(float0:vec2_table):self
---@param x float
---@param y float
---@return self
function Node:setPosition (x,y) end
---* Removes an action from the running action list by its tag.<br>
---* param tag   A tag that indicates the action to be removed.
---@param tag int
---@return self
function Node:stopActionByTag (tag) end
---* Reorders a child according to a new z value.<br>
---* param child     An already added child node. It MUST be already added.<br>
---* param localZOrder Z order for drawing priority. Please refer to setLocalZOrder(int).
---@param child cc.Node
---@param localZOrder int
---@return self
function Node:reorderChild (child,localZOrder) end
---* Sets the 'z' coordinate in the position. It is the OpenGL Z vertex value.<br>
---* The OpenGL depth buffer and depth testing are disabled by default. You need to turn them on.<br>
---* In order to use this property correctly.<br>
---* `setPositionZ()` also sets the `setGlobalZValue()` with the positionZ as value.<br>
---* see `setGlobalZValue()`<br>
---* param positionZ  OpenGL Z vertex of this node.<br>
---* js setVertexZ
---@param positionZ float
---@return self
function Node:setPositionZ (positionZ) end
---* Sets the rotation (X,Y,Z) in degrees.<br>
---* Useful for 3d rotations.<br>
---* warning The physics body doesn't support this.<br>
---* param rotation The rotation of the node in 3d.<br>
---* js NA
---@param rotation vec3_table
---@return self
function Node:setRotation3D (rotation) end
---* Gets/Sets x or y coordinate individually for position.<br>
---* These methods are used in Lua and Javascript Bindings<br>
---* Sets the x coordinate of the node in its parent's coordinate system.<br>
---* param x The x coordinate of the node.
---@param x float
---@return self
function Node:setPositionX (x) end
---* Sets the transformation matrix manually.<br>
---* param transform A given transformation matrix.
---@param transform mat4_table
---@return self
function Node:setNodeToParentTransform (transform) end
---* Returns the anchor point in percent.<br>
---* see `setAnchorPoint(const Vec2&)`<br>
---* return The anchor point of node.
---@return vec2_table
function Node:getAnchorPoint () end
---* Returns the numbers of actions that are running plus the ones that are schedule to run (actions in actionsToAdd and actions arrays).<br>
---* Composable actions are counted as 1 action. Example:<br>
---* If you are running 1 Sequence of 7 actions, it will return 1.<br>
---* If you are running 7 Sequences of 2 actions, it will return 7.<br>
---* return The number of actions that are running plus the ones that are schedule to run.
---@return int
function Node:getNumberOfRunningActions () end
---* Calls children's updateTransform() method recursively.<br>
---* This method is moved from Sprite, so it's no longer specific to Sprite.<br>
---* As the result, you apply SpriteBatchNode's optimization on your customed Node.<br>
---* e.g., `batchNode->addChild(myCustomNode)`, while you can only addChild(sprite) before.
---@return self
function Node:updateTransform () end
---* Determines if the node is visible.<br>
---* see `setVisible(bool)`<br>
---* return true if the node is visible, false if the node is hidden.
---@return boolean
function Node:isVisible () end
---* Returns the amount of children.<br>
---* return The amount of children.
---@return int
function Node:getChildrenCount () end
---* Converts a Vec2 to node (local) space coordinates. The result is in Points.<br>
---* treating the returned/received node point as anchor relative.<br>
---* param worldPoint A given coordinate.<br>
---* return A point in node (local) space coordinates, anchor relative.
---@param worldPoint vec2_table
---@return vec2_table
function Node:convertToNodeSpaceAR (worldPoint) end
---* Adds a component.<br>
---* param component A given component.<br>
---* return True if added success.
---@param component cc.Component
---@return boolean
function Node:addComponent (component) end
---* Executes an action, and returns the action that is executed.<br>
---* This node becomes the action's target. Refer to Action::getTarget().<br>
---* warning Actions don't retain their target.<br>
---* param action An Action pointer.
---@param action cc.Action
---@return cc.Action
function Node:runAction (action) end
---@overload fun():self
---@overload fun(cc.Renderer:cc.Renderer,mat4_table:mat4_table,unsigned_int:unsigned_int):self
---@param renderer cc.Renderer
---@param parentTransform mat4_table
---@param parentFlags unsigned_int
---@return self
function Node:visit (renderer,parentTransform,parentFlags) end
---* Returns the rotation of the node in degrees.<br>
---* see `setRotation(float)`<br>
---* return The rotation of the node in degrees.
---@return float
function Node:getRotation () end
---* 
---@return cc.PhysicsBody
function Node:getPhysicsBody () end
---* Returns the anchorPoint in absolute pixels.<br>
---* warning You can only read it. If you wish to modify it, use anchorPoint instead.<br>
---* see `getAnchorPoint()`<br>
---* return The anchor point in absolute pixels.
---@return vec2_table
function Node:getAnchorPointInPoints () end
---* Removes a child from the container by tag value. It will also cleanup all running actions depending on the cleanup parameter.<br>
---* param name       A string that identifies a child node.<br>
---* param cleanup   True if all running actions and callbacks on the child node will be cleanup, false otherwise.
---@param name string
---@param cleanup boolean
---@return self
function Node:removeChildByName (name,cleanup) end
---* Sets a Scheduler object that is used to schedule all "updates" and timers.<br>
---* warning If you set a new Scheduler, then previously created timers/update are going to be removed.<br>
---* param scheduler     A Scheduler object that is used to schedule all "update" and timers.
---@param scheduler cc.Scheduler
---@return self
function Node:setScheduler (scheduler) end
---* Stops and removes all actions from the running action list .
---@return self
function Node:stopAllActions () end
---* Returns the X skew angle of the node in degrees.<br>
---* see `setSkewX(float)`<br>
---* return The X skew angle of the node in degrees.
---@return float
function Node:getSkewX () end
---* Returns the Y skew angle of the node in degrees.<br>
---* see `setSkewY(float)`<br>
---* return The Y skew angle of the node in degrees.
---@return float
function Node:getSkewY () end
---* Get the callback of event EnterTransitionDidFinish.<br>
---* return std::function<void()>
---@return function
function Node:getOnEnterTransitionDidFinishCallback () end
---* Query node's displayed color.<br>
---* return A Color3B color value.
---@return color3b_table
function Node:getDisplayedColor () end
---* Gets an action from the running action list by its tag.<br>
---* see `setTag(int)`, `getTag()`.<br>
---* return The action object with the given tag.
---@param tag int
---@return cc.Action
function Node:getActionByTag (tag) end
---*  Changes the name that is used to identify the node easily.<br>
---* param name A string that identifies the node.<br>
---* since v3.2
---@param name string
---@return self
function Node:setName (name) end
---* Update method will be called automatically every frame if "scheduleUpdate" is called, and the node is "live".<br>
---* param delta In seconds.
---@param delta float
---@return self
function Node:update (delta) end
---* Return the node's display opacity.<br>
---* The difference between opacity and displayedOpacity is:<br>
---* The displayedOpacity is what's the final rendering opacity of node.<br>
---* return A GLubyte value.
---@return unsigned_char
function Node:getDisplayedOpacity () end
---* Gets the local Z order of this node.<br>
---* see `setLocalZOrder(int)`<br>
---* return The local (relative to its siblings) Z order.
---@return int
function Node:getLocalZOrder () end
---@overload fun():self
---@overload fun():self
---@return cc.Scheduler
function Node:getScheduler () end
---* 
---@return cc.AffineTransform
function Node:getParentToNodeAffineTransform () end
---*  Returns the normalized position.<br>
---* return The normalized position.
---@return vec2_table
function Node:getPositionNormalized () end
---* Change the color of node.<br>
---* param color A Color3B color value.
---@param color color3b_table
---@return self
function Node:setColor (color) end
---* Returns whether or not the node is "running".<br>
---* If the node is running it will accept event callbacks like onEnter(), onExit(), update().<br>
---* return Whether or not the node is running.
---@return boolean
function Node:isRunning () end
---@overload fun():self
---@overload fun():self
---@return self
function Node:getParent () end
---* Gets position Z coordinate of this node.<br>
---* see setPositionZ(float)<br>
---* return The position Z coordinate of this node.<br>
---* js getVertexZ
---@return float
function Node:getPositionZ () end
---*  Gets the y coordinate of the node in its parent's coordinate system.<br>
---* return The y coordinate of the node.
---@return float
function Node:getPositionY () end
---*  Gets the x coordinate of the node in its parent's coordinate system.<br>
---* return The x coordinate of the node.
---@return float
function Node:getPositionX () end
---* Removes a child from the container by tag value. It will also cleanup all running actions depending on the cleanup parameter.<br>
---* param tag       An integer number that identifies a child node.<br>
---* param cleanup   True if all running actions and callbacks on the child node will be cleanup, false otherwise.<br>
---* Please use `removeChildByName` instead.
---@param tag int
---@param cleanup boolean
---@return self
function Node:removeChildByTag (tag,cleanup) end
---*  Sets the y coordinate of the node in its parent's coordinate system.<br>
---* param y The y coordinate of the node.
---@param y float
---@return self
function Node:setPositionY (y) end
---* Update node's displayed color with its parent color.<br>
---* param parentColor A Color3B color value.
---@param parentColor color3b_table
---@return self
function Node:updateDisplayedColor (parentColor) end
---* Sets whether the node is visible.<br>
---* The default value is true, a node is default to visible.<br>
---* param visible   true if the node is visible, false if the node is hidden.
---@param visible boolean
---@return self
function Node:setVisible (visible) end
---* Returns the matrix that transform parent's space coordinates to the node's (local) space coordinates.<br>
---* The matrix is in Pixels.<br>
---* return The transformation matrix.
---@return mat4_table
function Node:getParentToNodeTransform () end
---* Checks whether a lambda function is scheduled.<br>
---* param key      key of the callback<br>
---* return Whether the lambda function selector is scheduled.<br>
---* js NA<br>
---* lua NA
---@param key string
---@return boolean
function Node:isScheduled (key) end
---* Defines the order in which the nodes are renderer.<br>
---* Nodes that have a Global Z Order lower, are renderer first.<br>
---* In case two or more nodes have the same Global Z Order, the order is not guaranteed.<br>
---* The only exception if the Nodes have a Global Z Order == 0. In that case, the Scene Graph order is used.<br>
---* By default, all nodes have a Global Z Order = 0. That means that by default, the Scene Graph order is used to render the nodes.<br>
---* Global Z Order is useful when you need to render nodes in an order different than the Scene Graph order.<br>
---* Limitations: Global Z Order can't be used by Nodes that have SpriteBatchNode as one of their ancestors.<br>
---* And if ClippingNode is one of the ancestors, then "global Z order" will be relative to the ClippingNode.<br>
---* see `setLocalZOrder()`<br>
---* see `setVertexZ()`<br>
---* since v3.0<br>
---* param globalZOrder The global Z order value.
---@param globalZOrder float
---@return self
function Node:setGlobalZOrder (globalZOrder) end
---@overload fun(float:float,float:float):self
---@overload fun(float:float):self
---@param scaleX float
---@param scaleY float
---@return self
function Node:setScale (scaleX,scaleY) end
---* Gets a child from the container with its tag.<br>
---* param tag   An identifier to find the child node.<br>
---* return a Node object whose tag equals to the input parameter.<br>
---* Please use `getChildByName()` instead.
---@param tag int
---@return self
function Node:getChildByTag (tag) end
---* Returns the scale factor on Z axis of this node<br>
---* see `setScaleZ(float)`<br>
---* return The scale factor on Z axis.
---@return float
function Node:getScaleZ () end
---* Returns the scale factor on Y axis of this node<br>
---* see `setScaleY(float)`<br>
---* return The scale factor on Y axis.
---@return float
function Node:getScaleY () end
---* Returns the scale factor on X axis of this node<br>
---* see setScaleX(float)<br>
---* return The scale factor on X axis.
---@return float
function Node:getScaleX () end
---* LocalZOrder is the 'key' used to sort the node relative to its siblings.<br>
---* The Node's parent will sort all its children based on the LocalZOrder value.<br>
---* If two nodes have the same LocalZOrder, then the node that was added first to the children's array will be in front of the other node in the array.<br>
---* Also, the Scene Graph is traversed using the "In-Order" tree traversal algorithm ( http:en.wikipedia.org/wiki/Tree_traversal#In-order )<br>
---* And Nodes that have LocalZOrder values < 0 are the "left" subtree<br>
---* While Nodes with LocalZOrder >=0 are the "right" subtree.<br>
---* see `setGlobalZOrder`<br>
---* see `setVertexZ`<br>
---* param localZOrder The local Z order value.
---@param localZOrder int
---@return self
function Node:setLocalZOrder (localZOrder) end
---* 
---@return cc.AffineTransform
function Node:getWorldToNodeAffineTransform () end
---* If you want node's color affect the children node's color, then set it to true.<br>
---* Otherwise, set it to false.<br>
---* param cascadeColorEnabled A boolean value.
---@param cascadeColorEnabled boolean
---@return self
function Node:setCascadeColorEnabled (cascadeColorEnabled) end
---* Change node opacity.<br>
---* param opacity A GLubyte opacity value.
---@param opacity unsigned_char
---@return self
function Node:setOpacity (opacity) end
---* Stops all running actions and schedulers
---@return self
function Node:cleanup () end
---* / @{/ @name component functions<br>
---* Gets a component by its name.<br>
---* param name A given name of component.<br>
---* return The Component by name.
---@param name string
---@return cc.Component
function Node:getComponent (name) end
---* Returns the untransformed size of the node.<br>
---* see `setContentSize(const Size&)`<br>
---* return The untransformed size of the node.
---@return size_table
function Node:getContentSize () end
---* Removes all actions from the running action list by its tag.<br>
---* param tag   A tag that indicates the action to be removed.
---@param tag int
---@return self
function Node:stopAllActionsByTag (tag) end
---* Query node's color value.<br>
---* return A Color3B color value.
---@return color3b_table
function Node:getColor () end
---* Returns an AABB (axis-aligned bounding-box) in its parent's coordinate system.<br>
---* return An AABB (axis-aligned bounding-box) in its parent's coordinate system
---@return rect_table
function Node:getBoundingBox () end
---* Sets whether the anchor point will be (0,0) when you position this node.<br>
---* This is an internal method, only used by Layer and Scene. Don't call it outside framework.<br>
---* The default value is false, while in Layer and Scene are true.<br>
---* param ignore    true if anchor point will be (0,0) when you position this node.
---@param ignore boolean
---@return self
function Node:setIgnoreAnchorPointForPosition (ignore) end
---*  Set event dispatcher for scene.<br>
---* param dispatcher The event dispatcher of scene.
---@param dispatcher cc.EventDispatcher
---@return self
function Node:setEventDispatcher (dispatcher) end
---* Returns the Node's Global Z Order.<br>
---* see `setGlobalZOrder(int)`<br>
---* return The node's global Z order
---@return float
function Node:getGlobalZOrder () end
---@overload fun():self
---@overload fun(cc.Renderer:cc.Renderer,mat4_table:mat4_table,unsigned_int:unsigned_int):self
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function Node:draw (renderer,transform,flags) end
---* Returns a user assigned Object.<br>
---* Similar to UserData, but instead of holding a void* it holds an object.<br>
---* The UserObject will be retained once in this method,<br>
---* and the previous UserObject (if existed) will be released.<br>
---* The UserObject will be released in Node's destructor.<br>
---* param userObject    A user assigned Object.
---@param userObject cc.Ref
---@return self
function Node:setUserObject (userObject) end
---@overload fun(boolean:boolean):self
---@overload fun():self
---@param cleanup boolean
---@return self
function Node:removeFromParentAndCleanup (cleanup) end
---* Sets the position (X, Y, and Z) in its parent's coordinate system.<br>
---* param position The position (X, Y, and Z) in its parent's coordinate system.<br>
---* js NA
---@param position vec3_table
---@return self
function Node:setPosition3D (position) end
---* Returns the numbers of actions that are running plus the ones that are<br>
---* schedule to run (actions in actionsToAdd and actions arrays) with a<br>
---* specific tag.<br>
---* Composable actions are counted as 1 action. Example:<br>
---* If you are running 1 Sequence of 7 actions, it will return 1.<br>
---* If you are running 7 Sequences of 2 actions, it will return 7.<br>
---* param  tag The tag that will be searched.<br>
---* return The number of actions that are running plus the<br>
---* ones that are schedule to run with specific tag.
---@param tag int
---@return int
function Node:getNumberOfRunningActionsByTag (tag) end
---* Sorts the children array once before drawing, instead of every time when a child is added or reordered.<br>
---* This approach can improve the performance massively.<br>
---* note Don't call this manually unless a child added needs to be removed in the same frame.
---@return self
function Node:sortAllChildren () end
---* 
---@return cc.backend.ProgramState
function Node:getProgramState () end
---* Returns the inverse world affine transform matrix. The matrix is in Pixels.<br>
---* return The transformation matrix.
---@return mat4_table
function Node:getWorldToNodeTransform () end
---* Gets the scale factor of the node,  when X and Y have the same scale factor.<br>
---* warning Assert when `_scaleX != _scaleY`<br>
---* see setScale(float)<br>
---* return The scale factor of the node.
---@return float
function Node:getScale () end
---* Return the node's opacity.<br>
---* return A GLubyte value.
---@return unsigned_char
function Node:getOpacity () end
---*  !!! ONLY FOR INTERNAL USE<br>
---* Sets the arrival order when this node has a same ZOrder with other children.<br>
---* A node which called addChild subsequently will take a larger arrival order,<br>
---* If two children have the same Z order, the child with larger arrival order will be drawn later.<br>
---* warning This method is used internally for localZOrder sorting, don't change this manually<br>
---* param orderOfArrival   The arrival order.
---@return self
function Node:updateOrderOfArrival () end
---* 
---@return vec2_table
function Node:getNormalizedPosition () end
---* Set the callback of event ExitTransitionDidStart.<br>
---* param callback A std::function<void()> callback.
---@param callback function
---@return self
function Node:setOnExitTransitionDidStartCallback (callback) end
---* Gets the X rotation (angle) of the node in degrees which performs a horizontal rotation skew.<br>
---* see `setRotationSkewX(float)`<br>
---* return The X rotation in degrees.<br>
---* js getRotationX 
---@return float
function Node:getRotationSkewX () end
---* Gets the Y rotation (angle) of the node in degrees which performs a vertical rotational skew.<br>
---* see `setRotationSkewY(float)`<br>
---* return The Y rotation in degrees.<br>
---* js getRotationY
---@return float
function Node:getRotationSkewY () end
---* Changes the tag that is used to identify the node easily.<br>
---* Please refer to getTag for the sample code.<br>
---* param tag   A integer that identifies the node.<br>
---* Please use `setName()` instead.
---@param tag int
---@return self
function Node:setTag (tag) end
---* Query whether cascadeColor is enabled or not.<br>
---* return Whether cascadeColor is enabled or not.
---@return boolean
function Node:isCascadeColorEnabled () end
---* Stops and removes an action from the running action list.<br>
---* param action    The action object to be removed.
---@param action cc.Action
---@return self
function Node:stopAction (action) end
---@overload fun():cc.ActionManager
---@overload fun():cc.ActionManager
---@return cc.ActionManager
function Node:getActionManager () end
---* Allocates and initializes a node.<br>
---* return A initialized node which is marked as "autorelease".
---@return self
function Node:create () end
---* Gets count of nodes those are attached to scene graph.
---@return int
function Node:getAttachedNodeCount () end
---* 
---@return self
function Node:Node () end