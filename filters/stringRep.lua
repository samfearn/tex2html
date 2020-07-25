local stringRep = {}

-- This function is a helper function for letting me inspect the AST
function stringRep.tableRep(table,depth)
	-- Give depth a default value of 1 if it isn't explicitly given
	depth = depth or 1
	local tree = {}
	-- Check table is non-empty, this happens if table is a collection of AST elements
	if not table then return tree end
	if #table > 0 then
		for i,v in ipairs(table) do
			-- nil is falsy but everything else is truthy, so check whether v has an AST tag
			if v.t then
				tree[i]=v.t
				-- If the optional depth argument is given, then give the structure of the next layer of the AST.
				if type(v) == 'table' and depth > 1 then
					local vcont = v.content
					local vtext = v.text
					if vcont then
						tree[i] = tree[i] .. stringRep.stringRep(vcont,depth-1)
					end
				end
			-- If v doesn't have a tag, it's probably a table?
			elseif depth > 1 then
				tree[i] = stringRep.stringRep(v,depth-1)
			else
				tree[i]=type(v)..'('..#v..')'
			end
		end
	-- Tags such as Para have type table, but no elements, they're just wrappers around more elements, so call tableRep on the contents of the element.
	else
		tree = stringRep.tableRep(table.content)
	end
	return tree
end	

function stringRep.stringRep(table,depth)
	-- Give depth a default value of 1 if it isn't explicitly given
	depth = depth or 1
	local tree = stringRep.tableRep(table,depth)
	local stringRep = '{'
	for i,v in ipairs(tree) do
		if i == 1 then
			stringRep = stringRep .. tostring(v)
		else
			stringRep = stringRep .. ', ' .. tostring(v)
		end
	end
	return stringRep .. '}'
end

return stringRep