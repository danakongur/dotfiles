
" The default vimrc file.
"
" Maintainer:	The Vim Project <https://github.com/vim/vim>
" Last Change:	2024 Nov 14
" Former Maintainer:	Bram Moolenaar <Bram@vim.org>
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
" Revert with ":unmap Q".
map Q gq
sunmap Q

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" terminals use ":", select text and press Esc.
if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif

" Only do this part when Vim was compiled with the +eval feature.
if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":autocmd! vimStartup"
  augroup vimStartup
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim), for a commit or rebase message
    " (likely a different one than last time), and when using xxd(1) to filter
    " and edit binary files (it transforms input files back and forth, causing
    " them to have dual nature, so to speak) or when running the new tutor
    autocmd BufReadPost *
      \ let line = line("'\"")
      \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
      \      && index(['xxd', 'gitrebase', 'tutor'], &filetype) == -1
      \ |   execute "normal! g`\""
      \ | endif

    " Set the default background for putty to dark. Putty usually sets the
    " $TERM to xterm and by default it starts with a dark background which
    " makes syntax highlighting often hard to read with bg=light
    " undo this using:  ":au! vimStartup TermResponse"
    autocmd TermResponse * if v:termresponse == "\e[>0;136;0c" | set bg=dark | endif
  augroup END

  " Quite a few people accidentally type "q:" instead of ":q" and get confused
  " by the command line window.  Give a hint about how to get out.
  " If you don't like this you can put this in your vimrc:
  " ":autocmd! vimHints"
  augroup vimHints
    au!
    autocmd CmdwinEnter *
	  \ echohl Todo |
	  \ echo gettext('You discovered the command-line window! You can close it with ":q".') |
	  \ echohl None
  augroup END

endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

"time for my own config"

"plugin manager install"
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugins "
call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'townk/vim-autoclose'


Plug 'DagurB/transparentwolf'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" disgustingly langur listi af plugins frá degi

Plug 'petRUShka/vim-sage'
Plug 'tpope/vim-commentary'
Plug 'luochen1990/rainbow'
Plug 'lervag/vimtex'
Plug 'DagurB/transparentwolf'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'Shirk/vim-gas' " AT&meme syntax highlighting

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" nvim-cmp annoyingly requires a snippet engine
Plug 'dcampos/nvim-snippy'
Plug 'dcampos/cmp-snippy'
Plug 'honza/vim-snippets'
Plug 'dylon/vim-antlr'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

Plug 'simrat39/rust-tools.nvim' " meme lang tools
Plug 'nvim-lua/plenary.nvim' " required for nvim-dap
Plug 'mfussenegger/nvim-dap' " debug for meme lang

Plug 'j-hui/fidget.nvim', { 'tag': 'legacy' } " LSP progress thingie


Plug 'wyyqyl/vim-smali'

Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim'

call plug#end()

" settings "
set autoindent
set tabstop=4
set shiftwidth=4
set incsearch


" frá degi "

" þetta er til að færa línur með ctrl-j/k
nnoremap <C-n> :m .+1<CR>==
nnoremap <C-e> :m .-2<CR>==

set number
set relativenumber
set showbreak=+++
set showmatch
set hlsearch
set smartcase
set ruler
set undolevels=100

colorscheme transparentwolf


let g:vimtex_view_method = 'zathura'
let g:vimtex_view_automatic = 1
autocmd BufEnter *.tex set conceallevel=2
let g:tex_conceal='abdmg'
let g:rainbow_active = 1
let g:python_recommended_style = 0
let g:rust_recommended_style = 0
let g:d_class_scope_highlight = 1

function! MdMath()
    syn region math start=/\$\$/ end=/\$\$/
    syn match math '\$[^$].\{-}\$'
    hi link math Statement
endfunction
autocmd BufRead,BufNewFile,BufEnter *.md,*.markdown call MdMath()

" vim-commentary
autocmd FileType python setlocal commentstring=#\ %s
autocmd FileType julia setlocal commentstring=#\ %s
autocmd FileType sh setlocal commentstring=#\ %s
autocmd FileType rust setlocal commentstring=//\ %s
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType circom setlocal commentstring=//\ %s
autocmd FileType cs setlocal commentstring=//\ %s
autocmd FileType nasm setlocal commentstring=;\ %s
autocmd FileType sage.python setlocal commentstring=#\ %s
autocmd FileType gp setlocal commentstring=\\\\\ %s
autocmd FileType nroff setlocal commentstring=\\#\ %s\ \\#
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType yaml setlocal commentstring=#\ %s " fuck yaml
autocmd FileType sql setlocal commentstring=--\ %s
autocmd FileType pqsql setlocal commentstring=--\ %s


