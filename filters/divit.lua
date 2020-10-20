-- Load my stringRep module so it's available for inspecting the AST
-- These seem to need to be loaded relative to the working firectory pandoc is called from
-- local sr = require "filters/stringRep"

-- Create a lookup table for css class names based on environment names produced in the tex
classNames = {}
classNames['Lemma:'] = 'lemma'
classNames['Theorem:'] = 'theorem'
classNames['Definition:'] = 'definition'
classNames['Proof:'] = 'proof'
classNames['Example:'] = 'example'
classNames['Framed:'] = 'framed'
classNames['Proposition:'] = 'proposition'
classNames['Center:'] = 'center'
classNames['Remark:'] = 'remark'
classNames['Corollary:'] = 'corollary'
classNames['Exercise:'] = 'exercise'
classNames['Question:'] = 'question'
classNames['Problem:'] = 'problem'
classNames['Solution:'] = 'solution'
classNames['BonusProblem:'] = 'bonusproblem'
classNames['BonusSolution:'] = 'bonussolution'


local vars = {}

function getMeta(meta)
	for k,v in pairs(meta) do
		vars[k]=v
	end
end

function divit(elem)
	local cont = elem.content
	local className
	local envType = cont[1].content[1].text
	local refLabel = ''
	
	-- inspect the AST using the following command
	-- print(sr.stringRep(cont,3))
	
	if (classNames[envType]) then
		className = classNames[envType]
		-- Remove solutions, unless showSols is set as metadata (on the command line for instance)
		if (not vars.showSols) then
			if(string.find(className,"solution")) then
				return pandoc.Null
			end
		end
		-- We hope that the environment we're trying to div has a label. Depending on the formatting of the tex, this can happen in a few ways. If the label appears on the same line of the tex as the \begin{env} then the first entry of cont (which is a table) is a Para, whose first contents item is a string containing the name of our environment, whose second contents item is a softbreak and whose third contents item is a span containing the label info. It's also possible that the theorem content itself starts on the same line as the theorem, in which case can we assume that the third contents item is not a span? Or maybe we need to check the span more carefully.
		if ((#cont[1].content > 1) and (cont[1].content[2].t == 'SoftBreak')) then
			-- Are there any other cases where the span isn't a label?
			if (cont[1].content[3].t == 'Span') then
				--In this case, remove the environment name
				table.remove(cont[1].content,1)
				--Remove the softbreak
				table.remove(cont[1].content,1)
				--Save the label name and then remove the corrsponding span. The resultant divs contents will be the remainder of cont 
				refLabel = cont[1].content[1].attr.attributes.label
				table.remove(cont[1].content,1)
			else
				-- In this case, the theorem itself starts on the same line as the theorem environment; remove the environment name
				table.remove(cont[1].content,1)
				--Remove the softbreak
				table.remove(cont[1].content,1)
			end
			
		-- If the label appears on a new line in the tex, then cont has its first item as a Para which contains the string of the env name and as its second item a Para whose first contents item is a span containing the label info
		elseif (#cont>1) and (cont[2].content) and (cont[2].content[1].t == 'Span') and (cont[2].content[1].attr.attributes.label) then
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

return{{Meta = getMeta},{BlockQuote = divit}}