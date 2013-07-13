let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
      \ 'name': 'sound-volume',
      \ 'description': 'Control sound volume of your system',
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