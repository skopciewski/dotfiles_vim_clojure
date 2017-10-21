" for gutentags
let g:gutentags_ctags_tagfile = '.git/tags'
let g:gutentags_file_list_command = {
      \   'markers': {
      \     '.git': 'git ls-files',
      \     '.hg': 'hg files',
      \   },
      \ }
