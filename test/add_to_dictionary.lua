local load_file = require("test.utils").load_file
local spawn_window = require("test.utils").spawn_window


---@type string
local test_filename = vim.fs.normalize("./test/assets/main.md")


---@alias TestCase {[string]:{row: integer, col: integer}}
---@type TestCase[]
local test_cases = {
    addToDictionary = { 9, 10 },
    hideFalsePositive = { 13, 0 },
    disableRule = { 17, 9 }
}


-- Load test assset.
local test_bufnr = load_file(test_filename)
assert(test_bufnr ~= nil, string.format("Error loading %s in new buffer", test_filename))
local test_winid = spawn_window(test_bufnr)

-- Go to position.
vim.api.nvim_win_set_cursor(test_winid, test_cases.addToDictionary)

-- Execute command.
---@type vim.lsp.buf.code_action.Opts
local code_action_opts = {
    filter = function(action)
        return action.kind == "quickfix.ltex.addToDictionary"
    end,
    apply = true,
}
vim.lsp.buf.code_action(code_action_opts)


-- Code action passed to the code action filter
--
-- {
--   command = {
--     arguments = { {
--         uri = "file:///home/leonardo/develop/ltex_extra.nvim/test/assets/main.md",
--         words = {
--           ["en-us"] = { "missspelling" }
--         }
--       } },
--     command = "_ltex.addToDictionary",
--     title = "Add 'missspelling' to dictionary"
--   },
--   diagnostics = { {
--       code = "MORFOLOGIK_RULE_EN_US",
--       codeDescription = {
--         href = "https://community.languagetool.org/rule/show/MORFOLOGIK_RULE_EN_US?lang=en-us"
--       },
--       message = "'missspelling': Possible spelling mistake found.",
--       range = {
--         ["end"] = {
--           character = 22,
--           line = 8
--         },
--         start = {
--           character = 10,
--           line = 8
--         }
--       },
--       severity = 3,
--       source = "LTeX"
--     } },
--   kind = "quickfix.ltex.addToDictionary",
--   title = "Add 'missspelling' to dictionary"
-- }