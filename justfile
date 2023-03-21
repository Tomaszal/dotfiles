usage := '''
  Just: A Command Runner

  Usage:
      just <recipe>

'''

[private]
@default:
  echo '{{usage}}'
  just --list --unsorted

# Verify code conventions
lint:
  git ls-files '*.nix' | xargs alejandra --check
  statix check

# Start Ventoy2Disk Web GUI
ventoy:
  nix run .#ventoy
