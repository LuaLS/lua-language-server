function io.load(file_path)
	local f, e = io.open(file_path:string(), 'rb')
	if not f then
		return nil, e
	end
	local buf = f:read 'a'
	f:close()
	return buf
end

function io.save(file_path, content)
	local f, e = io.open(file_path:string(), "wb")

	if f then
		f:write(content)
		f:close()
		return true
	else
		return false, e
	end
end
