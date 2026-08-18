if is-installed mise
    mise activate fish | source
end

if status is-interactive
    # Hide welcome message
    set -g fish_greeting

    # Keep only the last directory as full length
    set -g fish_prompt_pwd_full_dirs 1
    # For shortened directories, keep the first 3 characters
    set -g fish_prompt_pwd_dir_length 3
end
