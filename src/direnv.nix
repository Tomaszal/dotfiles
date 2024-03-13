{
  hm.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    # https://direnv.net/man/direnv.toml.1.html#global
    config.global = {
      # Load `.envrc` with `set -euo pipefail`
      # TODO: remove when this option becomes default upstream
      strict_env = true;

      # Specify how long to wait before warning the user that the command is
      # taking too long to execute
      warn_timeout = "1m";

      # Hide the diff of the environment variables when loading the `.envrc`
      hide_env_diff = true;
    };
  };
}
