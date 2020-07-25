-- Load my stringRep module so it's available for inspecting the AST
-- These seem to need to be loaded relative to the working firectory pandoc is called from
local sr = require "filters/stringRep"

function Link (elem)
	-- Use the following command to inspect the AST
	-- print(sr.stringRep(elem,3))

	-- Ref links already work (and the script loaded in numbering.html handles the appropriate numbering), but eqref links need to be interpreted by mathjax to work properly. We therefore convert all links of type eqref into inline maths environments of the appropriate type.
	if elem.attributes["reference-type"] == "eqref" then
		return pandoc.Math("InlineMath", "\\eqref{" .. elem.attributes["reference"] .. "}")
	end
	-- If the links isn't of type eqref, leave it alone.
	return elem
end