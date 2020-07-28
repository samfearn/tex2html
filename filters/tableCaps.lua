-- Load my stringRep module so it's available for inspecting the AST
-- These seem to need to be loaded relative to the working firectory pandoc is called from
-- local sr = require "filters/stringRep"

function Table(elem)
	-- inspect the AST using the following command
	-- print(sr.stringRep(elem,3))
	-- The AST structure of tables seems confusing, but the follownig seems to correspond to the rows of the table
	tableRows = elem.bodies[1].body
	local tableCells = {}
	local imageCells = {}
	-- The idea is to collect the actual cells into tableCells (handling the AST structure), then go through these to identify image cells.
	for rowi,rowv in pairs(tableRows) do
		for celli,cellv in pairs(tableRows[rowi][2]) do
			tableCells[2*rowi-2+celli]=cellv
		end
	end
	for celli,cellv in pairs(tableCells) do
		local cellCont = cellv.contents
		if (#cellCont>0) then
			for cellconti,cellcontv in pairs(cellCont[1].content) do
				if (cellcontv.t=='Image') then
					table.insert(imageCells,cellcontv)
				end
			end
		end
	end
	-- Now we've isolated all the images, we check they all have the same id. If so, we add the id and caption to the table
	local id = imageCells[1].identifier
	local cap = imageCells[1].caption
	for i,v in pairs(imageCells) do
		if (v.identifier ~= id) then
			-- If we have a table where the images don't all share a caption and id, we abort
			return elem
		end
	end
	
	-- All images have the same id and caption, so we set the table values accordingly
	elem.attr[1] = id
	elem.caption.long = {pandoc.Plain(cap)}
	-- Give the table a class of imageTable
	table.insert(elem.attr[2],"imageTable")
	return elem
end