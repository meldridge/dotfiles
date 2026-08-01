# config

Linux dotfiles (zsh, bash, tmux).

## Layout

**Stow packages** — `bash/`, `herdr/`, `starship/`, `tmux/`, `zim/`, `zsh/`. Contents mirror paths under `$HOME`, so `stow <pkg>` symlinks them into place. Edits take effect immediately.

**`system/`** — root-owned files under `/etc`, laid out mirroring their real paths. Not stowed: copied by `make`, because the file landing in place isn't what applies it (hwdb has to be compiled into `hwdb.bin`, keyd has to reload). Edits need a re-install.

```sh
make system   # everything
make hwdb     # Apple keyboard modifier rotation
make keyd     # Logitech M720 buttons + wheel tilt
```

`make hwdb` rotates modifiers on any USB Apple keyboard (vendor `05ac`) — the MacBookPro11,5 internal board and the wired A1243: Command→Ctrl, Ctrl→Alt, Option→Super, both sides. Verify with `udevadm info /sys/class/input/eventN | grep KEYBOARD_KEY`.

`make keyd` needs keyd installed (COPR, not in Fedora proper).
