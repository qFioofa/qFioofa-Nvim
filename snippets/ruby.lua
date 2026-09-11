-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
--
-- Ruby / Rails snippets. Loaded only for `ruby` / `eruby` filetype via the
-- from_lua loader. Triggers that already exist in friendly-snippets are
-- left as comments below so the intent is clear — their snippets win by
-- `override_priority` and there is no point re-declaring them.

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- ---------------------------------------------------------------------------
-- CONFLICTING (friendly-snippets already covers these):
--   def, defs, class, class init, module, if, ife, unless, do, dop, case,
--   req, pry, debug, bye, irb, desc, cont, it, let, let!, bef, allow,
--   shared, ibl, subj, exp, rdesc, each (ead/ea), eachi (eawid/eawi),
--   map (mapd/map), reduce (redd/red)
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- Ruby core (no conflict)
-- ---------------------------------------------------------------------------

s("deft", fmt([[
def test_{}_{}({})
	{}
end
]], { i(1, "feature"), i(2, "name"), i(3), i(4) })),

s("defi", fmt([[
def initialize({})
	{}
end
]], { i(1), i(2) })),

s("puts", fmt("puts {}", { i(1, "variable") })),

s("p", fmt("p {}", { i(1, "variable") })),

s("pp", fmt("pp {}", { i(1, "variable") })),

s("logd", fmt('Rails.logger.debug "{}"', { i(1, "message") })),

s("logi", fmt('Rails.logger.info "{}"', { i(1, "message") })),

s("loge", fmt('Rails.logger.error "{}"', { i(1, "message") })),

s("rescue", fmt([[
rescue {} => e
	{}
end
]], { i(1, "StandardError"), i(2) })),

s("rescue_all", fmt([[
rescue => e
	{}
end
]], { i(1) })),

s("classi", fmt([[
class {} < {}{}
	def initialize({})
		{}
	end
end
]], { i(1, "ClassName"), i(2, "ApplicationRecord"), i(3), i(4), i(5) })),

s("modulec", fmt([[
module {}{}
	class {} < {}{}
		{}
	end
end
]], { i(1, "Module"), i(2), i(3, "ClassName"), i(4, "ApplicationRecord"), i(5), i(6) })),

s("lambda", fmt("->({}) {{ {} }}", { i(1), i(2) })),

s("lamd", fmt([[
lambda do |{}|
	{}
end
]], { i(1), i(2) })),

s("tap", fmt([[
{}.tap do |{}|
	{}
end
]], { i(1, "object"), i(2, "obj"), i(3) })),

s("each_with_object", fmt([[
{}.each_with_object({}) do |{}, {}|
	{}
end
]], { i(1, "collection"), i(2, "memo"), i(3, "item"), i(4, "memo"), i(5) })),

-- ---------------------------------------------------------------------------
-- Minitest
-- ---------------------------------------------------------------------------

s("test", fmt([[
test "{}" do
	{}
end
]], { i(1, "test name"), i(2) })),

s("testf", fmt([[
test "{}" do
	assert_{}({}, {})
end
]], { i(1, "test name"), i(2, "equal"), i(3, "expected"), i(4, "actual") })),

-- ---------------------------------------------------------------------------
-- Rails: associations
-- ---------------------------------------------------------------------------

s("hm", fmt("has_many :{}", { i(1, "items") })),

s("ho", fmt("has_one :{}", { i(1, "item") })),

s("bt", fmt("belongs_to :{}", { i(1, "parent") })),

s("hmt", fmt([[
has_many :{}, through: :{}
]], { i(1, "items"), i(2, "source") })),

s("habtm", fmt([[
has_and_belongs_to_many :{}
]], { i(1, "items") })),

-- ---------------------------------------------------------------------------
-- Rails: validations
-- ---------------------------------------------------------------------------

s("vo", fmt("validates :{}, presence: true", { i(1, "field") })),

s("von", fmt("validates :{}, numericality: true", { i(1, "field") })),

s("vou", fmt("validates :{}, uniqueness: true", { i(1, "field") })),

s("vol", fmt("validates :{}, length: {{ maximum: {} }}", { i(1, "field"), i(2, "255") })),

