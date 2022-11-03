---LuaSocket API documentation
---LuaSocket <https://github.com/diegonehab/luasocket> is a Lua extension library that provides
---support for the TCP and UDP transport layers. Defold provides the "socket" namespace in
---runtime, which contain the core C functionality. Additional LuaSocket support modules for
---SMTP, HTTP, FTP etc are not part of the core included, but can be easily added to a project
---and used.
---Note the included helper module "socket.lua" in "builtins/scripts/socket.lua". Require this
---module to add some additional functions and shortcuts to the namespace:
---require "builtins.scripts.socket"
---
---
---LuaSocket is Copyright © 2004-2007 Diego Nehab. All rights reserved.
---LuaSocket is free software, released under the MIT license (same license as the Lua core).
---@class socket
socket = {}
---Closes the TCP object. The internal socket used by the object is closed and the local address to which the object was bound is made available to other applications. No further operations (except for further calls to the close method) are allowed on a closed socket.
--- It is important to close all used sockets once they are not needed, since, in many systems, each socket uses a file descriptor, which are limited system resources. Garbage-collected objects are automatically closed before destruction, though.
function client:close() end

---Check the read buffer status.
--- This is an internal method, any use is unlikely to be portable.
---@return boolean # true if there is any data in the read buffer, false otherwise.
function client:dirty() end

---Returns the underlying socket descriptor or handle associated to the object.
--- This is an internal method, any use is unlikely to be portable.
---@return number # the descriptor or handle. In case the object has been closed, the return will be -1.
function client:getfd() end

---Gets options for the TCP object. See client:setoption <> for description of the option names and values.
---@param option string # the name of the option to get:
---@return any # the option value, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function client:getoption(option) end

---Returns information about the remote side of a connected client object.
--- It makes no sense to call this method on server objects.
---@return string # a string with the IP address of the peer, the port number that peer is using for the connection, and the family ("inet" or "inet6"). In case of error, the method returns nil.
function client:getpeername() end

---Returns the local address information associated to the object.
---@return string # a string with local IP address, the local port number, and the family ("inet" or "inet6"). In case of error, the method returns nil.
function client:getsockname() end

---Returns accounting information on the socket, useful for throttling of bandwidth.
---@return string # a string with the number of bytes received, the number of bytes sent, and the age of the socket object in seconds.
function client:getstats() end

---Reads data from a client object, according to the specified read pattern. Patterns follow the Lua file I/O format, and the difference in performance between patterns is negligible.
---@param pattern string|number? # the read pattern that can be any of the following:
---@param prefix string? # an optional string to be concatenated to the beginning of any received data before return.
---@return string # the received pattern, or nil in case of error.
---@return string # the error message, or nil if no error occurred. The error message can be the string "closed" in case the connection was closed before the transmission was completed or the string "timeout" in case there was a timeout during the operation.
---@return string # a (possibly empty) string containing the partial that was received, or nil if no error occurred.
function client:receive(pattern, prefix) end

