# KDE configs

KDE is a bit annoying with configuration files. Because of that it is difficult to keep KDE configs in a dotfiles repository. So what I decided to do is to export as much of KDE configuration as I reasonably can from KDE settings manager. For the rest of the settings I just write down the preffered options and where to set them.

# Workspace

## Shortcuts

### Global Shortcuts

```
Global Shortcuts -> File -> Import Scheme -> Path -> '~/.config/kde/keyboard-global-shortcuts.kksrc'
```

## Desktop Behavior

### Virtual Desktops

Make sure that there are at least 2 desktops in order for the desktop pager widget to work.

```
Rows -> 1
```

## Window Management

### Window Behavior: Window Actions

```
Modifier key:   Meta
```

### KWin Scripts

```
Get New Scripts -> Search -> 'KWin dynamic workspaces' -> Install
```

# Hardware

## Input Devices

### Keyboard: Layouts

Change English (US) layout label from lowercase to uppercase and add Russian layout.

# Appearance

## Look and Feel

```
Breeze Dark
```

## Icons

```
Papirus-Dark
```

## Fonts

Use '`Adjust all fonts`' button speed up the configuration.

```
General:        Fira Sans 10pt
Fixed width:    Fira Code 9pt
Small:          Fira Sans 8pt
Toolbar:        Fira Sans 10pt
Menu:           Fira Sans 10pt
Window title:   Fira Sans 10pt
```

## Aplication Style

### GNOME/GTK Application Style

Do NOT touch anything in here as those settings are already configured in other dotfiles. Changing these settings can may them. If that happens use `yadm status` to see what dotfiles were changed and use `yadm restore <file_name>` on those files.