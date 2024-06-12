# Combine ripgrep -> fzf -> nvim
# Search interface with syntax-highlighted live preview that integrates with nvim
function rfv
    set RELOAD 'reload:rg --column --color=always --smart-case {q} || :'
    set OPENER 'if test $FZF_SELECT_COUNT -eq 0
                  nvim {1} +{2}     # No selection. Open the current line in nvim.
                else
                  nvim +cw -q {+f}  # Build quickfix list for the selected items.
                end'

    fzf < /dev/null \
        --disabled --ansi --multi \
        --bind "start:$RELOAD" --bind "change:$RELOAD" \
        --bind "enter:become:$OPENER" \
        --bind "ctrl-o:execute:$OPENER" \
        --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(up)' \
        --query "$argv"
end
