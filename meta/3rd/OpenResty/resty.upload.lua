---@meta
resty_upload={}
function resty_upload.read(self) end
function resty_upload.set_timeout(self, timeout) end
resty_upload._VERSION="0.10"
function resty_upload.new(self, chunk_size, max_line_size) end
return resty_upload