---@meta

---@class ccui.WebView :ccui.Widget
local WebView={ }
ccui.WebView=WebView




---* SetOpacity of webview.
---@param opacity float
---@return self
function WebView:setOpacityWebView (opacity) end
---* Gets whether this WebView has a back history item.<br>
---* return WebView has a back history item.
---@return boolean
function WebView:canGoBack () end
---* Sets the main page content and base URL.<br>
---* param string The content for the main page.<br>
---* param baseURL The base URL for the content.
---@param string string
---@param baseURL string
---@return self
function WebView:loadHTMLString (string,baseURL) end
---* Goes forward in the history.
---@return self
function WebView:goForward () end
---* Goes back in the history.
---@return self
function WebView:goBack () end
---* Set WebView should support zooming. The default value is false.
---@param scalesPageToFit boolean
---@return self
function WebView:setScalesPageToFit (scalesPageToFit) end
---* Loads the given fileName.<br>
---* param fileName Content fileName.
---@param fileName string
---@return self
function WebView:loadFile (fileName) end
---@overload fun(string:string,boolean:boolean):self
---@overload fun(string:string):self
---@param url string
---@param cleanCachedData boolean
---@return self
function WebView:loadURL (url,cleanCachedData) end
---* Set whether the webview bounces at end of scroll of WebView.
---@param bounce boolean
---@return self
function WebView:setBounces (bounce) end
---* Evaluates JavaScript in the context of the currently displayed page.
---@param js string
---@return self
function WebView:evaluateJS (js) end
---* set the background transparent
---@return self
function WebView:setBackgroundTransparent () end
---* Get the Javascript callback.
---@return function
function WebView:getOnJSCallback () end
---* Gets whether this WebView has a forward history item.<br>
---* return WebView has a forward history item.
---@return boolean
function WebView:canGoForward () end
---* Stops the current load.
---@return self
function WebView:stopLoading () end
---* getOpacity of webview.
---@return float
function WebView:getOpacityWebView () end
---* Reloads the current URL.
---@return self
function WebView:reload () end
---* Set javascript interface scheme.<br>
---* see WebView::setOnJSCallback()
---@param scheme string
---@return self
function WebView:setJavascriptInterfaceScheme (scheme) end
---* Allocates and initializes a WebView.
---@return self
function WebView:create () end
---* 
---@return self
function WebView:onEnter () end
---* Toggle visibility of WebView.
---@param visible boolean
---@return self
function WebView:setVisible (visible) end
---* 
---@return self
function WebView:onExit () end
---* Default constructor.
---@return self
function WebView:WebView () end