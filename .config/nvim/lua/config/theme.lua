-- Active theme lookup and switching.
--
-- theme-set writes the chosen theme's name to ~/.theme and repoints the
-- symlinks that kitty, tmux, k9s and lazygit read. Reading that same file is
-- what keeps nvim in step; calling theme-set from here is what keeps the
-- rest of the terminal in step when the theme is switched from inside nvim.

local M = {}

M.dotfiles = vim.env.DOTFILES or (vim.env.HOME .. '/.dotfiles')

local STATE = vim.env.HOME .. '/.theme'
local FALLBACK = 'kanagawa'

--- Absolute path to a theme's directory.
function M.dir(name)
    return M.dotfiles .. '/themes/' .. name
end

--- Name of the active theme, e.g. 'kanagawa'.
function M.name()
    local ok, lines = pcall(vim.fn.readfile, STATE)
    if ok and lines and lines[1] then
        local name = vim.trim(lines[1])
        if name ~= '' and vim.uv.fs_stat(M.dir(name)) then
            return name
        end
    end
    return FALLBACK
end

--- Every installed theme, sorted.
function M.list()
    local names = {}
    for entry, kind in vim.fs.dir(M.dotfiles .. '/themes') do
        if kind == 'directory' then
            table.insert(names, entry)
        end
    end
    table.sort(names)
    return names
end

--- Values from a theme's theme.env. Defaults to the active theme.
function M.env(name)
    name = name or M.name()
    local env = {}
    local ok, lines = pcall(vim.fn.readfile, M.dir(name) .. '/theme.env')
    if ok and lines then
        for _, line in ipairs(lines) do
            local k, v = line:match '^(%u[%u_]*)="(.*)"$'
            if k then
                env[k] = v
            end
        end
    end
    return env
end

--- Apply a theme inside this nvim instance, without touching anything else.
--- Keeps the current light/dark background and picks that variant. Some
--- colorschemes (everforest, gruvbox-material) register a single name and
--- switch on 'background', so that has to be set before the colorscheme.
function M.apply(name)
    local env = M.env(name)
    local dark = vim.o.background == 'dark'
    local scheme = dark and env.THEME_DARK_SCHEME or env.THEME_LIGHT_SCHEME
    if not scheme then
        vim.notify('Theme "' .. name .. '" has no theme.env', vim.log.levels.ERROR)
        return false
    end

    vim.o.background = dark and 'dark' or 'light'
    local ok, err = pcall(vim.cmd.colorscheme, scheme)
    if not ok then
        vim.notify('Could not apply "' .. scheme .. '": ' .. tostring(err), vim.log.levels.ERROR)
        return false
    end

    -- Keep the statusline in step; lualine caches its palette per theme.
    local lualine_ok, lualine = pcall(require, 'lualine')
    if lualine_ok and env.THEME_LUALINE then
        pcall(lualine.setup, { options = { theme = env.THEME_LUALINE } })
    end

    -- Re-arm dark-notify so a later appearance change swaps between *this*
    -- theme's variants rather than the previous theme's.
    local dn_ok, dark_notify = pcall(require, 'dark_notify')
    if dn_ok then
        pcall(dark_notify.run, {
            schemes = {
                dark = env.THEME_DARK_SCHEME,
                light = env.THEME_LIGHT_SCHEME,
            },
        })
    end

    return true
end

--- Switch theme everywhere: this nvim instance plus kitty, tmux, k9s and
--- lazygit, by delegating to theme-set.
function M.set(name)
    if not M.apply(name) then
        return
    end

    -- theme-set broadcasts back into every running nvim; tell it to skip
    -- this one, which has already applied the theme above.
    local cmd = { M.dotfiles .. '/theme-set', name }
    local env = { THEME_SET_SKIP_NVIM = vim.v.servername }
    vim.system(cmd, { text = true, env = env }, function(res)
        vim.schedule(function()
            if res.code ~= 0 then
                vim.notify(
                    'theme-set failed: ' .. (res.stderr or ''),
                    vim.log.levels.WARN
                )
            else
                vim.notify('Theme: ' .. (M.env(name).THEME_DISPLAY or name))
            end
        end)
    end)
end

--- Prompt for a theme. Uses vim.ui.select, so it renders through telescope's
--- ui-select extension.
function M.pick()
    local active = M.name()
    local names = M.list()

    vim.ui.select(names, {
        prompt = 'Theme',
        format_item = function(name)
            local display = M.env(name).THEME_DISPLAY or name
            return name == active and (display .. '  (active)') or display
        end,
    }, function(choice)
        if choice and choice ~= active then
            M.set(choice)
        end
    end)
end

return M
