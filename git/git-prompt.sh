# Functions to display git repo information in the prompt.

# Output a '*' if we're in a git repo and it has modified files (untracked
# files don't count).
# note: <() is a shell redirection that we intend to read from. The other <
# pipes it as input to the loop.
function git_title() {
    while IFS= read -r line; do
        if [[ ! $line =~ '??' ]]; then
            echo " *"
            break
        fi
    done < <(git status --porcelain 2> /dev/null)
}
