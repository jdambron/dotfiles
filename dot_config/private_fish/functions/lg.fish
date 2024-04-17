command -q lazygit || return
function lg --wraps=lazygit --description 'alias lg=lazygit'
  lazygit $argv
        
end
