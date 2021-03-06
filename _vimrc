set nocompatible " Needs to be the first line
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" See https://github.com/gmarik/vundle for more help on Vundle
" Vundle manages Vundle

Bundle 'gmarik/vundle'

" Bundles {
	Bundle 'The-NERD-tree'
	Bundle 'The-NERD-Commenter'
	Bundle 'fugitive.vim'
	Bundle 'extradite.vim'
	Bundle 'surround.vim'
	Bundle 'ragtag.vim'
	Bundle 'Syntastic'
	Bundle 'Wombat'
	Bundle 'set_utf8.vim'
	Bundle 'xolox/vim-shell'
	Bundle 'matchit.zip'
	Bundle 'obsidian2.vim'
	Bundle 'molokai'
	Bundle 'ShowMarks7'
	Bundle 'pythoncomplete'
	Bundle 'pyflakes.vim'
	Bundle 'Indent-Guides'
	Bundle 'vim-scripts/UltiSnips'
	Bundle 'sessionman.vim'
	Bundle 'LustyExplorer'
	Bundle 'LustyJuggler'
	Bundle 'kchmck/vim-coffee-script.git'
	Bundle 'godlygeek/tabular'

	" change to your own snippets if you don't like mine :) 
	Bundle 'aalvarado/ultisnips-snippets.git'

	" Mostly copied from Janus dotvim
	Bundle 'tpope/vim-rails.git'
	Bundle 'altercation/vim-colors-solarized.git'
	Bundle 'tpope/vim-haml.git'
	Bundle 'mileszs/ack.vim.git'
	Bundle 'ervandew/supertab.git'
	Bundle 'vim-ruby/vim-ruby.git'
	Bundle 'tpope/vim-vividchalk.git'
	Bundle 'tpope/vim-cucumber.git'
	Bundle 'mattn/gist-vim.git'
	Bundle 'pangloss/vim-javascript.git'
	Bundle 'timcharper/textile.vim.git'

	Bundle 'tpope/vim-bundler'
	Bundle 'vim-scripts/AutoTag'
	Bundle 'vim-scripts/AnsiEsc.vim'
	Bundle 'tpope/vim-endwise'
" }


" Lots of stuff (borrowed||stolen) from
" http://github.com/spf13/spf13-vim
" https://github.com/scrooloose/vimfiles/blob/master/vimrc

" Windows specific {
	if has('win32') || has ('win64')
		set directory+=,~/tmp,$TMP
		" Adds git runtime path so it is able to use Fugitive and Vundle  within GVIM,
		" while using the git bash only option when installing git for win
		
		" uses standard git install directories
		let gitdir='C:\Program Files (x86)\Git\bin'
		let gitdiralt='C:\Program Files\Git\bin'

		if isdirectory(gitdir)
			let $PATH.=';' .gitdir
		elseif isdirectory(gitdiralt)
			let $PATH.=';' . gitdiralt
		endif
		" Needed for ruby based plugins
		let $PATH.=';' . 'c:\ruby192\bin'
	endif
" }

" Basic {
	set background=dark
" }

" General {
	set mouse=a " enable mouse usage
	scriptencoding utf-8
	set backup " backups are nice, indeed
	syntax on
	set mouse=a
	set history=1000
	filetype plugin on
	set gdefault
	set complete-=i
" }

