if exists('g:loaded_copilot')
    finish
en
let g:loaded_copilot = 1

scriptencoding utf-8

com!  -bang -nargs=? -range=-1 -complete=customlist,copilot#CommandComplete
    \ Copilot
    \ exe copilot#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>)

if v:version < 800 || !exists('##CompleteChanged')
    finish
en

fun! s:ColorScheme() abort
    if &t_Co == 256
        hi def CopilotSuggestion guifg=#808080 ctermfg=244
    el
        hi def CopilotSuggestion guifg=#808080 ctermfg=8
    en
endf

fun! s:MapTab() abort
    if get(g:, 'copilot_no_tab_map') || get(g:, 'copilot_no_maps')
        return
    en
    let tab_map = maparg('<Tab>', 'i', 0, 1)
    if empty(tab_map)
        imap <script><silent><nowait><expr> <Tab> copilot#Accept()
    elseif tab_map.rhs !~# 'copilot'
        if tab_map.expr
            let tab_fallback = '{ -> ' . tab_map.rhs . ' }'
        el
            let tab_fallback = substitute(json_encode(tab_map.rhs), '<', '\\<', 'g')
        en
        let tab_fallback = substitute(tab_fallback, '<SID>', '<SNR>' . get(tab_map, 'sid') . '_', 'g')
        if get(tab_map, 'noremap') || get(tab_map, 'script') || mapcheck('<Left>', 'i') || mapcheck('<Del>', 'i')
            exe 'imap <script><silent><nowait><expr> <Tab> copilot#Accept(' . tab_fallback . ')'
        el
            exe 'imap <silent><nowait><expr>         <Tab> copilot#Accept(' . tab_fallback . ')'
        en
    en
endf

fun! s:Event(type) abort
    try
        call call('copilot#On' . a:type, [])
    catch
        call copilot#logger#Exception()
    endtry
endf

aug  github_copilot
    au!
    au InsertLeave          * call s:Event('InsertLeave')
    au BufLeave             * if mode() =~# '^[iR]'|call s:Event('InsertLeave')|endif
    au InsertEnter          * call s:Event('InsertEnter')
    au BufEnter             * if mode() =~# '^[iR]'|call s:Event('InsertEnter')|endif
    au CursorMovedI         * call s:Event('CursorMovedI')
    au CompleteChanged      * call s:Event('CompleteChanged')
    au ColorScheme,VimEnter * call s:ColorScheme()
    au VimEnter             * call s:MapTab()
    au BufReadCmd copilot://* setl  buftype=nofile bufhidden=wipe nobuflisted readonly nomodifiable
aug  END

call s:ColorScheme()
call s:MapTab()

if !get(g:, 'copilot_no_maps')
    imap <Plug>(copilot-dismiss)     <Cmd>call copilot#Dismiss()<CR>
    if empty(mapcheck('<C-]>', 'i'))
        imap <silent><script><nowait><expr> <C-]> copilot#Dismiss() . "\<C-]>"
    en
    imap <Plug>(copilot-next)     <Cmd>call copilot#Next()<CR>
    imap <Plug>(copilot-previous) <Cmd>call copilot#Previous()<CR>
    if empty(mapcheck('<M-]>', 'i'))
        imap <M-]> <Plug>(copilot-next)
    en
    if empty(mapcheck('<M-[>', 'i'))
        imap <M-[> <Plug>(copilot-previous)
    en
en

call copilot#Init()

let s:dir = expand('<sfile>:h:h')
if getftime(s:dir . '/doc/copilot.txt') > getftime(s:dir . '/doc/tags')
    silent! execute 'helptags' fnameescape(s:dir . '/doc')
en
