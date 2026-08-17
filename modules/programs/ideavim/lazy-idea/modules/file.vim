" ========================================
" File/Find Keymaps (<leader>f)
" ========================================

let g:WhichKeyDesc_find_buffers = "<leader>fb Buffers"
nmap <leader>fb <Action>(Switcher)

let g:WhichKeyDesc_find_config = "<leader>fc Find Config File"
nmap <leader>fc <Action>(GotoFile)

let g:WhichKeyDesc_find_files_alt = "<leader>ff Find Files (Root Dir)"
nmap <leader>ff <Action>(GotoFile)

let g:WhichKeyDesc_find_files_cwd = "<leader>fF Find Files (cwd)"
nmap <leader>fF <Action>(GotoFile)

let g:WhichKeyDesc_find_git_files = "<leader>ff Find Files (git-files)"
nmap <leader>ff <Action>(GotoFile)

let g:WhichKeyDesc_find_recent = "<leader>fr Recent"
nmap <leader>fv <Action>(RecentFiles)

let g:WhichKeyDesc_find_recent_cwd = "<leader>fR Recent (cwd)"
nmap <leader>fV <Action>(RecentFiles)

let g:WhichKeyDesc_file_new = "<leader>fn New File"
nmap <leader>fn <Action>(NewElementSamePlace)

let g:WhichKeyDesc_explorer_alt = "<leader>fE Explorer NeoTree (Root Dir)"
nmap <leader>ed :NERDTreeToggle<cr>

let g:WhichKeyDesc_explorer_cwd_alt = "<leader>fe Explorer NeoTree (cwd)"
nmap <leader>ef :NERDTreeFind<cr>

let g:WhichKeyDesc_terminal = "<leader>ft Terminal (Root Dir)"
nmap <leader>ft <Action>(ActivateTerminalToolWindow)

let g:WhichKeyDesc_terminal_cwd = "<leader>fT Terminal (cwd)"
nmap <leader>fT <Action>(ActivateTerminalToolWindow)
