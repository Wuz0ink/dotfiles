if test -z "$DISPLAY" && [ (fgconsole) -eq 1 ]; exec startx; end;

# Set the greeting
# Command line utility aliases
alias t  "tree --dirsfirst"
alias ll "exa -lah"
alias l "exa"
alias ls "exa"
alias cat "batcat"
alias g "git"
alias gs "git status"
alias gb "git branch"
alias gch "git checkout"
alias gc "git commit"
alias gd "git diff"
alias gf "git fetch --all"
alias gl "git l"
alias pr "gh pr"
alias wtc 'curl -Ss http://whatthecommit.com/index.txt | xargs -0 git commit -m '

# Link binaries w/ stow to ~/.local/bin
function lnbin
  stow -t $HOME/.local/bin/ $argv;
end

# Upload file under 100MiB & copies URL to clipboard, removed in 24h
function up
  set result (curl -sF name=$argv -F file=@$argv 'https://uguu.se/api.php?d=upload-tool')
  echo "Copied '$result' to clipboard"
  echo $result | tr -d '\n' | xsel -bspi
end
function dela
  set result (curl -sF name=$argv -F file=@$argv 'https://fildel-api.herokuapp.com/')
  echo "Copied '$result' to clipboard"
  echo $result | tr -d '\n' | xsel -bspi
end

# Git aliases
alias gs  "git status -sb"
alias ga  "git add"
alias gb "git branch"
alias gc  "git commit"
alias gcm "git commit -m"
alias gd  "git diff"
alias gco "git checkout"

# Colors
set fish_color_cwd 268bd2
set fish_color_error ff8a00
set -x LS_COLORS "di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

#set -g c0 (set_color red)
#set -g c0 (set_color 005284)
#set -g c1 (set_color 0075cd)
#set -g c2 (set_color 009eff)
#set -g c3 (set_color 6dc7ff)
#set -g c4 (set_color ffffff)
#set -g ce (set_color $fish_color_error)

# Greeting
function fish_greeting
  #echo "$ce$USER$c2@$c4"(uname -n)$c2" - $c0"(uptime)" $c3~~~ ><(((º>"
  #calendar | grep (date "+%b %d")
end
function fish_title
  echo "fish @ "(pwd)
end


# Allow fish to print out unicode characters
set -x LANG en_US.UTF-8

# Editor config
set -U EDITOR nvim

# Terminal config
#set -x TERM xterm-256color

# Node bin
set -x PATH $PATH $HOME/.local/bin
set -x PATH $PATH $HOME/.npm-global/bin


# XDG_USER_DIRS
#set -x XDG_DATA_DIRS "/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:/$HOME/.local/share/flatpak/exports/share"

function ldd
    bash -c 'source $CC_BASE/aws/scripts/cc-aws-login --environment dev --profile dev-developer && exec fish'
end

function lds
    bash -c 'source $CC_BASE/aws/scripts/cc-aws-login --environment dev --profile dev-superuser && exec fish'
end

function lda
    bash -c 'source $CC_BASE/aws/scripts/cc-aws-login --environment dev --profile dev-admin && exec fish'
end

function lsd
    bash -c 'source $CC_BASE/aws/scripts/cc-aws-login --environment stage --profile stage-developer && exec fish'
end                                                                                 
                                                                                    
function lss                                                                        
    bash -c 'source $CC_BASE/aws/scripts/cc-aws-login --environment stage --profile stage-superuser && exec fish'
end                                                                                 
                                                                                    
function lsa                                                                        
    bash -c 'source $CC_BASE/aws/scripts/cc-aws-login --environment stage --profile stage-admin && exec fish'
end

function lpd
    bash -c 'source $CC_BASE/aws/scripts/cc-aws-login --environment prod --profile prod-developer && exec fish'
end

function lps
    bash -c 'source $CC_BASE/aws/scripts/cc-aws-login --environment prod --profile prod-superuser && exec fish'
end

function lpa
    bash -c 'source $CC_BASE/aws/scripts/cc-aws-login --environment prod --profile prod-admin && exec fish'
end

set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
pyenv init - fish | source

alias vim nvim
set -x CURITY_OVERRIDE_HOSTNAME "localhost"

starship init fish | source
