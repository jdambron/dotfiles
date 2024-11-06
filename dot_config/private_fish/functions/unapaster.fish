function unapaster
    for file in $argv
        if test -f "$file"
            echo "File '$file':"
            echo "```"
            cat "$file"
            echo "```"
            echo
        else
            echo "Error: '$file' is not a valid file."
            return 1
        end
    end | wl-copy
end