lua <<EOF
	-- Set up nvim-cmp.
	local cmp = require'cmp'

	cmp.setup({
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
				-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
				-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
				require('snippy').expand_snippet(args.body) -- For `snippy` users.
				-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			end,
		},
		window = {
			-- completion = cmp.config.window.bordered(),
			-- documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		}),
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			-- { name = 'vsnip' }, -- For vsnip users.
			-- { name = 'luasnip' }, -- For luasnip users.
			-- { name = 'ultisnips' }, -- For ultisnips users.
			{ name = 'snippy' }, -- For snippy users.
		}, {
			{ name = 'buffer' },
		})
	})



	-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})
	-- cmp.setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		})
	})

	-- Set up lspconfig.
	-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	local capabilities = require('cmp_nvim_lsp').default_capabilities()
	-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

	require('snippy').setup({
		snippet_dirs = '/home/dagur/.vim/plugged/vim-snippets/snippets,/home/dagur/.config/nvim/snippets',
		mappings = {
			is = {
				['<Tab>'] = 'expand_or_advance'
			}
		}
	})

	local configs = require('lspconfig.configs')

	-- require'lspconfig'.typst_lsp.setup{}
	require'lspconfig'.gopls.setup{
		settings = {
			staticcheck = true,
			gopls = {
				staticcheck = true,
			},
		},
	}

	require('lspconfig')['clangd'].setup {
		capabilities = capabilities,
		-- cmd = {
			-- "clangd",
			-- "--background-index",
			-- "-j=12",
			-- "--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
			-- "--clang-tidy",
			-- "--clang-tidy-checks=*",
			-- "--all-scopes-completion",
			-- "--cross-file-rename",
			-- "--completion-style=detailed",
			-- "--header-insertion-decorators",
			-- "--header-insertion=iwyu",
			-- "--pch-storage=memory",
		-- },
		fallbackFlags = {
			"-std=c++23",
			-- "-std=c++2c",
			"-Wall", "-Weverything", "-O2", "-Walloca",
			"-Wcast-qual", "-Wconversion", "-Wformat=2",
			"-Wformat-security", "-Wnull-dereference",
			"-Wstack-protector", "-Wvla", "-Warray-bounds",
			"-Warray-bounds-pointer-arithmetic", "-Wassign-enum",
			"-Wbad-function-cast", "-Wconditional-uninitialized",
			"-Wfloat-equal", "-Wformat-type-confusion",
			"-Widiomatic-parentheses", "-Wimplicit-fallthrough",
			"-Wloop-analysis", "-Wpointer-arith",
			"-Wshift-sign-overflow", "-Wshorten-64-to-32",
			"-Wswitch-enum", "-Wtautological-constant-in-range-compare",
			"-Wunreachable-code-aggressive", "-Wthread-safety",
			"-Wthread-safety-beta", "-Wcomma"
		}
	}
	-- require'lspconfig'.asm_lsp.setup {
		-- capabilities = capabilities,
		-- cmd = {"asm-lsp"},
		-- filetypes = {"asm", "s", "S"}
	-- }
	require'treesitter-context'.setup {
		enable = true,
		max_lines = 4,
		min_window_height = 0,
		patterns = {
			default = {
				'class',
				'function',
				'method',
			},
		},
		zindex = 20,
		mode = 'cursor',
		seperator = nil,
	}
	require("trouble").setup {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	}
	-- require'lspconfig'.pylsp.setup{
		-- capabilities = capabilities, -- new
	-- }

	-- LMAO based
	-- require'lspconfig'.basedpyright.setup{}
	require'lspconfig'.pyright.setup{}

	-- local coq = require "coq"
	-- require('lspconfig').pylsp.setup(coq.lsp_ensure_capabilities())
	require"fidget".setup{}
	require'lspconfig'.texlab.setup{
		capabilities = capabilities, -- new
	}

	-- require'lspconfig'.omnisharp.setup {
		-- cmd = { "dotnet", "/home/dagur/cs/omnisharp/Microsoft.CodeAnalysis.ExternalAccess.OmniSharp.dll" },
-- 
		-- -- Enables support for reading code style, naming convention and analyzer
		-- -- settings from .editorconfig.
		-- enable_editorconfig_support = true,
-- 
		-- -- If true, MSBuild project system will only load projects for files that
		-- -- were opened in the editor. This setting is useful for big C# codebases
		-- -- and allows for faster initialization of code navigation features only
		-- -- for projects that are relevant to code that is being edited. With this
		-- -- setting enabled OmniSharp may load fewer projects and may thus display
		-- -- incomplete reference lists for symbols.
		-- enable_ms_build_load_projects_on_demand = false,
-- 
		-- -- Enables support for roslyn analyzers, code fixes and rulesets.
		-- enable_roslyn_analyzers = false,
-- 
		-- -- Specifies whether 'using' directives should be grouped and sorted during
		-- -- document formatting.
		-- organize_imports_on_format = false,
-- 
		-- -- Enables support for showing unimported types and unimported extension
		-- -- methods in completion lists. When committed, the appropriate using
		-- -- directive will be added at the top of the current file. This option can
		-- -- have a negative impact on initial completion responsiveness,
		-- -- particularly for the first few completion sessions after opening a
		-- -- solution.
		-- -- enable_import_completion = false,

		-- -- Specifies whether to include preview versions of the .NET SDK when
		-- -- determining which version to use for project loading.
		-- sdk_include_prereleases = true,

		-- -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
		-- -- true
		-- analyze_open_documents_only = false,
	-- }
	-- require'lspconfig'.csharp_ls.setup{}
	require('lspconfig')['rust_analyzer'].setup {
	 -- capabilities = capabilities
	}
	-- because lean.nvim selfishly overwrites this (why tho?)
	vim.opt.expandtab = false
	vim.opt.shiftwidth = 4
	vim.opt.softtabstop = 4
	vim.opt_local.expandtab = false
	vim.opt_local.shiftwidth = 4
	vim.opt_local.softtabstop = 4
	local rt = require'rust-tools'
	rt.setup {
		server = {
			on_attach = function(_, burnr)
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
		},
	}

	-- FMAL er meme kms hate this I HATE LISP I HATE LISP I HATE LISP
	-- require'lspconfig'.racket_langserver.setup{}
	-- require'lspconfig'.prolog_ls.setup{}
	
	local function quickfix()
		vim.lsp.buf.code_action({
			filter = function(a) return a.isPreferred end,
			apply = true
		})
	end
	vim.keymap.set("n", "<Leader>F", quickfix, {noremap = true})
	vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, default_opts)
	vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, default_opts)
	vim.keymap.set("n", "<Leader>gd", vim.lsp.buf.definition, default_opts)
	vim.keymap.set("n", "<Leader>gi", vim.lsp.buf.implementation, default_opts)
	vim.keymap.set("n", "<Leader>gr", require('telescope.builtin').lsp_references, default_opts)
	vim.keymap.set("n", "<Leader>ds", require('telescope.builtin').lsp_document_symbols, default_opts)
	vim.keymap.set("n", "<Leader>ws", require('telescope.builtin').lsp_dynamic_workspace_symbols, default_opts)
	vim.keymap.set("n", "<Leader>k", vim.lsp.buf.hover, default_opts)
	vim.keymap.set("n", "<Leader>K", vim.lsp.buf.signature_help, default_opts)
EOF

" colemak keybinds "

set langmap=fe,FE,pr,PR,gt,GT,jy,JY,lu,LU,ui,UI,yo,YO,rs,RS,sd,SD,tf,TF,dg,DG,nj,NJ,ek,EK,il,IL,æp,ÆP,kn,KN
noremap <C-f> <C-e>
noremap <C-p> <C-r>
noremap <C-g> <C-t>
noremap <C-j> <C-y>
noremap <C-l> <C-u>
noremap <C-u> <C-i>
noremap <C-y> <C-o>
noremap <C-æ> <C-p>
noremap <C-r> <C-s>
noremap <C-s> <C-d>
noremap <C-t> <C-f>
noremap <C-d> <C-g>
"noremap <C-n> <C-j>"
"noremap <C-e> <C-k>"
noremap <C-i> <C-l>
noremap <C-k> <C-n>

