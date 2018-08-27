echo "Logged in as $USER at $(hostname)"

export HISTTIMEFORMAT="%d/%m/%y %T "

#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
export BLOCKSIZE=1k

test -d /usr/local/bin && export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
# Path for Heroku
test -d /usr/local/heroku/ && export PATH="/usr/local/heroku/bin:$PATH"

# Load git completions
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

c_reset='\[\e[0m\]'
c_path='\[\e[0;31m\]'
c_git_clean='\[\e[0;32m\]'
c_git_dirty='\[\e[0;31m\]'

PROMPT_COMMAND='PS1="${c_path}\W${c_reset}$(git_prompt) :> "'

export PS1='\n\[\033[0;31m\]\W\[\033[0m\]$(git_prompt)\[\033[0m\]:> '

git_prompt ()
{
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  # Grab working branch name
  git_branch=$(Git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
  # Clean or dirty branch
  if git diff --quiet 2>/dev/null >&2; then
    git_color="${c_git_clean}"
  else
    git_color=${c_git_dirty}
  fi
  echo " [$git_color$git_branch${c_reset}]"
}

export LSCOLORS=ExGxFxdxCxDxDxaccxaeex

# Force grep to always use the color option and show line numbers
export GREP_OPTIONS='--color=always'

# Set VSCode as the default editor
which -s code && export EDITOR="code --wait"

# Rbenv autocomplete and shims
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
test -d $HOME/.rbenv/ && PATH="$HOME/.rbenv/bin:$PATH"

alias ls='ls -Gh'
alias be="bundle exec"
alias iphone="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias tick="termdown -s 20m -t 'Save your eyesight'"

countdown() {
  termdown -s -b -v Victoria "${1:-55}"m
}

did() {
  DID_FILE=~/dev/did.md
  DATE=$(date +"# %Y%m%d (%A)")
  DATE_MATCH=$(grep "$DATE" "$DID_FILE")

  if [ -z "$DATE_MATCH" ]; then
    echo "" >> $DID_FILE
    echo "$DATE" >> $DID_FILE
  fi

  LAST_LINE=$(($(wc -l < "$DID_FILE") + 1))

  code --goto $DID_FILE:$LAST_LINE
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
