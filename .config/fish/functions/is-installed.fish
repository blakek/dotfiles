function is-installed --description 'Checks if all requested arguments are available in the PATH'
    type -P $argv &>/dev/null
end