" Vim UI {
	set ruler
	set nu " Line numbers
	set showcmd
	set showmatch
	set number
	set hlsearch
	set incsearch
	set ignorecase " Ignore case while searching
	set smartcase
	set wildmode=list:longest " Make cmdline tab completion similar to bash
	set wildmenu " Enable ctrl-n and ctrl-p to scroll thru matches
	set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
	set scrolloff=3
	set scrolljump=5
	set pastetoggle=<F12>
	set hidden
	set so=5

	if has("gui_running")
		colorscheme wombat	" Load a colorscheme
		set lines=40	" 40 lines height
		set co=160	" Set 160 columns
		set guioptions-=T " Hide the toolbar on Gvim
		" Automatically resize splits when resizing MacVim window
		autocmd VimResized * wincmd =
		" Set font
		if has("gui_macvim")
			try
				set guifont=Anonymous\ Pro:h13
			catch
				set guifont=Monaco:h12
			endtry
		else
			set guifont=Luxi\ Mono\ 10
		endif
	endif
	
	" status line config from: https://github.com/scrooloose/vimfiles
	"Status line {
		" Statusline setup
		set statusline=%f "tail of the filename

		" Display a warning if fileformat isnt unix
		set statusline+=%#warningmsg#
		set statusline+=%{&ff!='unix'?'['.&ff.']':''}
		set statusline+=%*

		" Display a warning if file encoding isnt utf-8
		set statusline+=%#warningmsg#
		set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
		set statusline+=%*

		set statusline+=%h " Help file flag
		set statusline+=%y " Filetype
		set statusline+=%r " Read only flag
		set statusline+=%m " Modified flag

		set statusline+=%{fugitive#statusline()}

		" Display a warning if &et is wrong, or we have mixed-indenting
		set statusline+=%#error#
		set statusline+=%{StatuslineTabWarning()}
		set statusline+=%*

		set statusline+=%{StatuslineTrailingSpaceWarning()}

		set statusline+=%{StatuslineLongLineWarning()}

		set statusline+=%#warningmsg#
		set statusline+=%{SyntasticStatuslineFlag()}
		set statusline+=%*

		" Display a warning if &paste is set
		set statusline+=%#error#
		set statusline+=%{&paste?'[paste]':''}
		set statusline+=%*

		set statusline+=%= " Left/right separator
		set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
		set statusline+=%c, " Cursor column
		set statusline+=%l/%L " Cursor line/total lines
		set statusline+=\ %P " Percent through file
		set laststatus=2

		" Recalculate the trailing whitespace warning when idle, and after saving
		autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

		" Return '[\s]' if trailing white space is detected
		" Return '' otherwise
		function! StatuslineTrailingSpaceWarning()
			if !exists("b:statusline_trailing_space_warning")

				if !&modifiable
					let b:statusline_trailing_space_warning = ''
					return b:statusline_trailing_space_warning
				endif

				if search('\s\+$', 'nw') != 0
					let b:statusline_trailing_space_warning = '[\s]'
				else
					let b:statusline_trailing_space_warning = ''
				endif
			endif
			return b:statusline_trailing_space_warning
		endfunction


		"return the syntax highlight group under the cursor ''
		function! StatuslineCurrentHighlight()
			let name = synIDattr(synID(line('.'),col('.'),1),'name')
			if name == ''
				return ''
			else
				return '[' . name . ']'
			endif
		endfunction

		"recalculate the tab warning flag when idle and after writing
		autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

		"return '[&et]' if &et is set wrong
		"return '[mixed-indenting]' if spaces and tabs are used to indent
		"return an empty string if everything is fine
		function! StatuslineTabWarning()
			if !exists("b:statusline_tab_warning")
				let b:statusline_tab_warning = ''

				if !&modifiable
					return b:statusline_tab_warning
				endif

				let tabs = search('^\t', 'nw') != 0

				"find spaces that arent used as alignment in the first indent column
				let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

				if tabs && spaces
					let b:statusline_tab_warning = '[mixed-indenting]'
				elseif (spaces && !&et) || (tabs && &et)
					let b:statusline_tab_warning = '[&et]'
				endif
			endif
			return b:statusline_tab_warning
		endfunction

		"recalculate the long line warning when idle and after saving
		autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

		"return a warning for "long lines" where "long" is either &textwidth or 80 (if
		"no &textwidth is set)
		"
		"return '' if no long lines
		"return '[#x,my,$z] if long lines are found, were x is the number of long
		"lines, y is the median length of the long lines and z is the length of the
		"longest line
		function! StatuslineLongLineWarning()
			if !exists("b:statusline_long_line_warning")

				if !&modifiable
					let b:statusline_long_line_warning = ''
					return b:statusline_long_line_warning
				endif

				let long_line_lens = s:LongLines()

				if len(long_line_lens) > 0
					let b:statusline_long_line_warning = "[" .
								\ '#' . len(long_line_lens) . "," .
								\ 'm' . s:Median(long_line_lens) . "," .
								\ '$' . max(long_line_lens) . "]"
				else
					let b:statusline_long_line_warning = ""
				endif
			endif
			return b:statusline_long_line_warning
		endfunction

		"return a list containing the lengths of the long lines in this buffer
		function! s:LongLines()
			let threshold = (&tw ? &tw : 80)
			let spaces = repeat(" ", &ts)

			let long_line_lens = []

			let i = 1
			while i <= line("$")
				let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
				if len > threshold
					call add(long_line_lens, len)
				endif
				let i += 1
			endwhile

			return long_line_lens
		endfunction

		"find the median of the given array of numbers
		function! s:Median(nums)
			let nums = sort(a:nums)
			let l = len(nums)

			if l % 2 == 1
				let i = (l-1) / 2
				return nums[i]
			else
				return (nums[l/2] + nums[(l/2)-1]) / 2
			endif
		endfunction

	" }

" Key Mappings {
	let mapleader = ',' " remmaping leader key to ,
	"Turn off search highlitghting with leader /
	nmap <silent> <leader>/ :nohlsearch<CR>
	" remmaping ; to :, saves shift :)
	nnoremap ; :
	" Change working directory to the current one
	cmap cwd lcd %:p:h
	cmap cd. lcd %:p:h
	" Save a file when you forgot to sudo
	cmap w!! %!sudo tee > /dev/null %

	imap <C-Space> <Space>=><Space>
	inoremap {<CR>	{<CR>}<Esc>O
	command! VimRC :source $MYVIMRC
	nnoremap <leader>d "_d
	nn G G10<c-e>
	" }

" Formatting {

	" Do soft wrap lines
	set wrap
	set showbreak=⏎\ 
	set autoindent

	set tabstop=4
	set shiftwidth=4
	set backspace=indent,eol,start
	set whichwrap=b,s,h,l,<,>,[,] " backspace and cursor keys wrap to
	set ffs=unix
	set ff=unix
	set nobomb
	setl nobomb
	set list
	set listchars:tab:\ \ ,trail:·

	"coffee script
	au BufNewFile,BufReadPost *.coffee,*.haml setl shiftwidth=2 expandtab tabstop=2 softtabstop=2

	"python
	au FileType python setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4
	au BufNewFile,BufReadPost *.py setl ft=python

	"ruby
	au FileType ruby setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2 nobomb
	au BufNewFile,BufReadPost *.ruby setl ft=ruby

	"javascript
	au FileType javascript setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2 nobomb

	au BufRead,BufNewFile *.js	set ft=javascript

	" add json syntax highlighting
	" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
	au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby

	" add json syntax highlighting
	au BufNewFile,BufRead *.json set ft=javascript
	
	"defaults to txt on empty file type
	"autocmd BufEnter * if &filetype == "" | setlocal ft=txt | endif
	
"}

" Plugins {
	" indent guides{
		let g:indent_guides_enable_on_vim_startup = 1
		let g:indent_guides_guide_size = 1
	" }

	" NerdTree {
		"map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
		nnoremap <f2> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
		let NERDTreeShowBookmarks=1
		let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
		let NERDTreeChDirMode=0
		let NERDTreeQuitOnOpen=1
		let NERDTreeShowHidden=1
		let NERDTreeKeepTreeInNewTab=1
		let g:NERDTreeMouseMode = 2
		let g:NERDTreeWinSize = 40
	" }

	" fugitive {
		"http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
		"hacks from above (the url, not jesus) to delete fugitive buffers when we
		"leave them - otherwise the buffer list gets poluted
		"
		"add a mapping on .. to view parent tree
		autocmd BufReadPost fugitive://* set bufhidden=delete
		autocmd BufReadPost fugitive://*
		  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
		  \ nnoremap <buffer> .. :edit %:h<CR> |
		  \ endif
	"}
	
	" Supertab {
		  if !exists("g:SuperTabRetainCompletionDuration")
			let g:SuperTabRetainCompletionDuration = 'insert'
		  endif

		  if !exists("g:SuperTabMidWordCompletion")
			let g:SuperTabMidWordCompletion = 1
		  endif

		  if !exists("g:SuperTabMappingForward")
			let g:SuperTabMappingForward = '<tab>'
		  endif
		  if !exists("g:SuperTabMappingBackward")
			let g:SuperTabMappingBackward = '<s-tab>'
		  endif

		  if !exists("g:SuperTabMappingTabLiteral")
			let g:SuperTabMappingTabLiteral = '<c-tab>'
		  endif

		  if !exists("g:SuperTabLongestHighlight")
			let g:SuperTabLongestHighlight = 0
		  endif
	" }
	
	" Syntastic settings{
		let g:syntastic_enable_signs=1
		let g:syntastic_auto_loc_list=2
	"}

	"UltiSnip{
		if !exists("g:UltiSnipsSnippetsDir")
			let g:UltiSnipsSnippetDirectories=["..//ultisnips-snippets"]
			let g:UltiSnipsEditSplit="horizontal"
		endif
		
		" Conflicts with diagraphs, switching <c-k> to something else
		" use :redraw instead of <c-l>
		if !exists("g:UltiSnipsJumpBackwardTrigger")
			let g:UltiSnipsJumpBackwardTrigger = "<c-l>"
		endif
	"}

	"showmarks{
		" Prevents showmarks showing up for other buffer types
		let g:showmarks_ignore_type = "hqprm"
	"}

	"surround{
		" via: http://whynotwiki.com/Vim
		" Ruby
		" Use v or # to get a variable interpolation (inside of a string)}
		" ysiw# Wrap the token under the cursor in #{}
		" v...s# Wrap the selection in #{}
		let g:surround_113 = "#{\r}" " v
		let g:surround_35 = "#{\r}" " #
	"}
" }

function! InitializeDirectories()
  let separator = "."
  let parent = $HOME
  let prefix = '.vim'
  let dir_list = {
		\ 'backup': 'backupdir',
		\ 'views': 'viewdir',
		\ 'swap': 'directory'}

		for [dirname, settingname] in items(dir_list)
				let directory = parent . '/' . prefix . dirname . "/"
				if exists("*mkdir")
						if !isdirectory(directory)
								call mkdir(directory)
						endif
				endif
				if !isdirectory(directory)
						echo "Warning: Unable to create backup directory: " . directory
						echo "Try: mkdir -p " . directory
				else
				  let directory = substitute(directory, " ", "\\\\ ", "")
				  exec "set " . settingname . "=" . directory
				endif
		  endfor
endfunction
call InitializeDirectories()

" Use local vimrc if available {
	if filereadable(expand("~/.vimrc.local"))
		source ~/.vimrc.local
	endif
" }
