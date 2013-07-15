let s:save_cpo = &cpo
set cpo&vim

" TODO don't depend on vimprocbang command exist
let s:unite_source = {
      \ 'name': 'sound-volume',
      \ 'description': 'Control sound volume of your system',
      \ 'hooks': {},
      \ }

function! s:unite_source.hooks.on_init(args, context)
  let s:beforevolume = '0%' " TODO
endfunction

function! s:unite_source.hooks.on_close(args, context)
  execute printf("VimProcBang amixer set Master %s", string(s:beforevolume))
endfunction

let s:unite_source.action_table['*'].preview = {
      \ 'description' : 'preview this sound volume',
      \ 'is_quit' : 0,
      \ }
function! s:unite_source.gather_candidates(args, context)
  let parcentages = map(range(0, 100, 5), 'printf("%s%%", v:val)')

  " "action__type" is necessary to avoid being added into cmdline-history.
  return map(parcentages, '{
        \ "word": v:val,
        \ "source": "sound-volume",
        \ "kind": ["command"],
        \ "action__command": printf("VimProcBang amixer set Master %s", string(v:val)),
        \ "action__type": ": "
        \ }')
endfunction

function! unite#sources#sound_volume#define()
  return s:unite_source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
