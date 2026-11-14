# BINDS.md

> Карта кастомных клавиатурных сокращений этого Neovim-конфига.
>
> Файл генерируется командой `make docs`; не редактируйте его вручную.
> Источник данных — Lua-файлы конфига. Проверка синхронизации: `make check-docs`.

## Легенда

- `<leader>` — пробел (`vim.g.mapleader = " "`).
- Режимы: `n` normal, `i` insert, `v` visual/select, `x` visual block, `o` operator-pending, `t` terminal, `c` command-line, `s` select.
- Область: `глобально`, `buffer: LSP`, `buffer: Java`, `buffer: Ruby`, `nvim-tree`, `dashboard`, `cmp`, `tabout`, `Telescope prompt`, `dapui`.
- В таблицах указаны только маппинги, которые заданы или переопределены этим конфигом; встроенные default-маппинги плагинов не перечислены.

## Сводка

- Кастомных активных маппингов: **211**
- Всего записей, включая неактивные и нейтрализованные: **239**
- Секций: **18**
- Межпрофильных исходников: `common`, `v011`, `v012`

## Редактор, файлы, буферы, окна

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<C-q>` | n | Quit all (force) | глобально | [lua/qfioofa/options/keymaps.lua:58](lua/qfioofa/options/keymaps.lua#L58) |
| `<C-w>` | n | Write file (force) | глобально | [lua/qfioofa/options/keymaps.lua:59](lua/qfioofa/options/keymaps.lua#L59) |
| `<C-s>` | n, i | Write file | глобально | [lua/qfioofa/options/keymaps.lua:60](lua/qfioofa/options/keymaps.lua#L60) |
| `<leader>x` | n | Buffer: close | глобально | [lua/qfioofa/options/keymaps.lua:61](lua/qfioofa/options/keymaps.lua#L61) |
| `<C-;>` | n, v | Enter command mode | глобально | [lua/qfioofa/options/keymaps.lua:62](lua/qfioofa/options/keymaps.lua#L62) |
| `Y` | n | Yank to end of line | глобально | [lua/qfioofa/options/keymaps.lua:63](lua/qfioofa/options/keymaps.lua#L63) |
| `gx` | n | Open link/file under cursor | глобально | [lua/qfioofa/options/keymaps.lua:64](lua/qfioofa/options/keymaps.lua#L64) |
| `<leader>w-` | n | Split: horizontal | глобально | [lua/qfioofa/options/keymaps.lua:67](lua/qfioofa/options/keymaps.lua#L67) |
| `<leader>w|` | n | Split: vertical | глобально | [lua/qfioofa/options/keymaps.lua:68](lua/qfioofa/options/keymaps.lua#L68) |
| `<C-h>` | n | Window: focus left | глобально | [lua/qfioofa/options/keymaps.lua:71](lua/qfioofa/options/keymaps.lua#L71) |
| `<C-j>` | n | Window: focus down | глобально | [lua/qfioofa/options/keymaps.lua:72](lua/qfioofa/options/keymaps.lua#L72) |
| `<C-k>` | n | Window: focus up | глобально | [lua/qfioofa/options/keymaps.lua:73](lua/qfioofa/options/keymaps.lua#L73) |
| `<C-l>` | n | Window: focus right | глобально | [lua/qfioofa/options/keymaps.lua:74](lua/qfioofa/options/keymaps.lua#L74) |
| `<leader>dd` | n | Delete entire buffer | глобально | [lua/qfioofa/options/keymaps.lua:75](lua/qfioofa/options/keymaps.lua#L75) |
| `<leader>yy` | n | Yank entire buffer | глобально | [lua/qfioofa/options/keymaps.lua:76](lua/qfioofa/options/keymaps.lua#L76) |
| `<C-Up>` | n | Resize: decrease height | глобально | [lua/qfioofa/options/keymaps.lua:78](lua/qfioofa/options/keymaps.lua#L78) |
| `<C-Down>` | n | Resize: increase height | глобально | [lua/qfioofa/options/keymaps.lua:79](lua/qfioofa/options/keymaps.lua#L79) |
| `<C-Left>` | n | Resize: increase width | глобально | [lua/qfioofa/options/keymaps.lua:80](lua/qfioofa/options/keymaps.lua#L80) |
| `<C-Right>` | n | Resize: decrease width | глобально | [lua/qfioofa/options/keymaps.lua:81](lua/qfioofa/options/keymaps.lua#L81) |
| `<S-l>` | n | Buffer: next | глобально | [lua/qfioofa/options/keymaps.lua:83](lua/qfioofa/options/keymaps.lua#L83) |
| `<S-h>` | n | Buffer: previous | глобально | [lua/qfioofa/options/keymaps.lua:84](lua/qfioofa/options/keymaps.lua#L84) |
| `<leader>fn` | n | New file | глобально | [lua/qfioofa/options/keymaps.lua:88](lua/qfioofa/options/keymaps.lua#L88) |
| `<leader>uh` | n | Clear search highlight | глобально | [lua/qfioofa/options/keymaps.lua:102](lua/qfioofa/options/keymaps.lua#L102) |
| `<` | v | Indent left (keep selection) | глобально | [lua/qfioofa/options/keymaps.lua:105](lua/qfioofa/options/keymaps.lua#L105) |
| `>` | v | Indent right (keep selection) | глобально | [lua/qfioofa/options/keymaps.lua:106](lua/qfioofa/options/keymaps.lua#L106) |
| `<A-j>` | v | Move line down | глобально | [lua/qfioofa/options/keymaps.lua:108](lua/qfioofa/options/keymaps.lua#L108) |
| `<A-k>` | v | Move line up | глобально | [lua/qfioofa/options/keymaps.lua:109](lua/qfioofa/options/keymaps.lua#L109) |
| `p` | v | Paste without overwriting register | глобально | [lua/qfioofa/options/keymaps.lua:110](lua/qfioofa/options/keymaps.lua#L110) |
| `J` | x | Move selection down | глобально | [lua/qfioofa/options/keymaps.lua:113](lua/qfioofa/options/keymaps.lua#L113) |
| `K` | x | Move selection up | глобально | [lua/qfioofa/options/keymaps.lua:114](lua/qfioofa/options/keymaps.lua#L114) |
| `<A-j>` | x | Move selection down | глобально | [lua/qfioofa/options/keymaps.lua:115](lua/qfioofa/options/keymaps.lua#L115) |
| `<A-k>` | x | Move selection up | глобально | [lua/qfioofa/options/keymaps.lua:116](lua/qfioofa/options/keymaps.lua#L116) |
| `<C-h>` | t | Terminal: focus left window | глобально | [lua/qfioofa/options/keymaps.lua:119](lua/qfioofa/options/keymaps.lua#L119) |
| `<C-j>` | t | Terminal: focus down window | глобально | [lua/qfioofa/options/keymaps.lua:120](lua/qfioofa/options/keymaps.lua#L120) |
| `<C-k>` | t | Terminal: focus up window | глобально | [lua/qfioofa/options/keymaps.lua:121](lua/qfioofa/options/keymaps.lua#L121) |
| `<C-l>` | t | Terminal: focus right window | глобально | [lua/qfioofa/options/keymaps.lua:122](lua/qfioofa/options/keymaps.lua#L122) |
| `<Esc>` | t | Terminal: exit to normal mode | глобально | [lua/qfioofa/options/keymaps.lua:123](lua/qfioofa/options/keymaps.lua#L123) |

## Поиск и навигация

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `s` | n, x, o | Flash | глобально | [lua/qfioofa/plugins/common/flash/keymaps.lua:7](lua/qfioofa/plugins/common/flash/keymaps.lua#L7) |
| `S` | n, x, o | Flash Treesitter | глобально | [lua/qfioofa/plugins/common/flash/keymaps.lua:15](lua/qfioofa/plugins/common/flash/keymaps.lua#L15) |
| `r` | o | Remote Flash | глобально | [lua/qfioofa/plugins/common/flash/keymaps.lua:23](lua/qfioofa/plugins/common/flash/keymaps.lua#L23) |
| `R` | o, x | Treesitter Search | глобально | [lua/qfioofa/plugins/common/flash/keymaps.lua:31](lua/qfioofa/plugins/common/flash/keymaps.lua#L31) |
| `<c-s>` | c | Toggle Flash Search | глобально | [lua/qfioofa/plugins/common/flash/keymaps.lua:39](lua/qfioofa/plugins/common/flash/keymaps.lua#L39) |
| `K` | n | hover.nvim (open) | глобально | [lua/qfioofa/plugins/common/hover/keymaps.lua:5](lua/qfioofa/plugins/common/hover/keymaps.lua#L5) |
| `gK` | n | hover.nvim (enter) | глобально | [lua/qfioofa/plugins/common/hover/keymaps.lua:13](lua/qfioofa/plugins/common/hover/keymaps.lua#L13) |
| `<C-p>` | n | hover.nvim (previous source) | глобально | [lua/qfioofa/plugins/common/hover/keymaps.lua:21](lua/qfioofa/plugins/common/hover/keymaps.lua#L21) |
| `<C-n>` | n | hover.nvim (next source) | глобально | [lua/qfioofa/plugins/common/hover/keymaps.lua:29](lua/qfioofa/plugins/common/hover/keymaps.lua#L29) |
| `<leader>ff` | n | Find Files | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:9](lua/qfioofa/plugins/common/telescope/keymaps.lua#L9) |
| `<leader>fg` | n | Find in Files | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:10](lua/qfioofa/plugins/common/telescope/keymaps.lua#L10) |
| `<leader>fw` | n | Find Word (under cursor) | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:11](lua/qfioofa/plugins/common/telescope/keymaps.lua#L11) |
| `<leader>fb` | n | Find in Buffer | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:13](lua/qfioofa/plugins/common/telescope/keymaps.lua#L13) |
| `<leader>fr` | n | Recent Files | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:17](lua/qfioofa/plugins/common/telescope/keymaps.lua#L17) |
| `<leader>fh` | n | Help Tags | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:18](lua/qfioofa/plugins/common/telescope/keymaps.lua#L18) |
| `<leader>fc` | n | Commands | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:19](lua/qfioofa/plugins/common/telescope/keymaps.lua#L19) |
| `<leader>fk` | n | Keymaps | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:20](lua/qfioofa/plugins/common/telescope/keymaps.lua#L20) |
| `<leader>fl` | n | List Buffers | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:21](lua/qfioofa/plugins/common/telescope/keymaps.lua#L21) |
| `<leader>fs` | n | Treesitter Symbols | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:22](lua/qfioofa/plugins/common/telescope/keymaps.lua#L22) |
| `<leader>fd` | n | Diagnostics | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:23](lua/qfioofa/plugins/common/telescope/keymaps.lua#L23) |
| `<leader>fm` | n | Media Files | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:25](lua/qfioofa/plugins/common/telescope/keymaps.lua#L25) |
| `<leader>gf` | n | Git Files | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:31](lua/qfioofa/plugins/common/telescope/keymaps.lua#L31) |
| `<leader>gs` | n | Git Status | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:32](lua/qfioofa/plugins/common/telescope/keymaps.lua#L32) |
| `<leader>gc` | n | Git Commits | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:33](lua/qfioofa/plugins/common/telescope/keymaps.lua#L33) |
| `<leader>gb` | n | Git Branches | глобально | [lua/qfioofa/plugins/common/telescope/keymaps.lua:34](lua/qfioofa/plugins/common/telescope/keymaps.lua#L34) |

## Git и история

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<leader>gv` | n | Diffview: working tree | глобально | [lua/qfioofa/plugins/common/diffview/keymaps.lua:11](lua/qfioofa/plugins/common/diffview/keymaps.lua#L11) |
| `<leader>gV` | n | Diffview: close | глобально | [lua/qfioofa/plugins/common/diffview/keymaps.lua:15](lua/qfioofa/plugins/common/diffview/keymaps.lua#L15) |
| `<leader>gF` | n | Diffview: file history | глобально | [lua/qfioofa/plugins/common/diffview/keymaps.lua:17](lua/qfioofa/plugins/common/diffview/keymaps.lua#L17) |
| `<leader>gH` | n | Diffview: repo history | глобально | [lua/qfioofa/plugins/common/diffview/keymaps.lua:24](lua/qfioofa/plugins/common/diffview/keymaps.lua#L24) |
| `<leader>go` | n | Diffview: open revision | глобально | [lua/qfioofa/plugins/common/diffview/keymaps.lua:28](lua/qfioofa/plugins/common/diffview/keymaps.lua#L28) |
| `[c` | n | Prev hunk | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:14](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L14) |
| `]c` | n | Next hunk | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:14](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L14) |
| `<leader>hp` | n | Preview hunk | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:46](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L46) |
| `<leader>hi` | n | Preview hunk inline | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:48](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L48) |
| `<leader>hb` | n | Blame line | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:53](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L53) |
| `<leader>hB` | n | Blame file | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:59](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L59) |
| `<leader>hd` | n | Diff this file | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:60](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L60) |
| `<leader>hD` | n | Diff against HEAD~ | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:62](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L62) |
| `<leader>hq` | n | Hunks to quickfix | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:68](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L68) |
| `<leader>hQ` | n | All hunks to quickfix | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:69](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L69) |
| `<leader>hs` | n, v | Stage hunk | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:71](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L71) |
| `<leader>hr` | n, v | Reset hunk | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:77](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L77) |
| `<leader>hS` | n | Stage buffer | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:82](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L82) |
| `<leader>hR` | n | Reset buffer | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:83](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L83) |
| `<leader>hu` | n | Undo stage hunk | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:84](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L84) |
| `ih` | o, x | Select hunk | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:86](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L86) |
| `<leader>tb` | n | Toggle line blame | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:93](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L93) |
| `<leader>tw` | n | Toggle word diff | глобально | [lua/qfioofa/plugins/common/gitsigns/keymaps.lua:98](lua/qfioofa/plugins/common/gitsigns/keymaps.lua#L98) |
| `<leader>lg` | n | LazyGit | глобально | [lua/qfioofa/plugins/common/lazygit/keymaps.lua:2](lua/qfioofa/plugins/common/lazygit/keymaps.lua#L2) |

## LSP и код

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<leader>cf` | n, v | Format buffer/selection | глобально | [lua/qfioofa/plugins/common/conform/keymaps.lua:4](lua/qfioofa/plugins/common/conform/keymaps.lua#L4) |
| `<leader>tl` | n | Toggle LSP (Detach/Reload) | глобально | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:5](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L5) |
| `<leader>to` | n | Open lsp error messages | глобально | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:18](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L18) |
| `<leader>te` | n | Toggle Errors Visibility | глобально | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:25](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L25) |
| `gd` | n | LSP: [G]oto [D]efinition | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:45](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L45) |
| `gr` | n | LSP: [G]oto [R]eferences | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:50](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L50) |
| `gI` | n | LSP: [G]oto [I]mplementation | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:55](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L55) |
| `<leader>D` | n | LSP: Type [D]efinition | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:60](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L60) |
| `<leader>ds` | n | LSP: [D]ocument [S]ymbols | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:65](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L65) |
| `<leader>ws` | n | LSP: [W]orkspace [S]ymbols | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:70](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L70) |
| `<leader>rn` | n | LSP: [R]e[n]ame | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:74](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L74) |
| `<leader>ca` | n | LSP: [C]ode [A]ction | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:75](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L75) |
| `<leader>ca` | v, x | LSP: [C]ode [A]ction (range) | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:81](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L81) |
| `<leader>sh` | n | LSP: [S]ignature [H]elp | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:91](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L91) |
| `gD` | n | LSP: [G]oto [D]eclaration | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:97](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L97) |
| `<leader>cl` | n | LSP: [C]ode [L]ens run | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:102](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L102) |
| `<leader>th` | n | LSP: [T]oggle Inlay [H]ints | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:110](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L110) |
| `<leader>po` | n | LSP: [P]ython [O]rganize imports | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:125](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L125) |
| `<leader>pa` | n | LSP: [P]ython [A]dd missing imports | buffer: LSP | [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:133](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L133) |
| `<leader>sd` | n | Saga: buffer diagnostics (float) | глобально | [lua/qfioofa/plugins/common/lspsaga/keymaps.lua:7](lua/qfioofa/plugins/common/lspsaga/keymaps.lua#L7) |
| `<leader>sw` | n | Saga: workspace diagnostics (float) | глобально | [lua/qfioofa/plugins/common/lspsaga/keymaps.lua:12](lua/qfioofa/plugins/common/lspsaga/keymaps.lua#L12) |
| `<leader>so` | n | Saga: symbols outline | глобально | [lua/qfioofa/plugins/common/lspsaga/keymaps.lua:17](lua/qfioofa/plugins/common/lspsaga/keymaps.lua#L17) |
| `<leader>sf` | n | Saga: finder (refs/defs/impl) | глобально | [lua/qfioofa/plugins/common/lspsaga/keymaps.lua:22](lua/qfioofa/plugins/common/lspsaga/keymaps.lua#L22) |
| `<leader>nd` | n | Generate doc comment | глобально | [lua/qfioofa/plugins/common/neogen/keymaps.lua:2](lua/qfioofa/plugins/common/neogen/keymaps.lua#L2) |
| `<leader>jd` | n | Java: generate Javadoc | глобально | [lua/qfioofa/plugins/common/neogen/keymaps.lua:3](lua/qfioofa/plugins/common/neogen/keymaps.lua#L3) |

## Отладка (DAP)

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<leader>db` | n | Debug: toggle breakpoint | глобально | [lua/qfioofa/plugins/common/dap/init.lua:5](lua/qfioofa/plugins/common/dap/init.lua#L5) |
| `<leader>dc` | n | Debug: continue / start | глобально | [lua/qfioofa/plugins/common/dap/init.lua:10](lua/qfioofa/plugins/common/dap/init.lua#L10) |
| `<leader>do` | n | Debug: step over | глобально | [lua/qfioofa/plugins/common/dap/init.lua:14](lua/qfioofa/plugins/common/dap/init.lua#L14) |
| `<leader>di` | n | Debug: step into | глобально | [lua/qfioofa/plugins/common/dap/init.lua:15](lua/qfioofa/plugins/common/dap/init.lua#L15) |
| `<leader>du` | n | Debug: step out | глобально | [lua/qfioofa/plugins/common/dap/init.lua:16](lua/qfioofa/plugins/common/dap/init.lua#L16) |
| `<leader>dr` | n | Debug: toggle REPL | глобально | [lua/qfioofa/plugins/common/dap/init.lua:17](lua/qfioofa/plugins/common/dap/init.lua#L17) |
| `<leader>dx` | n | Debug: terminate | глобально | [lua/qfioofa/plugins/common/dap/init.lua:18](lua/qfioofa/plugins/common/dap/init.lua#L18) |

## Java (buffer-local)

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<leader>jc` | n | Java: test class | buffer: Java | [lua/qfioofa/languages/java.lua:263](lua/qfioofa/languages/java.lua#L263) |
| `<leader>jm` | n | Java: test nearest method | buffer: Java | [lua/qfioofa/languages/java.lua:264](lua/qfioofa/languages/java.lua#L264) |
| `<leader>jt` | n | Java: pick test | buffer: Java | [lua/qfioofa/languages/java.lua:265](lua/qfioofa/languages/java.lua#L265) |
| `<leader>jo` | n | Java: organize imports | buffer: Java | [lua/qfioofa/languages/java.lua:266](lua/qfioofa/languages/java.lua#L266) |
| `<leader>jp` | n | Java: reload project config | buffer: Java | [lua/qfioofa/languages/java.lua:267](lua/qfioofa/languages/java.lua#L267) |
| `<leader>jb` | n | Java: build workspace | buffer: Java | [lua/qfioofa/languages/java.lua:268](lua/qfioofa/languages/java.lua#L268) |
| `<leader>js` | n | Java: extended symbols (incl. inherited) | buffer: Java | [lua/qfioofa/languages/java.lua:269](lua/qfioofa/languages/java.lua#L269) |
| `<leader>jS` | n | Java: go to super implementation | buffer: Java | [lua/qfioofa/languages/java.lua:270](lua/qfioofa/languages/java.lua#L270) |

## Ruby / Rails (buffer-local)

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<leader>rr` | n | Ruby: run file | buffer: Ruby | [lua/qfioofa/languages/ruby.lua:12](lua/qfioofa/languages/ruby.lua#L12) |
| `<leader>rt` | n | Rails: run tests | buffer: Ruby | [lua/qfioofa/languages/ruby.lua:16](lua/qfioofa/languages/ruby.lua#L16) |
| `<leader>rn` | n | Rails: run nearest test | buffer: Ruby | [lua/qfioofa/languages/ruby.lua:20](lua/qfioofa/languages/ruby.lua#L20) |
| `<leader>rg` | n | Rails: generate | buffer: Ruby | [lua/qfioofa/languages/ruby.lua:24](lua/qfioofa/languages/ruby.lua#L24) |
| `<leader>rs` | n | Rails: server | buffer: Ruby | [lua/qfioofa/languages/ruby.lua:31](lua/qfioofa/languages/ruby.lua#L31) |
| `<leader>rc` | n | Rails: console | buffer: Ruby | [lua/qfioofa/languages/ruby.lua:35](lua/qfioofa/languages/ruby.lua#L35) |
| `<leader>rk` | n | Rubocop: autocorrect file | buffer: Ruby | [lua/qfioofa/languages/ruby.lua:42](lua/qfioofa/languages/ruby.lua#L42) |
| `<leader>rd` | n | Ruby: debug file | buffer: Ruby | [lua/qfioofa/languages/ruby.lua:46](lua/qfioofa/languages/ruby.lua#L46) |
| `<leader>rb` | n | RSpec: run nearest spec | buffer: Ruby | [lua/qfioofa/languages/ruby.lua:50](lua/qfioofa/languages/ruby.lua#L50) |
| `<leader>ra` | n | RSpec: run all specs | buffer: Ruby | [lua/qfioofa/languages/ruby.lua:54](lua/qfioofa/languages/ruby.lua#L54) |

## Дерево файлов (nvim-tree)

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<CR>` | n | nvim-tree: Open | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:10](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L10) |
| `w` | n | nvim-tree: Open | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:10](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L10) |
| `h` | n | nvim-tree: Close folder | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:15](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L15) |
| `<BS>` | n | nvim-tree: Close folder | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:20](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L20) |
| `<Tab>` | n | nvim-tree: Preview file | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:35](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L35) |
| `<C-]>` | n | nvim-tree: CD into folder | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:37](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L37) |
| `-` | n | nvim-tree: CD up | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:41](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L41) |
| `+` | n | nvim-tree: Create file/folder | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:44](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L44) |
| `r` | n | nvim-tree: Rename | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:46](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L46) |
| `<C-r>` | n | nvim-tree: Rename: full path | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:47](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L47) |
| `x` | n | nvim-tree: Cut | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:48](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L48) |
| `C` | n | nvim-tree: Copy relative path | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:53](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L53) |
| `Y` | n | nvim-tree: Copy absolute path | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:58](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L58) |
| `E` | n | nvim-tree: Expand all | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:64](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L64) |
| `W` | n | nvim-tree: Collapse all | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:65](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L65) |
| `R` | n | nvim-tree: Refresh tree | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:66](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L66) |
| `H` | n | nvim-tree: Toggle hidden files | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:68](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L68) |
| `I` | n | nvim-tree: Toggle git ignored | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:73](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L73) |
| `f` | n | nvim-tree: Live filter | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:77](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L77) |
| `F` | n | nvim-tree: Clear live filter | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:78](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L78) |
| `S` | n | nvim-tree: Search | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:79](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L79) |
| `K` | n | nvim-tree: File info | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:80](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L80) |
| `g?` | n | nvim-tree: Show help | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:81](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L81) |
| `q` | n | nvim-tree: Close tree | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:82](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L82) |
| `bd` | n | nvim-tree: Delete bookmarked | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:86](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L86) |
| `bm` | n | nvim-tree: Move bookmarked | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:87](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L87) |
| `a` | n | nvim-tree: Create file/folder | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:127](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L127) |
| `c` | n | nvim-tree: Copy filename | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:127](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L127) |
| `d` | n | nvim-tree: Delete | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:127](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L127) |
| `m` | n | nvim-tree: Toggle bookmark | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:127](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L127) |
| `o` | n | nvim-tree: Open | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:127](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L127) |
| `p` | n | nvim-tree: Paste | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:127](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L127) |
| `s` | n | nvim-tree: Open: horizontal split | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:127](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L127) |
| `t` | n | nvim-tree: Open: new tab | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:127](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L127) |
| `v` | n | nvim-tree: Open: vertical split | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:127](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L127) |
| `y` | n | nvim-tree: Copy | nvim-tree | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:127](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L127) |
| `<C-e>` | n | Toggle file tree | глобально | [lua/qfioofa/plugins/common/nvim-tree/keymaps.lua:135](lua/qfioofa/plugins/common/nvim-tree/keymaps.lua#L135) |

## Dashboard (snacks)

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `f` | n | Find File | dashboard | [lua/qfioofa/plugins/common/snacks/options.lua:131](lua/qfioofa/plugins/common/snacks/options.lua#L131) |
| `n` | n | New File | dashboard | [lua/qfioofa/plugins/common/snacks/options.lua:137](lua/qfioofa/plugins/common/snacks/options.lua#L137) |
| `g` | n | Find Text | dashboard | [lua/qfioofa/plugins/common/snacks/options.lua:143](lua/qfioofa/plugins/common/snacks/options.lua#L143) |
| `r` | n | Recent Files | dashboard | [lua/qfioofa/plugins/common/snacks/options.lua:149](lua/qfioofa/plugins/common/snacks/options.lua#L149) |
| `c` | n | Config | dashboard | [lua/qfioofa/plugins/common/snacks/options.lua:155](lua/qfioofa/plugins/common/snacks/options.lua#L155) |
| `q` | n | Quit | dashboard | [lua/qfioofa/plugins/common/snacks/options.lua:160](lua/qfioofa/plugins/common/snacks/options.lua#L160) |

## Терминал (toggleterm)

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<leader>tt` | n | Terminal: floating | глобально | [lua/qfioofa/plugins/common/toggleterm/keymaps.lua:5](lua/qfioofa/plugins/common/toggleterm/keymaps.lua#L5) |
| `<leader>th` | n | Terminal: horizontal split | глобально | [lua/qfioofa/plugins/common/toggleterm/keymaps.lua:11](lua/qfioofa/plugins/common/toggleterm/keymaps.lua#L11) |
| `<leader>tv` | n | Terminal: vertical split | глобально | [lua/qfioofa/plugins/common/toggleterm/keymaps.lua:17](lua/qfioofa/plugins/common/toggleterm/keymaps.lua#L17) |

## UI и уведомления

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<S-Enter>` | c | Redirect Cmdline | глобально | [lua/qfioofa/plugins/common/noice/keymaps.lua:4](lua/qfioofa/plugins/common/noice/keymaps.lua#L4) |
| `<leader>nl` | n | Noice Last Message | глобально | [lua/qfioofa/plugins/common/noice/keymaps.lua:12](lua/qfioofa/plugins/common/noice/keymaps.lua#L12) |
| `<leader>nh` | n | Noice History | глобально | [lua/qfioofa/plugins/common/noice/keymaps.lua:19](lua/qfioofa/plugins/common/noice/keymaps.lua#L19) |
| `<leader>na` | n | Noice All | глобально | [lua/qfioofa/plugins/common/noice/keymaps.lua:26](lua/qfioofa/plugins/common/noice/keymaps.lua#L26) |
| `<leader>un` | n | Dismiss All Notifications | глобально | [lua/qfioofa/plugins/common/notify/keymaps.lua:3](lua/qfioofa/plugins/common/notify/keymaps.lua#L3) |

## Сессии и auto-save

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<leader>as` | n | Toggle auto-save | глобально | [lua/qfioofa/plugins/common/auto-save/keymaps.lua:3](lua/qfioofa/plugins/common/auto-save/keymaps.lua#L3) |
| `<leader>ss` | n | Session: save | глобально | [lua/qfioofa/plugins/common/auto-session/keymaps.lua:4](lua/qfioofa/plugins/common/auto-session/keymaps.lua#L4) |
| `<leader>sr` | n | Session: restore | глобально | [lua/qfioofa/plugins/common/auto-session/keymaps.lua:5](lua/qfioofa/plugins/common/auto-session/keymaps.lua#L5) |

## Markdown, undo и прочее

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<leader>tm` | n | Toggle markdown render | глобально | [lua/qfioofa/plugins/common/render-markdown/init.lua:29](lua/qfioofa/plugins/common/render-markdown/init.lua#L29) |
| `<leader>U` | n | [U]ndo tree | глобально | [lua/qfioofa/plugins/common/undotree/init.lua:7](lua/qfioofa/plugins/common/undotree/init.lua#L7) |

## Внутренние маппинги плагинов

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<C-k>` | i, c | Выбрать предыдущий пункт | cmp | [lua/qfioofa/plugins/common/cmp/options.lua:40](lua/qfioofa/plugins/common/cmp/options.lua#L40) |
| `<C-j>` | i, c | Выбрать следующий пункт | cmp | [lua/qfioofa/plugins/common/cmp/options.lua:41](lua/qfioofa/plugins/common/cmp/options.lua#L41) |
| `<C-b>` | i, c | Прокрутить документацию вверх | cmp | [lua/qfioofa/plugins/common/cmp/options.lua:42](lua/qfioofa/plugins/common/cmp/options.lua#L42) |
| `<C-f>` | i, c | Прокрутить документацию вниз | cmp | [lua/qfioofa/plugins/common/cmp/options.lua:43](lua/qfioofa/plugins/common/cmp/options.lua#L43) |
| `<C-Space>` | i, c | Запустить completion | cmp | [lua/qfioofa/plugins/common/cmp/options.lua:44](lua/qfioofa/plugins/common/cmp/options.lua#L44) |
| `<C-y>` | i, c | Отключено (cmp.config.disable) | cmp | [lua/qfioofa/plugins/common/cmp/options.lua:45](lua/qfioofa/plugins/common/cmp/options.lua#L45) |
| `<C-e>` | i, c | Прервать / закрыть меню | cmp | [lua/qfioofa/plugins/common/cmp/options.lua:46](lua/qfioofa/plugins/common/cmp/options.lua#L46) |
| `<CR>` | i, c | Подтвердить выбранный пункт | cmp | [lua/qfioofa/plugins/common/cmp/options.lua:50](lua/qfioofa/plugins/common/cmp/options.lua#L50) |
| `<Tab>` | i, s | Следующий пункт / jump по сниппету | cmp | [lua/qfioofa/plugins/common/cmp/options.lua:51](lua/qfioofa/plugins/common/cmp/options.lua#L51) |
| `<S-Tab>` | i, s | Предыдущий пункт / jump назад | cmp | [lua/qfioofa/plugins/common/cmp/options.lua:65](lua/qfioofa/plugins/common/cmp/options.lua#L65) |
| `<Tab>` | i | Выйти из пары/скобки вперёд | tabout | [lua/qfioofa/plugins/common/tabout/options.lua:2](lua/qfioofa/plugins/common/tabout/options.lua#L2) |
| `<S-Tab>` | i | Выйти из пары/скобки назад | tabout | [lua/qfioofa/plugins/common/tabout/options.lua:3](lua/qfioofa/plugins/common/tabout/options.lua#L3) |
| `<C-t>` | i | Обычный Tab | tabout | [lua/qfioofa/plugins/common/tabout/options.lua:6](lua/qfioofa/plugins/common/tabout/options.lua#L6) |
| `<C-d>` | i | Обычный Shift-Tab | tabout | [lua/qfioofa/plugins/common/tabout/options.lua:7](lua/qfioofa/plugins/common/tabout/options.lua#L7) |
| `<C-u>` | i | Прокрутить preview вверх | Telescope prompt | [lua/qfioofa/plugins/common/telescope/options.lua:32](lua/qfioofa/plugins/common/telescope/options.lua#L32) |
| `<C-d>` | i | Прокрутить preview вниз | Telescope prompt | [lua/qfioofa/plugins/common/telescope/options.lua:33](lua/qfioofa/plugins/common/telescope/options.lua#L33) |
| `<C-q>` | i | Отправить в quickfix и открыть | Telescope prompt | [lua/qfioofa/plugins/common/telescope/options.lua:34](lua/qfioofa/plugins/common/telescope/options.lua#L34) |
| `<esc>` | i | Закрыть Telescope | Telescope prompt | [lua/qfioofa/plugins/common/telescope/options.lua:35](lua/qfioofa/plugins/common/telescope/options.lua#L35) |
| `<C-x>` | i | Удалить буфер (buffers picker) | Telescope prompt | [lua/qfioofa/plugins/common/telescope/options.lua:56](lua/qfioofa/plugins/common/telescope/options.lua#L56) |

## Намеренно нейтрализованные клавиши

Эти клавиши намеренно отключены, чтобы не ждать `timeoutlen` или не конфликтовать с другим префиксом.

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<Space>` | n, x, s, o | Намеренно отключено | глобально | [lua/qfioofa/options/keymaps.lua:53](lua/qfioofa/options/keymaps.lua#L53) |
| `<C-w>d` | n | Намеренно отключено | глобально | [lua/qfioofa/options/keymaps.lua:132](lua/qfioofa/options/keymaps.lua#L132) |
| `<C-w><C-d>` | n | Намеренно отключено | глобально | [lua/qfioofa/options/keymaps.lua:133](lua/qfioofa/options/keymaps.lua#L133) |

## Неактивные / мёртвые маппинги

Файлы/опции существуют в репозитории, но не подключены к активному конфигу. Раздел нужен, чтобы мёртвый код не терялся из виду.

| Клавиши | Режим | Описание | Область | Источник |
| --- | --- | --- | --- | --- |
| `<leader>bb` | n | Toggle breakpoint *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:12](lua/qfioofa/plugins/common/dap/keymaps.lua#L12) |
| `<leader>bc` | n | Conditional breakpoint *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:13](lua/qfioofa/plugins/common/dap/keymaps.lua#L13) |
| `<leader>bl` | n | Log point *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:16](lua/qfioofa/plugins/common/dap/keymaps.lua#L16) |
| `<leader>br` | n | Clear breakpoints *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:19](lua/qfioofa/plugins/common/dap/keymaps.lua#L19) |
| `<leader>ba` | n | List breakpoints *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:21](lua/qfioofa/plugins/common/dap/keymaps.lua#L21) |
| `<leader>dc` | n | Continue / Start *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:27](lua/qfioofa/plugins/common/dap/keymaps.lua#L27) |
| `<leader>dj` | n | Step over *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:28](lua/qfioofa/plugins/common/dap/keymaps.lua#L28) |
| `<leader>dk` | n | Step into *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:29](lua/qfioofa/plugins/common/dap/keymaps.lua#L29) |
| `<leader>do` | n | Step out *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:30](lua/qfioofa/plugins/common/dap/keymaps.lua#L30) |
| `<leader>dr` | n | Toggle REPL *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:31](lua/qfioofa/plugins/common/dap/keymaps.lua#L31) |
| `<leader>dl` | n | Run last *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:32](lua/qfioofa/plugins/common/dap/keymaps.lua#L32) |
| `<leader>dx` | n | Disconnect *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:33](lua/qfioofa/plugins/common/dap/keymaps.lua#L33) |
| `<leader>dt` | n | Terminate *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:37](lua/qfioofa/plugins/common/dap/keymaps.lua#L37) |
| `<leader>di` | n | Hover variable *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:43](lua/qfioofa/plugins/common/dap/keymaps.lua#L43) |
| `<leader>d?` | n | Scopes *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:46](lua/qfioofa/plugins/common/dap/keymaps.lua#L46) |
| `<leader>df` | n | Frames *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:50](lua/qfioofa/plugins/common/dap/keymaps.lua#L50) |
| `<leader>dh` | n | Commands *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:51](lua/qfioofa/plugins/common/dap/keymaps.lua#L51) |
| `<leader>du` | n | Toggle DAP UI *(неактивно)* | глобально | [lua/qfioofa/plugins/common/dap/keymaps.lua:52](lua/qfioofa/plugins/common/dap/keymaps.lua#L52) |
| `e` | n | dapui: edit *(неактивно)* | dapui | [lua/qfioofa/plugins/common/dap/options.lua:50](lua/qfioofa/plugins/common/dap/options.lua#L50) |
| `<2-LeftMouse>` | n | dapui: expand *(неактивно)* | dapui | [lua/qfioofa/plugins/common/dap/options.lua:51](lua/qfioofa/plugins/common/dap/options.lua#L51) |
| `<CR>` | n | dapui: expand *(неактивно)* | dapui | [lua/qfioofa/plugins/common/dap/options.lua:51](lua/qfioofa/plugins/common/dap/options.lua#L51) |
| `o` | n | dapui: open *(неактивно)* | dapui | [lua/qfioofa/plugins/common/dap/options.lua:52](lua/qfioofa/plugins/common/dap/options.lua#L52) |
| `d` | n | dapui: remove *(неактивно)* | dapui | [lua/qfioofa/plugins/common/dap/options.lua:53](lua/qfioofa/plugins/common/dap/options.lua#L53) |
| `r` | n | dapui: repl *(неактивно)* | dapui | [lua/qfioofa/plugins/common/dap/options.lua:54](lua/qfioofa/plugins/common/dap/options.lua#L54) |
| `t` | n | dapui: toggle *(неактивно)* | dapui | [lua/qfioofa/plugins/common/dap/options.lua:55](lua/qfioofa/plugins/common/dap/options.lua#L55) |

## which-key: группы префиксов

| Префикс | Группа | Источник |
| --- | --- | --- |
| `<leader>f` | Find | [lua/qfioofa/plugins/common/which-key/options.lua:8](lua/qfioofa/plugins/common/which-key/options.lua#L8) |
| `<leader>g` | Git / Diff / Goto | [lua/qfioofa/plugins/common/which-key/options.lua:9](lua/qfioofa/plugins/common/which-key/options.lua#L9) |
| `<leader>h` | Git hunks | [lua/qfioofa/plugins/common/which-key/options.lua:10](lua/qfioofa/plugins/common/which-key/options.lua#L10) |
| `<leader>c` | Code | [lua/qfioofa/plugins/common/which-key/options.lua:11](lua/qfioofa/plugins/common/which-key/options.lua#L11) |
| `<leader>d` | Diagnostics / Debug / Delete | [lua/qfioofa/plugins/common/which-key/options.lua:12](lua/qfioofa/plugins/common/which-key/options.lua#L12) |
| `<leader>t` | Toggle / Terminal | [lua/qfioofa/plugins/common/which-key/options.lua:13](lua/qfioofa/plugins/common/which-key/options.lua#L13) |
| `<leader>j` | Java | [lua/qfioofa/plugins/common/which-key/options.lua:14](lua/qfioofa/plugins/common/which-key/options.lua#L14) |
| `<leader>n` | Noice | [lua/qfioofa/plugins/common/which-key/options.lua:15](lua/qfioofa/plugins/common/which-key/options.lua#L15) |
| `<leader>r` | Rename / Ruby | [lua/qfioofa/plugins/common/which-key/options.lua:16](lua/qfioofa/plugins/common/which-key/options.lua#L16) |
| `<leader>w` | Workspace / Write | [lua/qfioofa/plugins/common/which-key/options.lua:17](lua/qfioofa/plugins/common/which-key/options.lua#L17) |
| `<leader>u` | UI / Notify | [lua/qfioofa/plugins/common/which-key/options.lua:18](lua/qfioofa/plugins/common/which-key/options.lua#L18) |
| `<leader>l` | LazyGit | [lua/qfioofa/plugins/common/which-key/options.lua:19](lua/qfioofa/plugins/common/which-key/options.lua#L19) |
| `<leader>s` | LSP (Saga) / Session | [lua/qfioofa/plugins/common/which-key/options.lua:20](lua/qfioofa/plugins/common/which-key/options.lua#L20) |
| `<leader>a` | Auto-save | [lua/qfioofa/plugins/common/which-key/options.lua:21](lua/qfioofa/plugins/common/which-key/options.lua#L21) |
| `<leader>p` | Python | [lua/qfioofa/plugins/common/which-key/options.lua:22](lua/qfioofa/plugins/common/which-key/options.lua#L22) |
| `<leader>y` | Yank | [lua/qfioofa/plugins/common/which-key/options.lua:23](lua/qfioofa/plugins/common/which-key/options.lua#L23) |

## Пересечения клавиш

| Клавиши | Режим | Контексты | Что перекрывается | Статус |
| --- | --- | --- | --- | --- |
| `<S-Tab>` | i | cmp, tabout | Предыдущий пункт / jump назад — [lua/qfioofa/plugins/common/cmp/options.lua:65](lua/qfioofa/plugins/common/cmp/options.lua#L65)<br>Выйти из пары/скобки назад — [lua/qfioofa/plugins/common/tabout/options.lua:3](lua/qfioofa/plugins/common/tabout/options.lua#L3) | известно: cmp и tabout оба переопределяют S-Tab в insert; проверить порядок загрузки |
| `<Tab>` | i | cmp, tabout | Следующий пункт / jump по сниппету — [lua/qfioofa/plugins/common/cmp/options.lua:51](lua/qfioofa/plugins/common/cmp/options.lua#L51)<br>Выйти из пары/скобки вперёд — [lua/qfioofa/plugins/common/tabout/options.lua:2](lua/qfioofa/plugins/common/tabout/options.lua#L2) | известно: cmp и tabout оба переопределяют Tab в insert; проверить порядок загрузки |
| `<leader>rn` | n | lsp, ruby | LSP: [R]e[n]ame — [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:74](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L74)<br>Rails: run nearest test — [lua/qfioofa/languages/ruby.lua:20](lua/qfioofa/languages/ruby.lua#L20) | известно: LSP rename перекрывается Ruby Rails nearest test |
| `<leader>th` | n | global, lsp | LSP: [T]oggle Inlay [H]ints — [lua/qfioofa/plugins/common/lspconfig/keymaps.lua:110](lua/qfioofa/plugins/common/lspconfig/keymaps.lua#L110)<br>Terminal: horizontal split — [lua/qfioofa/plugins/common/toggleterm/keymaps.lua:11](lua/qfioofa/plugins/common/toggleterm/keymaps.lua#L11) | известно: toggleterm horizontal split перекрывается buffer-local LSP inlay hints |

## Как обновлять

1. Измените Lua-конфиг.
2. Запустите `make docs`.
3. Проверьте diff в `BINDS.md` и `AGENTS.md`.
4. Запустите `make check-docs` (в CI это делается автоматически).

Если маппинг задан через option-таблицу плагина (cmp, tabout, Telescope prompt, dapui), обновите `scripts/docs/meta.lua`: генератор специально падает, если описание или набор клавиш там устарели.
