# Tomaszal's dotfiles

Welcome to my personal dotfiles repository. I use [yadm](https://yadm.io/) to manage it, refer to [this page](https://yadm.io/docs/common_commands) for usage.

## Bootstrap

The bootstrap script installs select packages and initializes yadm, effectively configuring everything needed on a fresh system.

To run this script on a fresh system invoke this command:

```shell
curl -fsSL 'https://github.com/Tomaszal/dotfiles/raw/master/.yadm/bootstrap' | sh
```

This bootstrap script is idempotent. After yadm is installed and configured you can run `yadm bootstrap` to launch this script. It will update your system with latest changes in this dotfiles repository.

## Updates

If you just want to update the local dotfiles (without executing the bootstrap script), run `yadm pull`.
