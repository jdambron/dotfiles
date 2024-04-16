command -q nvim || return
function vim --wraps=nvim --description 'alias vim=nvim'
  nvim $argv
        
end
