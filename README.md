# linux-configs
Config files for various programs on a linux system.

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

Mutt reads config files from the `~/.mutt` directory by default. To reduce the chance you might accidentally commit mail credentials to git, we'll copy all these files there.
```bash
mkdir -p ~/.mutt/cache
cp muttrc ~/.mutt
cp mailcap ~/.mutt
cp colors_solarized ~/.mutt
```
The first line of `muttrc` sources the mail account config. See `example_gmail`
for a sample file to start from. You'll also want to modify the image line of
`mailcap` to be a suitable image viewer.
