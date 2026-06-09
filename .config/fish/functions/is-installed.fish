function is-installed --description 'Checks if all requested arguments are available in the PATH'
    for cmd in $argv
        if not command -v $cmd &>/dev/null
            return 1
        end
    end
end