s("vof", fmt("validates :{}, format: {{ with: {} }}", { i(1, "field"), i(2, "URI::DEFAULT_PARSER.make_regexp") })),

-- ---------------------------------------------------------------------------
-- Rails: callbacks
-- ---------------------------------------------------------------------------

s("ba", fmt("before_action :{}", { i(1, "method_name") })),

s("bao", fmt("before_action :{}, only: [:{}]", { i(1, "method_name"), i(2, "index") })),

s("ban", fmt("before_action :{}, except: [:{}]", { i(1, "method_name"), i(2, "index") })),

s("aa", fmt("after_action :{}", { i(1, "method_name") })),

s("ac", fmt("after_commit :{}", { i(1, "method_name") })),

s("acu", fmt("after_create :{}", { i(1, "method_name") })),

s("au", fmt("after_update :{}", { i(1, "method_name") })),

s("ad", fmt("after_destroy :{}", { i(1, "method_name") })),

-- ---------------------------------------------------------------------------
-- Rails: scopes / query
-- ---------------------------------------------------------------------------

s("scope", fmt("scope :{}, -> {{ {} }}", { i(1, "name"), i(2, "where(active: true)") })),

s("dq", fmt([[
{}.find_by({})
]], { i(1, "Model"), i(2, "field: value") })),

s("dw", fmt([[
{}.where({})
]], { i(1, "Model"), i(2, "field: value") })),

-- ---------------------------------------------------------------------------
-- Rails: controllers / views
-- ---------------------------------------------------------------------------

s("renderj", fmt("render json: @{}", { i(1, "resource") })),

s("renderh", fmt("render html: @{}", { i(1, "resource") })),

s("rendert", fmt("render :{}", { i(1, "template") })),

s("renderp", fmt("render partial: '{}'", { i(1, "form") })),

s("redir", fmt("redirect_to {}", { i(1, "root_path") })),

s("redirf", fmt([[
redirect_to {}, notice: "{}"
]], { i(1, "root_path"), i(2, "Done!") })),

s("redirw", fmt([[
redirect_to {}, alert: "{}"
]], { i(1, "root_path"), i(2, "Something went wrong") })),

s("permit", fmt("params.require(:{}).permit({})", { i(1, "model"), i(2, ":field") })),

-- ---------------------------------------------------------------------------
-- Rails: migrations
-- ---------------------------------------------------------------------------

s("mc", fmt([[
class Create{} < ActiveRecord::Migration[7.1]
	def change
		create_table :{} do |t|
			{}
			t.timestamps
		end
	end
end
]], { i(1, "TableName"), i(2, "table_name"), i(3) })),

s("mac", fmt([[
class Add{}To{} < ActiveRecord::Migration[7.1]
	def change
		add_column :{}, :{}, :{}
	end
end
]], { i(1, "Field"), i(2, "TableName"), i(3, "table_name"), i(4, "field_name"), i(5, "string") })),

s("marem", fmt([[
class Remove{}From{} < ActiveRecord::Migration[7.1]
	def change
		remove_column :{}, :{}
	end
end
]], { i(1, "Field"), i(2, "TableName"), i(3, "table_name"), i(4, "field_name") })),

s("mat", fmt([[
class Create{} < ActiveRecord::Migration[7.1]
	def change
		create_table :{}_{} do |t|
			t.references :{}, null: false, foreign_key: true
			t.timestamps
		end
	end
end
]], { i(1, "JoinTable"), i(2, "model_a"), i(3, "model_b"), i(4, "model_a") })),

-- ---------------------------------------------------------------------------
-- RSpec: Rails-specific (non-conflicting triggers only)
-- ---------------------------------------------------------------------------

s("fact", fmt([[
factory :{} do
	{}
end
]], { i(1, "model_name"), i(2) })),

s("letj", fmt([[
let(:{}) {{ build(:{}) }}
]], { i(1, "object"), i(2, "model_name") })),

s("createj", fmt([[
let(:{}) {{ create(:{}) }}
]], { i(1, "object"), i(2, "model_name") })),

s("desmod", fmt([[
describe {} do
	{}
end
]], { i(1, "Model"), i(2) })),

s("descon", fmt([[
describe '{}' do
	context 'when {}' do
		{}
	end
end
]], { i(1, "#method"), i(2, "condition"), i(3) })),
