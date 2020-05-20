# linux-configs
Config files for various programs on a linux system.

## bash

Your distro or network admin may have configured default behavior for `.bashrc`
(prompt, colors, aliases) and `.profile` (environment variables) so those files
aren't stored in this repo.  Instead you can source or merge the contents of
these files as needed.

- `aliases`, helper functions and shortcuts
- `dircolors`, define terminal colors for `ls` and `grep`.  Need to add this to
  `.bashrc`:
```bash
if [ -x /usr/bin/dircolors ]; then
   eval "$(dircolors -b /path/to-this-repo/bash/dircolors)"
fi
```
- `profile`, environment variables common to any linux environment
- `sortpics`, utility for sorting image files into directories by date.  Copy
  this to `~/bin` or other directory in your `$PATH`.

### Explaining how the prompt is set

I've spent way too much time over the past two days researching how the bash
prompt works.  Let's try to break down how the default prompt on Ubuntu is set
in `.bashrc`:

```bash
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
```

* The `debian_chroot` business displays the current chroot-ed environment in
  parentheses, or nothing.  See [bash parameter
expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)
  for details on how it works.
* Anything between `\[` and `\]` are unprintable characters. You can omit them
  and it'll appear to work, but it messes up bash's line lengths and shell
  history.
* `\033` (alternatively `\e`) signals an escape code follows
* `[01;32m` - set the following text to bold green
* `[01;34m` - bold blue
* `[00m` - return to normal text
* `\u@\h` prints "user@hostname"
* `\w` - current working directory with the home dir replaced by `~`
* `\$` - a literal `$` unless you're root (which you're not, right?), then `#`

But wait, there's more! xterm-compatible shells have the ability to set the
window title:

```bash
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
```

This adds a giant unprintable sequence (between `\[` and `\]`) to the `$PS1` set
earlier.  Any text between `\e]0;` and `\a` becomes the window title.  In this
case it matches the prompt, but it doesn't have to.  Another way to do this,
particularly if you want to run complicated commands to generate it, is with
`$PROMPT_COMMAND`:

```bash
PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
```

* The escape characters don't work here so you have to use the octal equivalents
  `\033]0;` and `\007`
* `${HOSTNAME%%.*}` shortens `www.google.com` to `www`
* `${PWD/#$HOME/\~}` replaces your home directory with `~` if it appears at the
  beginning of `$PWD`

## DOSBox

1. Install DOSBox-X from the [Snap Store](https://snapcraft.io/dosbox-x).
1. `cp /path/to-this-repo/dosbox/dosbox.conf ~` sets the default general config
   for all games.
1. `cp /path/to-this-repo/dosbox/*.desktop ~/.local/share/applications` adds
   Start Menu entries.  These will call game-specific `.conf` files in this
   repo.  You may have to modify the path to these files in `*.desktop`.
1. `sudo cp /path/to-this-repo/dosbox/*.png /usr/share/pixmaps` provides Start
   Menu icons.

## git

Run the commands in `gitconfig` to set up your global config. This file is not
executable because you'll have to enter personal info.

Source `git-prompt.sh` in your `.bashrc` to get functions for displaying
information about the current git repository.  Add any or all of these to
`$PROMPT_COMMAND` for a fancy inline prompt.

Run `pip3 install grip` to install a utility for viewing Markdown files before
they're published to GitHub.

## lynx

1. Copy `lynxrc` to your home directory and name it `.lynxrc`. This file sets
   basic configuration settings such as bash line editing, and vim keys for
   moving between links.
1. Copy `lynx_bookmarks.html` to your home directory.
1. Add the following lines to your `.profile`. `lynx.cfg` controls
   keybindings and `lynx.lss` controls the color scheme. **Note:** the current
   color scheme assumes your terminal is using the solarized colors.
```bash
export LYNX_CFG="/path/to-this-repo/lynx/lynx.cfg"
export LYNX_LSS="/path/to-this-repo/lynx/lynx.lss"
export WWW_HOME="https://duckduckgo.com/lite" # (or other suitable home page)
```

## mutt

Mutt reads config files from the `~/.mutt` directory by default. To reduce the
chance you might accidentally commit mail credentials to git, we'll copy all
these files there.
```bash
mkdir -p ~/.mutt/cache
cp muttrc mailcap colors_solarized ~/.mutt
```
The first line of `muttrc` sources the mail account config. See `example_gmail`
for a sample file to start from. You'll also want to modify the image line of
`mailcap` to be a suitable image viewer.

## vim

Vim gets its own repository: https://github.com/mkristofik/vimfiles
