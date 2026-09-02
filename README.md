# dotfiles

zsh, Neovim, tmux, kitty, lazygit and k9s config for macOS (primary) and Linux,
symlinked into `~` with GNU Stow.

## New machine

```sh
# 1. Get the repo (needs an SSH key added to GitHub; or clone over https)
git clone git@github.com:rafaelmian1/.dotfiles.git ~/.dotfiles

# 2. Install everything and link it
~/.dotfiles/bootstrap.sh
```

`bootstrap.sh` is safe to re-run. In order, it:

1. Installs system prerequisites: Xcode Command Line Tools on macOS; on Linux,
   build tools, `zsh`, `unzip`, `xclip` via apt/dnf/pacman.
2. Installs Homebrew (also used on Linux) and everything in [`Brewfile`](Brewfile).
3. Installs Rust (rustup), then [bob](https://github.com/MordechaiHadad/bob) and Neovim stable through it.
4. Installs the latest LTS Node through nvm and makes it the default.
5. Runs `stow .` to link the dotfiles into `~`, and copies the k9s config.
6. Applies a colour theme (`theme-set`), which creates the files tmux and kitty include.
   On macOS it also runs `setup_theme_sync`, so the theme follows light/dark mode.
7. Clones tpm (tmux plugin manager) and syncs Neovim plugins.
8. On Linux, makes zsh the login shell.

Then, by hand:

- [ ] Open a new terminal. On first start zinit installs itself and the zsh plugins.
- [ ] In tmux: <kbd>Ctrl-\\</kbd> then <kbd>I</kbd> to install tmux plugins.
- [ ] In nvim: wait for Mason to install LSPs/formatters (`:Mason`), then `:Copilot auth`.
- [ ] Create a machine overlay if needed (see [Machine overlays](#machine-overlays)).
- [ ] macOS, optional: [Raycast theme commands](raycast/README.md).
- [ ] Not in this repo, bring over separately: SSH keys, `~/.gitconfig`,
      `~/.aws`, `~/.kube`, tmuxp workspaces (`~/.tmuxp/*.yaml`, used by `ts`/`tsw`/`tss`).

## Dependencies

[`Brewfile`](Brewfile) is the list of tools these configs call; each line says
what uses it. A few things are installed outside Homebrew:

| What | How | Used by |
|---|---|---|
| Neovim | `bob` (`cargo install bob-nvim`) | everything nvim; needs ≥ 0.11 |
| Node | `nvm install --lts` | Mason (ts_ls, prettier), Copilot |
| zinit + zsh plugins, Powerlevel10k | auto-installed by `.zshrc` | shell |
| lazy.nvim + plugins | auto-installed by nvim | nvim |
| LSPs, formatters, debuggers | Mason, from `lua/plugins/lsp.lua` | nvim |
| tpm + tmux plugins | git clone, then <kbd>prefix</kbd> <kbd>I</kbd> | tmux |
| `nvr` (optional) | `pipx install neovim-remote` | `$EDITOR` inside nvim terminals |

## Layout

```
.zshenv .zprofile .zshrc   shell startup (see below)
.zsh_aliases               shared aliases & helpers (git, tmux, k8s, s3, …)
.p10k.zsh                  prompt
.config/                   nvim, tmux, tmux-powerline, kitty, lazygit
k9s/config.yaml            copied (not linked) by bootstrap; k9s rewrites it
themes/ theme-generator/   colour themes, see themes/README.md
theme-set switch_theme     apply a theme / re-apply on light-dark change
setup_theme_sync           macOS LaunchAgent: dark-notify → switch_theme
tmux_session               tmuxp workspace launcher (ts / tsw / tss)
raycast/                   Raycast script commands (macOS)
Brewfile bootstrap.sh      new-machine setup
personal/ tkww/            machine overlays, gitignored
```

## Shell startup

| File | Read by | Holds |
|---|---|---|
| `.zshenv` | every zsh, scripts included | PATH for cargo and bob, nothing else |
| `.zprofile` | login shells (new terminal tab, tmux pane) | Homebrew, PATH, env vars |
| `.zshrc` | interactive shells | prompt, plugins, completions, keybindings, aliases |

Environment set in `.zprofile` is inherited by subshells, so it runs once rather
than in every nested shell. Startup is about 0.15s; if it gets slow again,
profile it:

```sh
zsh -i -c 'zmodload zsh/zprof; source ~/.zshrc; zprof' | head -20
```

Things that keep it fast: `compinit` runs **once**, with the full check at most
daily (`rm ~/.zcompdump` if new completions don't show up), and nvm is
lazy-loaded on the first `nvm` call while the default node goes on PATH directly.

## Machine overlays

The last thing `.zshrc` does is source these, if they exist:

- `~/.dotfiles/personal/.zshrc`, for a personal machine
- `~/.dotfiles/tkww/.zshrc`, for the work machine

Both directories are gitignored and skipped by stow. Put anything that only makes
sense on one machine there: project `cd` aliases, work AWS profiles, private
hosts, tokens. Because they load last, they can override shared settings, e.g.

```zsh
# tkww/.zshrc
k() { AWS_PROFILE=my-work-profile kubectl "$@" }   # all kube helpers use `k`
```

An overlay must **not** `source ~/.zshrc`; it is already being sourced from there.
`pz` opens the personal overlay.

## Stow

Run from the repo; `.stowrc` is picked up automatically:

```sh
cd ~/.dotfiles
stow -n -v .   # dry run
stow .         # link
```

`.stowrc` ignores everything that shouldn't land in `~` (overlays, themes,
scripts, Raycast, …). When adding a new top-level file or folder that isn't
config, add an `--ignore=` line for it there.

If stow reports *existing target is not owned by stow*, a real file (or a link
not made by stow) is in the way. Move it aside and re-run, or `stow --adopt .`
to pull it into the repo and review with `git diff`.

## Linux notes

Works, with these gaps:

- **kitty**: not in Homebrew on Linux. Use the
  [official installer](https://sw.kovidgoyal.net/kitty/binary/) and install
  JetBrainsMono Nerd Font by hand.
- **Themes**: `theme-set` writes k9s and lazygit config under
  `~/Library/Application Support`, macOS paths. On Linux those two keep their
  default colours. Following light/dark mode (`setup_theme_sync`) is macOS-only.
- **`kcp`** copies with `pbcopy`; `icloud` alias and `raycast/` are macOS-only.
