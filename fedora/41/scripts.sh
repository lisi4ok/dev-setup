#!/bin/bash


# get_latest_github_version() {
#   if [[ -n ${1} && -n ${2} ]]; then
#     local VERSION=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/${1}/${2}/releases/latest)
#     echo ${VERSION##*/}
#   fi
# }
# get_latest_release_github() {
#   curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
#     grep '"tag_name":' |                                            # Get tag line
#     sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
# }
latest_release() { git ls-remote --tags "$1" | cut -d/ -f3- | tail -n1; }


install_phalcon() {
  # local PHALCON_VERSION=$(latest_release https://github.com/phalcon/cphalcon)
  # local PHP_VERSION=$(php -v | head -n 1 | cut -d " " -f 2 | cut -f1-2 -d".")
  # local FOLDER="php-${PHALCON_VERSION}-phalcon-${PHP_VERSION}"
  # if [[ -d ./tmp ]]; then
  #   sudo rm -rf ./tmp
  # fi
  # git clone --depth 1 --branch ${PHALCON_VERSION} https://github.com/phalcon/cphalcon ./tmp

  # ////
  # sudo cp -f ./phalcon/phalcon.so /usr/lib64/php/modules/
  # sudo chmod 755 /usr/lib64/php/modules/phalcon.so
  # sudo chown root:root /usr/lib64/php/modules/phalcon.so

  # sudo cp -f ./phalcon/50-phalcon.ini /etc/php.d/
  # sudo chmod 644 /etc/php.d/50-phalcon.ini
  # sudo chown root:root /etc/php.d/50-phalcon.ini
  # ////

  # cd phalcon
  # find . -type d -exec chmod -R 755 {} \;
  # find . -type f -name "*.ini" -exec chmod -R 644 {} \;
  # find . -type f -name "*.so" -exec chmod -R 755 {} \;
  # sudo chown -R root:root .
  # sudo tar -czvf phalcon.tar.gz .
  # cd ..
  # sudo chown -R user:user phalcon


  sudo tar -xf phalcon.tar.gz -C /

}

add_aliases() {
  if ! grep -wq ". ~/.bash_aliases" ~/.bashrc; then
    tee -a ~/.bashrc > /dev/null <<EOT

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

EOT

  fi
  cp -f ./.bash_aliases ~/
}

core_install() {
  sudo dnf install -y \
  vim \
  vim-default-editor --allowerasing \
  wget \
  awk \
  sed \
  curl  \
  unzip \
  git-core \
  make
}

c_install() {
  if [[ ! -x "$(command -v gcc)" || ! -x "$(command -v clang)" || ! -x "$(command -v rust)" ]]; then
    sudo dnf install -y \
    clang \
    gcc \
    gcc-c++ \
    libgcc \
    glibc-devel \
    autoconf \
    automake \
    cmake \
    make \
    mongo-c-driver \
    rust \
    cargo
  fi
}

ruby_install() {
  sudo dnf install -y \
  git-core \
  gcc \
  rust \
  patch \
  make \
  bzip2 \
  openssl-devel \
  libyaml-devel \
  libffi-devel \
  readline-devel \
  zlib-devel \
  gdbm-devel \
  ncurses-devel \
  perl-FindBin \
  perl-lib \
  perl-File-Compare

  if [[ ! -x "$(command -v rbenv)"  ]]; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'eval "$(~/.rbenv/bin/rbenv init -)"' >> ~/.bashrc
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
    exec $SHELL -l
  fi
  if [[ ! -x "$(command -v ruby)"  ]]; then
    local ruby_version=$(rbenv install -l | sed -n '/^[[:space:]]*[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}[[:space:]]*$/ h;${g;p;}')
    rbenv install ${ruby_version}
  fi
}

php_install() {
  if [[ ! -x "$(command -v sqlite3)"  ]]; then
    sudo dnf install -y sqlite
  fi

  if [[ ! -x "$(command -v php)"  ]]; then
    sudo dnf install -y \
    php-bcmath \
    php-cli \
    php-common \
    php-dba \
    php-dbg \
    php-devel \
    php-embedded \
    php-enchant \
    php-ffi \
    php-fpm \
    php-gd \
    php-gmp \
    php-intl \
    php-ldap \
    php-mbstring \
    php-mysqlnd \
    php-odbc \
    php-opcache \
    php-pdo \
    php-pdo-dblib \
    php-pgsql \
    php-process \
    php-pspell \
    php-snmp \
    php-soap \
    php-sodium \
    php-tidy \
    php-xml \
    php-mongodb

    if [[ ! -x "$(command -v composer)"  ]]; then
        sudo dnf install -y composer
    fi

    install_phalcon

    # if [[ ! -x "$(command -v pecl)"  ]]; then
    #     sudo dnf install -y php-pear
    #     sudo chown $(whoami) $(pecl config-get php_dir)
    #     pecl channel-update pecl.php.net
    #     sudo pecl install -y \
    #     psr \
    #     mongodb \
    #     phalcon
    # fi

  fi
}

js_install() {
  # Install Bun/Deno
  if [[ ! -x "$(command -v bun)"  ]]; then
    curl -fsSL https://bun.sh/install | bash
  fi
  if [[ ! -x "$(command -v deno)"  ]]; then
    curl -fsSL https://deno.land/install.sh | sh
  fi

  # Install NVM
  if [[ ! -x "$(command -v nvm)"  ]]; then
    export NVM_DIR="$HOME/.nvm" && (
      git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
      cd "$NVM_DIR"
      git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && \. "$NVM_DIR/nvm.sh"

    tee -a ~/.bashrc > /dev/null <<EOT

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOT
    exec $SHELL -l
  fi
  if [[ ! -x "$(command -v npm)"  ]]; then
    nvm install --latest-npm
  fi
}

dev_install() {
  add_aliases
  core_install
  c_install
  ruby_install
  php_install
  js_install

  exit 1
}

display_help() {
    echo "Usage: bash $0 [option...] {dev|core|ruby|php|js}" >&2
    echo
    echo "   -a, -A, --all           Install all development tools"
    echo "   -i, -I, --aliases       Install all bash aliases"
    echo "   -b, -B, --core          Install all core things"
    echo "   -r, -R, --ruby          Install all ruby tools"
    echo "   -p, -P, --php           Install all php tools"
    echo "   -d, -D, --js            Install all js tools"
    echo

    exit 1
}

check_os() {
  local DISTRIBUTION=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g' | sed -e 's/"//g')
  local VERSION=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g' | sed -e 's/"//g')
  if [[ ${DISTRIBUTION} != 'fedora' || ${VERSION}  < 41 ]]; then
    echo "Invalid OS"
    exit 1
  fi
}

# BEGIN
if [[ -z ${1} ]]; then
  display_help
  exit 1
fi

check_os

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|-H|--help) display_help; shift ;;
        -a|-A|--all) dev_install; shift ;;
        -i|-I|--aliases) add_aliases; shift ;;
        -b|-B|--core) core_install; shift ;;
        -c|-C|--c) c_install; shift ;;
        -r|-R|--ruby) ruby_install; shift ;;
        -p|-P|--php) php_install; shift ;;
        -j|-J|--js) js_install; shift ;;
        *) echo "Unknown parameter passed: $1" ;;
    esac
    shift
done
