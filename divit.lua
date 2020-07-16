-- Create a lookup table for css class names based on environment names produced in the tex
classNames = {}
classNames['Lemma:'] = 'lemma'
classNames['Theorem:'] = 'theorem'
classNames['Definition:'] = 'definition'
classNames['Proof:'] = 'proof'
classNames['Example:'] = 'example'

-- This function is a helper function for letting me inspect the AST
function tableRep(table,depth)
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
						tree[i] = tree[i] .. stringRep(vcont,depth-1)
					end
				end
			-- If v doesn't have a tag, it's probably a table?
			elseif depth > 1 then
				tree[i] = stringRep(v,depth-1)
			else
				tree[i]=type(v)..'('..#v..')'
			end
		end
	-- Tags such as Para have type table, but no elements, they're just wrappers around more elements, so call tableRep on the contents of the element.
	else
		tree = tableRep(table.content)
	end
	return tree
end	

function stringRep(table,depth)
	-- Give depth a default value of 1 if it isn't explicitly given
	depth = depth or 1
	local tree = tableRep(table,depth)
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

function BlockQuote (elem)
	local cont = elem.content
	local className
	local envType = cont[1].content[1].text
	local refLabel = ''
	
	-- print(stringRep(cont,3))
	
	if (classNames[envType]) then
		className = classNames[envType]
		-- We hope that the environment we're trying to div has a label. Depending on the formatting of the tex, this can happen in a few ways. If the label appears on the same line of the tex as the \begin{env} then the first entry of cont (which is a table) is a Para, whose first contents item is a string containing the name of our environment, whose second contents item is a softbreak and whose third contents item is a span containing the label info.
		if (#cont[1].content > 1) and (cont[1].content[2].t == 'SoftBreak') and (cont[1].content[3].t == 'Span') then
			--In this case, remove the environment name
			table.remove(cont[1].content,1)
			--Remove the softbreak
			table.remove(cont[1].content,1)
			--Save the label name and then remove the corrsponding span. The resultant divs contents will be the remainder of cont 
			refLabel = cont[1].content[1].attr.attributes.label
			table.remove(cont[1].content,1)
			
		-- If the label appears on a new line in the tex, then cont has its first item as a Para which contains the string of the env name and as its second item a Para whose first contents item is a span containing the label info
		elseif (cont[2].content[1].t == 'Span') then
			--In this case, remove the environment name
			table.remove(cont,1)
			--Save the label name and then remove the corrsponding span. The resultant divs contents will be the remainder of cont 
			refLabel = cont[1].content[1].attr.attributes.label
			table.remove(cont[1].content,1)
			
		-- It may be that there is no label. In this case, we can't give the div an id. Cont will have its first item as a Para which contains the string of the env name.
		else
			--In this case, remove the environment name.
			table.remove(cont,1)
		end
	end
	return pandoc.Div(cont,{class=className,id=refLabel})
end