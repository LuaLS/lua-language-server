---@meta

---@class cc.EventDispatcher :cc.Ref
local EventDispatcher={ }
cc.EventDispatcher=EventDispatcher




---*  Pauses all listeners which are associated the specified target.<br>
---* param target A given target node.<br>
---* param recursive True if pause recursively, the default value is false.
---@param target cc.Node
---@param recursive boolean
---@return self
function EventDispatcher:pauseEventListenersForTarget (target,recursive) end
---*  Adds a event listener for a specified event with the priority of scene graph.<br>
---* param listener The listener of a specified event.<br>
---* param node The priority of the listener is based on the draw order of this node.<br>
---* note  The priority of scene graph will be fixed value 0. So the order of listener item<br>
---* in the vector will be ' <0, scene graph (0 priority), >0'.
---@param listener cc.EventListener
---@param node cc.Node
---@return self
function EventDispatcher:addEventListenerWithSceneGraphPriority (listener,node) end
---*  Whether to enable dispatching events.<br>
---* param isEnabled  True if enable dispatching events.
---@param isEnabled boolean
---@return self
function EventDispatcher:setEnabled (isEnabled) end
---*  Adds a event listener for a specified event with the fixed priority.<br>
---* param listener The listener of a specified event.<br>
---* param fixedPriority The fixed priority of the listener.<br>
---* note A lower priority will be called before the ones that have a higher value.<br>
---* 0 priority is forbidden for fixed priority since it's used for scene graph based priority.
---@param listener cc.EventListener
---@param fixedPriority int
---@return self
function EventDispatcher:addEventListenerWithFixedPriority (listener,fixedPriority) end
---*  Remove a listener.<br>
---* param listener The specified event listener which needs to be removed.
---@param listener cc.EventListener
---@return self
function EventDispatcher:removeEventListener (listener) end
---*  Dispatches a Custom Event with a event name an optional user data.<br>
---* param eventName The name of the event which needs to be dispatched.<br>
---* param optionalUserData The optional user data, it's a void*, the default value is nullptr.
---@param eventName string
---@param optionalUserData void
---@return self
function EventDispatcher:dispatchCustomEvent (eventName,optionalUserData) end
---*  Resumes all listeners which are associated the specified target.<br>
---* param target A given target node.<br>
---* param recursive True if resume recursively, the default value is false.
---@param target cc.Node
---@param recursive boolean
---@return self
function EventDispatcher:resumeEventListenersForTarget (target,recursive) end
---*  Removes all listeners which are associated with the specified target.<br>
---* param target A given target node.<br>
---* param recursive True if remove recursively, the default value is false.
---@param target cc.Node
---@param recursive boolean
---@return self
function EventDispatcher:removeEventListenersForTarget (target,recursive) end
---*  Sets listener's priority with fixed value.<br>
---* param listener A given listener.<br>
---* param fixedPriority The fixed priority value.
---@param listener cc.EventListener
---@param fixedPriority int
---@return self
function EventDispatcher:setPriority (listener,fixedPriority) end
---*  Adds a Custom event listener.<br>
---* It will use a fixed priority of 1.<br>
---* param eventName A given name of the event.<br>
---* param callback A given callback method that associated the event name.<br>
---* return the generated event. Needed in order to remove the event from the dispatcher
---@param eventName string
---@param callback function
---@return cc.EventListenerCustom
function EventDispatcher:addCustomEventListener (eventName,callback) end
---*  Dispatches the event.<br>
---* Also removes all EventListeners marked for deletion from the<br>
---* event dispatcher list.<br>
---* param event The event needs to be dispatched.
---@param event cc.Event
---@return self
function EventDispatcher:dispatchEvent (event) end
---*  Query whether the specified event listener id has been added.<br>
---* param listenerID The listenerID of the event listener id.<br>
---* return True if dispatching events is exist
---@param listenerID string
---@return boolean
function EventDispatcher:hasEventListener (listenerID) end
---*  Removes all listeners.
---@return self
function EventDispatcher:removeAllEventListeners () end
---*  Removes all custom listeners with the same event name.<br>
---* param customEventName A given event listener name which needs to be removed.
---@param customEventName string
---@return self
function EventDispatcher:removeCustomEventListeners (customEventName) end
---*  Checks whether dispatching events is enabled.<br>
---* return True if dispatching events is enabled.
---@return boolean
function EventDispatcher:isEnabled () end
---*  Removes all listeners with the same event listener type.<br>
---* param listenerType A given event listener type which needs to be removed.
---@param listenerType int
---@return self
function EventDispatcher:removeEventListenersForType (listenerType) end
---*  Constructor of EventDispatcher.
---@return self
function EventDispatcher:EventDispatcher () end