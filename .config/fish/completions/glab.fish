# Source the first upstream completion file after our own.
for dir in $fish_complete_path[2..-1]
    if test -f "$dir/glab.fish"
        source "$dir/glab.fish"
        break
    end
end

# Add our shell aliases after upstream has registered its completions.
source (status dirname)/glab-watch-ci.fish
source (status dirname)/greptile-list.fish