---Sends data through client object.
---The optional arguments i and j work exactly like the standard string.sub <> Lua function to allow the selection of a substring to be sent.
--- Output is not buffered. For small strings, it is always better to concatenate them in Lua (with the .. operator) and send the result in one call instead of calling the method several times.
---@param data string # the string to be sent.
---@param i number? # optional starting index of the string.
---@param j number? # optional end index of string.
---@return number] the index of the last byte within [i, j # that has been sent, or nil in case of error. Notice that, if i is 1 or absent, this is effectively the total number of bytes sent.
---@return string # the error message, or nil if no error occurred. The error message can be "closed" in case the connection was closed before the transmission was completed or the string "timeout" in case there was a timeout during the operation.
---@return number] in case of error, the index of the last byte within [i, j # that has been sent. You might want to try again from the byte following that. nil if no error occurred.
function client:send(data, i, j) end

---Sets the underling socket descriptor or handle associated to the object. The current one is simply replaced, not closed, and no other change to the object state is made
---@param handle number # the descriptor or handle to set.
function client:setfd(handle) end

---Sets options for the TCP object. Options are only needed by low-level or time-critical applications. You should only modify an option if you are sure you need it.
---@param option string # the name of the option to set. The value is provided in the value parameter:
---@param value any? # the value to set for the specified option.
---@return number # the value 1, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function client:setoption(option, value) end

---Resets accounting information on the socket, useful for throttling of bandwidth.
---@param received number # the new number of bytes received.
---@param sent number # the new number of bytes sent.
---@param age number # the new age in seconds.
---@return number # the value 1 in case of success, or nil in case of error.
function client:setstats(received, sent, age) end

---Changes the timeout values for the object. By default, all I/O operations are blocking. That is, any call to the methods send, receive, and accept will block indefinitely, until the operation completes. The settimeout method defines a limit on the amount of time the I/O methods can block. When a timeout is set and the specified amount of time has elapsed, the affected methods give up and fail with an error code.
---There are two timeout modes and both can be used together for fine tuning.
--- Although timeout values have millisecond precision in LuaSocket, large blocks can cause I/O functions not to respect timeout values due to the time the library takes to transfer blocks to and from the OS and to and from the Lua interpreter. Also, function that accept host names and perform automatic name resolution might be blocked by the resolver for longer than the specified timeout value.
---@param value number # the amount of time to wait, in seconds. The nil timeout value allows operations to block indefinitely. Negative timeout values have the same effect.
---@param mode string? # optional timeout mode to set:
function client:settimeout(value, mode) end

---Shuts down part of a full-duplex connection.
---@param mode string # which way of the connection should be shut down:
---@return number # the value 1.
function client:shutdown(mode) end

---Closes a UDP object. The internal socket used by the object is closed and the local address to which the object was bound is made available to other applications. No further operations (except for further calls to the close method) are allowed on a closed socket.
--- It is important to close all used sockets once they are not needed, since, in many systems, each socket uses a file descriptor, which are limited system resources. Garbage-collected objects are automatically closed before destruction, though.
function connected:close() end

---Gets an option value from the UDP object. See connected:setoption <> for description of the option names and values.
---@param option string # the name of the option to get:
---@return any # the option value, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function connected:getoption(option) end

---Retrieves information about the peer associated with a connected UDP object.
--- It makes no sense to call this method on unconnected objects.
---@return string # a string with the IP address of the peer, the port number that peer is using for the connection, and the family ("inet" or "inet6"). In case of error, the method returns nil.
function connected:getpeername() end

---Returns the local address information associated to the object.
--- UDP sockets are not bound to any address until the setsockname or the sendto method is called for the first time (in which case it is bound to an ephemeral port and the wild-card address).
---@return string # a string with local IP address, a number with the local port, and the family ("inet" or "inet6"). In case of error, the method returns nil.
function connected:getsockname() end

---Receives a datagram from the UDP object. If the UDP object is connected, only datagrams coming from the peer are accepted. Otherwise, the returned datagram can come from any host.
---@param size number? # optional maximum size of the datagram to be retrieved. If there are more than size bytes available in the datagram, the excess bytes are discarded. If there are less then size bytes available in the current datagram, the available bytes are returned. If size is omitted, the maximum datagram size is used (which is currently limited by the implementation to 8192 bytes).
---@return string # the received datagram, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function connected:receive(size) end

---Sends a datagram to the UDP peer of a connected object.
--- In UDP, the send method never blocks and the only way it can fail is if the underlying transport layer refuses to send a message to the specified address (i.e. no interface accepts the address).
---@param datagram string # a string with the datagram contents. The maximum datagram size for UDP is 64K minus IP layer overhead. However datagrams larger than the link layer packet size will be fragmented, which may deteriorate performance and/or reliability.
---@return number # the value 1 on success, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function connected:send(datagram) end

---Sets options for the UDP object. Options are only needed by low-level or time-critical applications. You should only modify an option if you are sure you need it.
---@param option string # the name of the option to set. The value is provided in the value parameter:
---@param value any? # the value to set for the specified option.
---@return number # the value 1, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function connected:setoption(option, value) end

---Changes the peer of a UDP object. This method turns an unconnected UDP object into a connected UDP object or vice versa.
---For connected objects, outgoing datagrams will be sent to the specified peer, and datagrams received from other peers will be discarded by the OS. Connected UDP objects must use the send and receive methods instead of sendto and receivefrom.
--- Since the address of the peer does not have to be passed to and from the OS, the use of connected UDP objects is recommended when the same peer is used for several transmissions and can result in up to 30% performance gains.
---@param _ string # if address is "*" and the object is connected, the peer association is removed and the object becomes an unconnected object again.
---@return number # the value 1 on success, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function connected:setpeername(_) end

---Changes the timeout values for the object. By default, the receive and receivefrom  operations are blocking. That is, any call to the methods will block indefinitely, until data arrives. The settimeout function defines a limit on the amount of time the functions can block. When a timeout is set and the specified amount of time has elapsed, the affected methods give up and fail with an error code.
--- In UDP, the send and sendto methods never block (the datagram is just passed to the OS and the call returns immediately). Therefore, the settimeout method has no effect on them.
---@param value number # the amount of time to wait, in seconds. The nil timeout value allows operations to block indefinitely. Negative timeout values have the same effect.
function connected:settimeout(value) end

---Binds a master object to address and port on the local host.
---@param address string # an IP address or a host name. If address is "*", the system binds to all local interfaces using the INADDR_ANY constant.
---@param port number # the port to commect to, in the range [0..64K). If port is 0, the system automatically chooses an ephemeral port.
---@return number # the value 1, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function master:bind(address, port) end

---Closes the TCP object. The internal socket used by the object is closed and the local address to which the object was bound is made available to other applications. No further operations (except for further calls to the close method) are allowed on a closed socket.
--- It is important to close all used sockets once they are not needed, since, in many systems, each socket uses a file descriptor, which are limited system resources. Garbage-collected objects are automatically closed before destruction, though.
function master:close() end

---Attempts to connect a master object to a remote host, transforming it into a client object. Client objects support methods send, receive, getsockname, getpeername, settimeout, and close.
---Note that the function socket.connect is available and is a shortcut for the creation of client sockets.
---@param address string # an IP address or a host name. If address is "*", the system binds to all local interfaces using the INADDR_ANY constant.
---@param port number # the port to commect to, in the range [0..64K). If port is 0, the system automatically chooses an ephemeral port.
---@return number # the value 1, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function master:connect(address, port) end

---Check the read buffer status.
--- This is an internal method, any use is unlikely to be portable.
---@return boolean # true if there is any data in the read buffer, false otherwise.
function master:dirty() end

---Returns the underlying socket descriptor or handle associated to the object.
--- This is an internal method, any use is unlikely to be portable.
---@return number # the descriptor or handle. In case the object has been closed, the return will be -1.
function master:getfd() end

---Returns the local address information associated to the object.
---@return string # a string with local IP address, the local port number, and the family ("inet" or "inet6"). In case of error, the method returns nil.
function master:getsockname() end

---Returns accounting information on the socket, useful for throttling of bandwidth.
---@return string # a string with the number of bytes received, the number of bytes sent, and the age of the socket object in seconds.
function master:getstats() end

---Specifies the socket is willing to receive connections, transforming the object into a server object. Server objects support the accept, getsockname, setoption, settimeout, and close methods.
---@param backlog number # the number of client connections that can be queued waiting for service. If the queue is full and another client attempts connection, the connection is refused.
---@return number # the value 1, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function master:listen(backlog) end

---Sets the underling socket descriptor or handle associated to the object. The current one is simply replaced, not closed, and no other change to the object state is made
---@param handle number # the descriptor or handle to set.
function master:setfd(handle) end

---Resets accounting information on the socket, useful for throttling of bandwidth.
---@param received number # the new number of bytes received.
---@param sent number # the new number of bytes sent.
---@param age number # the new age in seconds.
---@return number # the value 1 in case of success, or nil in case of error.
function master:setstats(received, sent, age) end

---Changes the timeout values for the object. By default, all I/O operations are blocking. That is, any call to the methods send, receive, and accept will block indefinitely, until the operation completes. The settimeout method defines a limit on the amount of time the I/O methods can block. When a timeout is set and the specified amount of time has elapsed, the affected methods give up and fail with an error code.
---There are two timeout modes and both can be used together for fine tuning.
--- Although timeout values have millisecond precision in LuaSocket, large blocks can cause I/O functions not to respect timeout values due to the time the library takes to transfer blocks to and from the OS and to and from the Lua interpreter. Also, function that accept host names and perform automatic name resolution might be blocked by the resolver for longer than the specified timeout value.
---@param value number # the amount of time to wait, in seconds. The nil timeout value allows operations to block indefinitely. Negative timeout values have the same effect.
---@param mode string? # optional timeout mode to set:
function master:settimeout(value, mode) end

---Waits for a remote connection on the server object and returns a client object representing that connection.
--- Calling socket.select with a server object in the recvt parameter before a call to accept does not guarantee accept will return immediately. Use the settimeout method or accept might block until another client shows up.
---@return client # if a connection is successfully initiated, a client object is returned, or nil in case of error.
---@return string # the error message, or nil if no error occurred. The error is "timeout" if a timeout condition is met.
function server:accept() end

---Closes the TCP object. The internal socket used by the object is closed and the local address to which the object was bound is made available to other applications. No further operations (except for further calls to the close method) are allowed on a closed socket.
--- It is important to close all used sockets once they are not needed, since, in many systems, each socket uses a file descriptor, which are limited system resources. Garbage-collected objects are automatically closed before destruction, though.
function server:close() end

---Check the read buffer status.
--- This is an internal method, any use is unlikely to be portable.
---@return boolean # true if there is any data in the read buffer, false otherwise.
function server:dirty() end

---Returns the underlying socket descriptor or handle associated to the object.
--- This is an internal method, any use is unlikely to be portable.
---@return number # the descriptor or handle. In case the object has been closed, the return will be -1.
function server:getfd() end

---Gets options for the TCP object. See server:setoption <> for description of the option names and values.
---@param option string # the name of the option to get:
---@return any # the option value, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function server:getoption(option) end

---Returns the local address information associated to the object.
---@return string # a string with local IP address, the local port number, and the family ("inet" or "inet6"). In case of error, the method returns nil.
function server:getsockname() end

---Returns accounting information on the socket, useful for throttling of bandwidth.
---@return string # a string with the number of bytes received, the number of bytes sent, and the age of the socket object in seconds.
function server:getstats() end

---Sets the underling socket descriptor or handle associated to the object. The current one is simply replaced, not closed, and no other change to the object state is made
---@param handle number # the descriptor or handle to set.
function server:setfd(handle) end

---Sets options for the TCP object. Options are only needed by low-level or time-critical applications. You should only modify an option if you are sure you need it.
---@param option string # the name of the option to set. The value is provided in the value parameter:
---@param value any? # the value to set for the specified option.
---@return number # the value 1, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function server:setoption(option, value) end

---Resets accounting information on the socket, useful for throttling of bandwidth.
---@param received number # the new number of bytes received.
---@param sent number # the new number of bytes sent.
---@param age number # the new age in seconds.
---@return number # the value 1 in case of success, or nil in case of error.
function server:setstats(received, sent, age) end

---Changes the timeout values for the object. By default, all I/O operations are blocking. That is, any call to the methods send, receive, and accept will block indefinitely, until the operation completes. The settimeout method defines a limit on the amount of time the I/O methods can block. When a timeout is set and the specified amount of time has elapsed, the affected methods give up and fail with an error code.
---There are two timeout modes and both can be used together for fine tuning.
--- Although timeout values have millisecond precision in LuaSocket, large blocks can cause I/O functions not to respect timeout values due to the time the library takes to transfer blocks to and from the OS and to and from the Lua interpreter. Also, function that accept host names and perform automatic name resolution might be blocked by the resolver for longer than the specified timeout value.
---@param value number # the amount of time to wait, in seconds. The nil timeout value allows operations to block indefinitely. Negative timeout values have the same effect.
---@param mode string? # optional timeout mode to set:
function server:settimeout(value, mode) end

---max numbers of sockets the select function can handle
socket._SETSIZE = nil
---the current LuaSocket version
socket._VERSION = nil
---This function is a shortcut that creates and returns a TCP client object connected to a remote
---address at a given port. Optionally, the user can also specify the local address and port to
---bind (locaddr and locport), or restrict the socket family to "inet" or "inet6".
---Without specifying family to connect, whether a tcp or tcp6 connection is created depends on
---your system configuration.
---@param address string # the address to connect to.
---@param port number # the port to connect to.
---@param locaddr string? # optional local address to bind to.
---@param locport number? # optional local port to bind to.
---@param family string? # optional socket family to use, "inet" or "inet6".
---@return client # a new IPv6 TCP client object, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function socket.connect(address, port, locaddr, locport, family) end

---This function converts a host name to IPv4 or IPv6 address.
---The supplied address can be an IPv4 or IPv6 address or host name.
---The function returns a table with all information returned by the resolver:
---{
--- [1] = {
---    family = family-name-1,
---    addr = address-1
---  },
---  ...
---  [n] = {
---    family = family-name-n,
---    addr = address-n
---  }
---}
---
---
---Here, family contains the string "inet" for IPv4 addresses, and "inet6" for IPv6 addresses.
---In case of error, the function returns nil followed by an error message.
---@param address string # a hostname or an IPv4 or IPv6 address.
---@return table # a table with all information returned by the resolver, or if an error occurs, nil.
---@return string # the error message, or nil if no error occurred.
function socket.dns.getaddrinfo(address) end

---Returns the standard host name for the machine as a string.
---@return string # the host name for the machine.
function socket.dns.gethostname() end

---This function converts an address to host name.
---The supplied address can be an IPv4 or IPv6 address or host name.
---The function returns a table with all information returned by the resolver:
---{
---  [1] = host-name-1,
---  ...
---  [n] = host-name-n,
---}
---@param address string # a hostname or an IPv4 or IPv6 address.
---@return table # a table with all information returned by the resolver, or if an error occurs, nil.
---@return string # the error message, or nil if no error occurred.
function socket.dns.getnameinfo(address) end

---This function converts from an IPv4 address to host name.
---The address can be an IPv4 address or a host name.
---@param address string # an IPv4 address or host name.
---@return string # the canonic host name of the given address, or nil in case of an error.
---@return table|string # a table with all information returned by the resolver, or if an error occurs, the error message string.
function socket.dns.tohostname(address) end

---This function converts a host name to IPv4 address.
---The address can be an IP address or a host name.
---@param address string # a hostname or an IP address.
---@return string # the first IP address found for the hostname, or nil in case of an error.
---@return table|string # a table with all information returned by the resolver, or if an error occurs, the error message string.
function socket.dns.toip(address) end

---Returns the time in seconds, relative to the system epoch (Unix epoch time since January 1, 1970 (UTC) or Windows file time since January 1, 1601 (UTC)).
---You should use the values returned by this function for relative measurements only.
---@return number # the number of seconds elapsed.
function socket.gettime() end

---This function creates and returns a clean try function that allows for cleanup before the exception is raised.
---The finalizer function will be called in protected mode (see protect <>).
---@param finalizer fun() # a function that will be called before the try throws the exception.
---@return fun() # the customized try function.
function socket.newtry(finalizer) end

---Converts a function that throws exceptions into a safe function. This function only catches exceptions thrown by try functions. It does not catch normal Lua errors.
--- Beware that if your function performs some illegal operation that raises an error, the protected function will catch the error and return it as a string. This is because try functions uses errors as the mechanism to throw exceptions.
---@param func fun() # a function that calls a try function (or assert, or error) to throw exceptions.
---@return fun(fun:fun()) # an equivalent function that instead of throwing exceptions, returns nil followed by an error message.
function socket.protect(func) end

---The function returns a list with the sockets ready for reading, a list with the sockets ready for writing and an error message. The error message is "timeout" if a timeout condition was met and nil otherwise. The returned tables are doubly keyed both by integers and also by the sockets themselves, to simplify the test if a specific socket has changed status.
---Recvt and sendt parameters can be empty tables or nil. Non-socket values (or values with non-numeric indices) in these arrays will be silently ignored.
---The returned tables are doubly keyed both by integers and also by the sockets themselves, to simplify the test if a specific socket has changed status.
--- This function can monitor a limited number of sockets, as defined by the constant socket._SETSIZE. This number may be as high as 1024 or as low as 64 by default, depending on the system. It is usually possible to change this at compile time. Invoking select with a larger number of sockets will raise an error.
--- A known bug in WinSock causes select to fail on non-blocking TCP sockets. The function may return a socket as writable even though the socket is not ready for sending.
--- Calling select with a server socket in the receive parameter before a call to accept does not guarantee accept will return immediately. Use the settimeout method or accept might block forever.
--- If you close a socket and pass it to select, it will be ignored.
---(Using select with non-socket objects: Any object that implements getfd and dirty can be used with select, allowing objects from other libraries to be used within a socket.select driven loop.)
---@param recvt table # array with the sockets to test for characters available for reading.
---@param sendt table # array with sockets that are watched to see if it is OK to immediately write on them.
---@param timeout number? # the maximum amount of time (in seconds) to wait for a change in status. Nil, negative or omitted timeout value allows the function to block indefinitely.
---@return table # a list with the sockets ready for reading.
---@return table # a list with the sockets ready for writing.
---@return string # an error message. "timeout" if a timeout condition was met, otherwise nil.
function socket.select(recvt, sendt, timeout) end

---This function drops a number of arguments and returns the remaining.
---It is useful to avoid creation of dummy variables:
---D is the number of arguments to drop. Ret1 to retN are the arguments.
---The function returns retD+1 to retN.
---@param d number # the number of arguments to drop.
---@param ret1 any? # argument 1.
---@param ret2 any? # argument 2.
---@param retN any? # argument N.
---@return any? # argument D+1.
---@return any? # argument D+2.
---@return any? # argument N.
function socket.skip(d, ret1, ret2, retN) end

---Freezes the program execution during a given amount of time.
---@param time number # the number of seconds to sleep for.
function socket.sleep(time) end

---Creates and returns an IPv4 TCP master object. A master object can be transformed into a server object with the method listen (after a call to bind) or into a client object with the method connect. The only other method supported by a master object is the close method.
---@return master # a new IPv4 TCP master object, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function socket.tcp() end

---Creates and returns an IPv6 TCP master object. A master object can be transformed into a server object with the method listen (after a call to bind) or into a client object with the method connect. The only other method supported by a master object is the close method.
---Note: The TCP object returned will have the option "ipv6-v6only" set to true.
---@return master # a new IPv6 TCP master object, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function socket.tcp6() end

---Creates and returns an unconnected IPv4 UDP object. Unconnected objects support the sendto, receive, receivefrom, getoption, getsockname, setoption, settimeout, setpeername, setsockname, and close methods. The setpeername method is used to connect the object.
---@return unconnected # a new unconnected IPv4 UDP object, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function socket.udp() end

---Creates and returns an unconnected IPv6 UDP object. Unconnected objects support the sendto, receive, receivefrom, getoption, getsockname, setoption, settimeout, setpeername, setsockname, and close methods. The setpeername method is used to connect the object.
---Note: The UDP object returned will have the option "ipv6-v6only" set to true.
---@return unconnected # a new unconnected IPv6 UDP object, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function socket.udp6() end

---Closes a UDP object. The internal socket used by the object is closed and the local address to which the object was bound is made available to other applications. No further operations (except for further calls to the close method) are allowed on a closed socket.
--- It is important to close all used sockets once they are not needed, since, in many systems, each socket uses a file descriptor, which are limited system resources. Garbage-collected objects are automatically closed before destruction, though.
function unconnected:close() end

---Gets an option value from the UDP object. See unconnected:setoption <> for description of the option names and values.
---@param option string # the name of the option to get:
---@return any # the option value, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function unconnected:getoption(option) end

---Returns the local address information associated to the object.
--- UDP sockets are not bound to any address until the setsockname or the sendto method is called for the first time (in which case it is bound to an ephemeral port and the wild-card address).
---@return string # a string with local IP address, a number with the local port, and the family ("inet" or "inet6"). In case of error, the method returns nil.
function unconnected:getsockname() end

---Receives a datagram from the UDP object. If the UDP object is connected, only datagrams coming from the peer are accepted. Otherwise, the returned datagram can come from any host.
---@param size number? # optional maximum size of the datagram to be retrieved. If there are more than size bytes available in the datagram, the excess bytes are discarded. If there are less then size bytes available in the current datagram, the available bytes are returned. If size is omitted, the maximum datagram size is used (which is currently limited by the implementation to 8192 bytes).
---@return string # the received datagram, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function unconnected:receive(size) end

---Works exactly as the receive method, except it returns the IP address and port as extra return values (and is therefore slightly less efficient).
---@param size number? # optional maximum size of the datagram to be retrieved.
---@return string # the received datagram, or nil in case of error.
---@return string # the IP address, or the error message in case of error.
---@return number # the port number, or nil in case of error.
function unconnected:receivefrom(size) end

---Sends a datagram to the specified IP address and port number.
--- In UDP, the send method never blocks and the only way it can fail is if the underlying transport layer refuses to send a message to the specified address (i.e. no interface accepts the address).
---@param datagram string # a string with the datagram contents. The maximum datagram size for UDP is 64K minus IP layer overhead. However datagrams larger than the link layer packet size will be fragmented, which may deteriorate performance and/or reliability.
---@param ip string # the IP address of the recipient. Host names are not allowed for performance reasons.
---@param port number # the port number at the recipient.
---@return number # the value 1 on success, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function unconnected:sendto(datagram, ip, port) end

---Sets options for the UDP object. Options are only needed by low-level or time-critical applications. You should only modify an option if you are sure you need it.
---@param option string # the name of the option to set. The value is provided in the value parameter:
---@param value any? # the value to set for the specified option.
---@return number # the value 1, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function unconnected:setoption(option, value) end

---Changes the peer of a UDP object. This method turns an unconnected UDP object into a connected UDP object or vice versa.
---For connected objects, outgoing datagrams will be sent to the specified peer, and datagrams received from other peers will be discarded by the OS. Connected UDP objects must use the send and receive methods instead of sendto and receivefrom.
--- Since the address of the peer does not have to be passed to and from the OS, the use of connected UDP objects is recommended when the same peer is used for several transmissions and can result in up to 30% performance gains.
---@param address string # an IP address or a host name.
---@param port number # the port number.
---@return number # the value 1 on success, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function unconnected:setpeername(address, port) end

---Binds the UDP object to a local address.
--- This method can only be called before any datagram is sent through the UDP object, and only once. Otherwise, the system automatically binds the object to all local interfaces and chooses an ephemeral port as soon as the first datagram is sent. After the local address is set, either automatically by the system or explicitly by setsockname, it cannot be changed.
---@param address string # an IP address or a host name. If address is "*" the system binds to all local interfaces using the constant INADDR_ANY.
---@param port number # the port number. If port is 0, the system chooses an ephemeral port.
---@return number # the value 1 on success, or nil in case of error.
---@return string # the error message, or nil if no error occurred.
function unconnected:setsockname(address, port) end

---Changes the timeout values for the object. By default, the receive and receivefrom  operations are blocking. That is, any call to the methods will block indefinitely, until data arrives. The settimeout function defines a limit on the amount of time the functions can block. When a timeout is set and the specified amount of time has elapsed, the affected methods give up and fail with an error code.
--- In UDP, the send and sendto methods never block (the datagram is just passed to the OS and the call returns immediately). Therefore, the settimeout method has no effect on them.
---@param value number # the amount of time to wait, in seconds. The nil timeout value allows operations to block indefinitely. Negative timeout values have the same effect.
function unconnected:settimeout(value) end




return socket