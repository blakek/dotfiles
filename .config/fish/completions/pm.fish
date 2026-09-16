function __fish_pm_uses
    test (pm --print-package-manager 2>/dev/null) = $argv[1]
end

complete -c pm -l print-package-manager -d 'Print the detected package manager'

complete -c pm -n '__fish_pm_uses bun' -w bun
complete -c pm -n '__fish_pm_uses npm' -w npm
complete -c pm -n '__fish_pm_uses pnpm' -w pnpm
complete -c pm -n '__fish_pm_uses yarn' -w yarn
