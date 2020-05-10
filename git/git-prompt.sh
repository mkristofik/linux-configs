# Functions to display git repo information in the prompt.

# Output a '*' if we're in a git repo and it has modified files (untracked
# files don't count).
# note: <() is a shell redirection that we intend to read from. The other <
# pipes it as input to the loop.
function git_title {
    while IFS= read -r line; do
        if [[ ! $line =~ '??' ]]; then
            echo " *"
            break
        fi
    done < <(git status --porcelain 2> /dev/null)
}

# Embeds the current git repository status (dirty or clean) in the prompt. Add
# this function to $PROMPT_COMMAND in your .bashrc. I tried really hard to make
# this return a string you could embed in $PS1 directly but I couldn't figure
# it out. So we're resorting to this way instead.
function git_status_prompt {
    # First time through, save the original prompt so we can restore it for
    # non-git directories.
    if [[ -z $PS1_ORIG ]]; then
        PS1_ORIG="$PS1"
    fi

    local line=""
    local status=0
    local modified=0
    local untracked=0
    while IFS= read -r line; do
        if [[ $line =~ '##' ]]; then
            if [[ $line =~ "ahead" ]]; then
                status=1
            elif [[ $line =~ "behind" ]]; then
                status=2
            else
                status=3
            fi
        elif [[ $line =~ '??' ]]; then
            untracked=1
        else
            modified=1
        fi
    done < <(git status --porcelain -b 2> /dev/null)

    local nocolor='\[\033[0m\]'
    local green='\[\033[32m\]'
    local yellow='\[\033[33m\]'
    local blue='\[\033[34m\]'
    local bold_magenta='\[\033[01;35m\]'
    local bold_red='\[\033[01;31m\]'

    local indicator=""
    if [[ $status -eq 0 ]]; then
        # Not a git repo.
        PS1="$PS1_ORIG"
        return
    elif [[ $modified -gt 0 ]]; then
        indicator="${green}*"
    elif [[ $status -eq 1 ]]; then
        indicator="${bold_magenta}↑"
    elif [[ $status -eq 2 ]]; then
        indicator="${bold_red}↓"
    elif [[ $untracked -gt 0 ]]; then
        indicator="${yellow}…"
    else
        indicator="${blue}✔"
    fi

    # Strip off the trailing bit of the base prompt ("\$ ") and insert the git
    # status info, then restore it.
    local git_status="${nocolor}|${indicator}${nocolor}|"
    PS1="${PS1_ORIG:0:-3}${git_status}\$ "
}
