local lang   = require 'language'
local parser = require 'parser'
local guide  = require 'parser.guide'

local function nodeId(node)
	return node.type .. ':' .. node.start .. ':' .. node.finish
end

local function shorten(str)
	if type(str) ~= 'string' then
		return str
	end
	str = str:gsub('\n', '\\\\n')
	if #str <= 20 then
		return str
	else
		return str:sub(1, 17) .. '...'
	end
end

local function getTooltipLine(k, v)
	if type(v) == 'table' then
		if v.type then
			v = '<node ' .. v.type .. '>'
		else
			v = '<table>'
		end
	end
	v = tostring(v)
	v = v:gsub('"', '\\"')
	return k .. ': ' .. shorten(v) .. '\\n'
end

local function getTooltip(node)
	local str = ''
	local skipNodes = {parent = true, start = true, finish = true, type = true}
	str = str .. getTooltipLine('start', node.start)
	str = str .. getTooltipLine('finish', node.finish)
	for k, v in pairs(node) do
		if type(k) ~= 'number' and not skipNodes[k] then
			str = str .. getTooltipLine(k, v)
		end
	end
	for i = 1, math.min(#node, 15) do
		str = str .. getTooltipLine(i, node[i])
	end
	if #node > 15 then
		str = str .. getTooltipLine('15..' .. #node, '(...)')
	end
	return str
end

local nodeEntry = '\t"%s" [\n\t\tlabel="%s\\l%s\\l"\n\t\ttooltip="%s"\n\t]'
local function getNodeLabel(node)
	local keyName = guide.getKeyName(node)
	if node.type == 'binary' or node.type == 'unary' then
		keyName = node.op.type
	elseif node.type == 'label' or node.type == 'goto' then
		keyName = node[1]
	end
	return nodeEntry:format(nodeId(node), node.type, shorten(keyName) or '', getTooltip(node))
end

local function getVisualizeVisitor(writer)
	local function visitNode(node, parent)
		if node == nil then return end
		writer:write(getNodeLabel(node))
		writer:write('\n')
		if parent then
			writer:write(('\t"%s" -> "%s"'):format(nodeId(parent), nodeId(node)))
			writer:write('\n')
		end
		guide.eachChild(node, function(child)
			visitNode(child, node)
		end)
	end
	return visitNode
end


local export = {}

function export.visualizeAst(code, writer)
	local state = parser.compile(code, 'Lua', _G['LUA_VER'] or 'Lua 5.4')
	writer:write('digraph AST {\n')
	writer:write('\tnode [shape = rect]\n')
	getVisualizeVisitor(writer)(state.ast)
	writer:write('}\n')
end

function export.runCLI()
	lang(LOCALE)
	local file = _G['VISUALIZE']
	local code, err = io.open(file)
	if not code then
		io.stderr:write('failed to open ' .. file .. ': ' .. err)
		return 1
	end
	code = code:read('a')
	return export.visualizeAst(code, io.stdout)
end

return export
