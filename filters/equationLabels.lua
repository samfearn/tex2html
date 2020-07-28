-- Load my stringRep module so it's available for inspecting the AST
-- These seem to need to be loaded relative to the working firectory pandoc is called from
-- local sr = require "filters/stringRep"

function Math(elem)
	-- inspect the AST using the following command
	-- print(sr.stringRep(elem,3))
	if (elem.mathtype == "DisplayMath") then
		local math = elem.text
		-- If the aligned environment contains a label, then turn it into align rather than aligned, otherwise leave it as aligned.
		if math:find("\\label{[%w%-%+_&:%^]+}") then
			if math:find("\\begin{aligned}") then
				math = (math:gsub("\\begin{aligned}","\\begin{align}"))
				math = (math:gsub("\\end{aligned}","\\end{align}"))
			else
				math = "\\begin{equation} " .. math .. " \\end{equation}"
			end
		end
		elem.text = math
	end
	return elem
end