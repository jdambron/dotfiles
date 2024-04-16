command -q helix || return
function hx --wraps=helix --description 'alias hx=helix'
  helix $argv
        
end
