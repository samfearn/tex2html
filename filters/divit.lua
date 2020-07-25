-- Load my stringRep module so it's available for inspecting the AST
local sr = require "stringRep"

-- Create a lookup table for css class names based on environment names produced in the tex
classNames = {}
classNames['Lemma:'] = 'lemma'
classNames['Theorem:'] = 'theorem'
classNames['Definition:'] = 'definition'
classNames['Proof:'] = 'proof'
classNames['Example:'] = 'example'
classNames['Framed:'] = 'framed'

function BlockQuote (elem)
	local cont = elem.content
	local className
	local envType = cont[1].content[1].text
	local refLabel = ''
	
	-- inspect the AST using the following command
	-- print(sr.stringRep(cont,3))
	
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