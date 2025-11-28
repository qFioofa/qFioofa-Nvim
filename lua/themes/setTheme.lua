local FOLDER = 'themes.'

local themeName = 'gruvbox-material' -- 'gruvbox-material'
local backupTheme = 'default'

local notify = true

function initThemeConfig()
    local fInit = require(FOLDER .. themeName)
    fInit()
end

function initTheme()
    -- Important to load config BEFORE theme
    initThemeConfig() 
    local success = pcall(vim.cmd, 'colorscheme ' .. themeName)

    if success then return end
    
    if notify then
        vim.notify('Warning: Theme ' .. themeName .. ' not found. Using backup theme: ' .. backupTheme, vim.log.levels.WARN)        
    end
    pcall(vim.cmd, 'colorscheme ' .. backupTheme)    
end

initTheme()
