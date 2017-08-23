" Toggle Background
" Modified:     2011 Apr 29
" Maintainer:   Ethan Schoonover
" License:      OSI approved MIT license

if exists("g:loaded_togglebg")
    finish
endif
let g:loaded_togglebg = 1

" noremap is a bit misleading here if you are unused to vim mapping.
" in fact, there is remapping, but only of script locally defined remaps, in 
" this case <SID>TogBG. The <script> argument modifies the noremap scope in 
" this regard (and the noremenu below).
nnoremap <unique> <script> <Plug>ToggleBackground <SID>TogBG
inoremap <unique> <script> <Plug>ToggleBackground <ESC><SID>TogBG<ESC>a
vnoremap <unique> <script> <Plug>ToggleBackground <ESC><SID>TogBG<ESC>gv
nnoremenu <script> Window.Toggle\ Background <SID>TogBG
inoremenu <script> Window.Toggle\ Background <ESC><SID>TogBG<ESC>a
vnoremenu <script> Window.Toggle\ Background <ESC><SID>TogBG<ESC>gv
tmenu Window.Toggle\ Background Toggle light and dark background modes
nnoremenu <script> ToolBar.togglebg <SID>TogBG
inoremenu <script> ToolBar.togglebg <ESC><SID>TogBG<ESC>a
vnoremenu <script> ToolBar.togglebg <ESC><SID>TogBG<ESC>gv
tmenu ToolBar.togglebg Toggle light and dark background modes
noremap <SID>TogBG  :call <SID>TogBG()<CR>

function! s:TogBG()
    if exists("g:colors_name")
        " Save g:colors_name in case next command resets it
        let s:colors_name = g:colors_name
    elseif exists("s:old_colors")
        " Restore previous colorscheme
        exe "colorscheme " . s:old_colors
        unlet s:old_colors
        return
    endif
    let &background = ( &background == "dark"? "light" : "dark" )
    " Handle incompatible colorscheme better
    if !exists("g:colors_name")
        " Reset colorscheme properly
        highlight clear
        " Fix Normal colors to match bg
        if &background == "dark"
            highlight Normal ctermfg=LightGray ctermbg=Black guifg=LightGray guibg=Black
        else
            highlight Normal ctermfg=Black ctermbg=White guifg=Black guibg=gray90
        endif
        if exists("s:colors_name")
            " Save previous colorscheme for next toggle
            let s:old_colors = s:colors_name
        endif
    endif
endfunction

if !exists(":ToggleBG")
    command ToggleBG :call s:TogBG()
endif

function! ToggleBackground()
    echo "Please update your ToggleBackground mapping. ':help togglebg' for information."
endfunction

function! togglebg#map(mapActivation)
    try
        exe "silent! nmap <unique> ".a:mapActivation." <Plug>ToggleBackground"
        exe "silent! imap <unique> ".a:mapActivation." <Plug>ToggleBackground"
        exe "silent! vmap <unique> ".a:mapActivation." <Plug>ToggleBackground"
    finally
        return 0
    endtry
endfunction

if !exists("no_plugin_maps") && !hasmapto('<Plug>ToggleBackground')
    call togglebg#map("<F5>")
endif

" vim: sw=4 et
