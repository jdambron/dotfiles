command -q eza || return
function l --wraps='eza --icons --group-directories-first' --description 'alias l=eza --icons --group-directories-first'
  eza --icons --group-directories-first $argv
        
end
