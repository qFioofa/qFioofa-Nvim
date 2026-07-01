-- nvim 0.12 removed the `all=false` option from vim.treesitter.query.add_directive,
-- which used to hand each capture to the handler as a single node. nvim-treesitter
-- (master, frozen legacy branch) still registers with `all=false` and indexes
-- `match[id]` as one node, so on 0.12 it receives a node LIST and crashes with
-- "attempt to call method 'range' (a nil value)" whenever a markdown/html code
-- fence injection is parsed (render-markdown, the highlighter, snacks image).
--
-- Re-register the three node-reading directives with `force = true`, made
-- list-safe. Logic (and the alias tables) mirror the upstream handlers.

local q = require("vim.treesitter.query")

-- 0.11+ gives match[id] as a node list; older nvim gives a single node.
local function node_at(match, id)
	local v = match[id]
	if type(v) == "table" then
		return v[#v]
	end
	return v
end

local non_ft_aliases = {
	ex = "elixir",
	pl = "perl",
	sh = "bash",
	uxn = "uxntal",
	ts = "typescript",
}

local html_script_type_languages = {
	importmap = "json",
	module = "javascript",
	["application/ecmascript"] = "javascript",
	["text/ecmascript"] = "javascript",
}

return function()
	-- Ensure upstream registers its (broken) handlers first, so our force=true
	-- overrides win instead of being overwritten by a later lazy require.
	pcall(require, "nvim-treesitter.query_predicates")

	q.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
		local node = node_at(match, pred[2])
		if not node then
			return
		end
		local alias = vim.treesitter.get_node_text(node, bufnr):lower()
		metadata["injection.language"] = vim.filetype.match({ filename = "a." .. alias })
			or non_ft_aliases[alias]
			or alias
	end, { force = true })

	q.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
		local node = node_at(match, pred[2])
		if not node then
			return
		end
		local value = vim.treesitter.get_node_text(node, bufnr)
		local configured = html_script_type_languages[value]
		if configured then
			metadata["injection.language"] = configured
		else
			local parts = vim.split(value, "/", {})
			metadata["injection.language"] = parts[#parts]
		end
	end, { force = true })

	q.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
		local id = pred[2]
		local node = node_at(match, id)
		if not node then
			return
		end
		local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
		if not metadata[id] then
			metadata[id] = {}
		end
		metadata[id].text = string.lower(text)
	end, { force = true })
end
