command -q eza || return
function ll --wraps=ls --wraps='eza --icons --group-directories-first -l' --description 'alias ll=eza --icons --group-directories-first -l'
  eza --icons --group-directories-first -l $argv
        
end
