if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  "au BufNewFile,BufRead *.pkr.hcl set ft=terraform
  "au BufNewFile,BufRead *.pkrvars.hcl set ft=terraform
  "au BufNewFile,BufRead *.tftpl set ft=terraform
augroup END
