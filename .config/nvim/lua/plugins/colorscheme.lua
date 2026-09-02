-- Colorschemes.
--
-- Every theme's plugin is declared so it is installed and available, but
-- only the active one loads at startup; the rest stay lazy until something
-- asks for them (switching theme with <leader>uc, or dark-notify swapping
-- between a theme's light and dark variants).
--
-- The active theme is whatever ~/.theme contains, written by theme-set.

local theme = require 'config.theme'
local active = theme.name()

local specs = {}

for _, name in ipairs(theme.list()) do
    local ok, spec = pcall(dofile, theme.dir(name) .. '/colorscheme.lua')
    if ok then
        -- Only the active theme loads eagerly and applies itself; the others
        -- are installed but idle, so switching does not have to fetch them.
        if name ~= active then
            spec.lazy = true
            spec.priority = nil
            spec.config = spec.config or true
            spec.dependencies = nil
        end
        table.insert(specs, spec)
    else
        vim.notify('Theme "' .. name .. '" failed to load: ' .. tostring(spec), vim.log.levels.WARN)
    end
end

return specs
