local Options = {
    gruvbox_material_background = 'soft',
    gruvbox_material_palette = 'original',
    gruvbox_material_enable_italic = 0,
    gruvbox_material_enable_bold = 0,
    gruvbox_material_sign_column_background = 'dark',
    gruvbox_material_statusline_style = 'original',    
    gruvbox_material_disable_background = 0,
    gruvbox_material_ui_contrast = 'high',
    gruvbox_material_cursor = 'auto',
    gruvbox_material_visual = 'orange',
    gruvbox_material_dim_inactive_windows = 0,
    gruvbox_material_colors_override = {
        bg0 = {'#111111', '234' },
        bg1 = {'#111111', '234' },
        bg2 = {'#111111', '235' }
    } 
}

return function()
    for fieldName, value in pairs(Options) do
        vim.g[fieldName] = value
    end
end