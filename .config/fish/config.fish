function setup-misen-place
    if is-installed mise
        mise activate fish | source
    end
end

if status is-interactive
    setup-misen-place
end
