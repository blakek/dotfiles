# `alt-c` appends `&| fish_clipboard_copy` to the current command line, which pipes all output to the clipboard
bind alt-c 'fish_commandline_append " &| fish_clipboard_copy"'
