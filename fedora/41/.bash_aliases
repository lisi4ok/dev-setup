# .bash_aliases

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias l.='ls -d .*'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias dc="docker-compose"
alias dcf="docker-compose -f docker-compose.yml"
alias mk="minikube"
alias k="kubectl"
alias tf="terraform"
alias expargs='export $(cat .env | xargs)'


alias rbnv='rbenv'
alias rvg='rbenv global'
alias r='ruby'
alias rb='ruby'

alias crnv='crenv'
alias cr='crystal'

alias phpnv='phpenv'
alias penv='phpenv'
alias pnv='phpenv'
alias p='php'

alias g='git'

cd() {
  builtin cd "$@" && ls -alF
}

fix-ssh() {
  if [ -d ~/.ssh ]; then
    find ~/.ssh -type d -exec chmod 700 {} \;
    find ~/.ssh -type f -exec chmod 600 {} \;
    find ~/.ssh -type f -name "*.pub" -exec chmod 644 {} \;
    chmod 700 ~/.ssh
  fi

  # if [ -d ~/.ssh ]; then
  #   chmod -R 700 ~/.ssh
  # fi

  # if [ -f ~/.ssh/id_rsa ]; then
  #   chmod 600 ~/.ssh/id_rsa
  # fi

  # if [ -f ~/.ssh/id_rsa.pub ]; then
  #   chmod 644 ~/.ssh/id_rsa.pub
  # fi
}