#!/usr/bin/env bash

function print() {
	case "$1" in
		RED)
			COLOR="\033[01;31m";;
		YELLOW)
			COLOR="\033[01;33m";;
		GREEN)
			COLOR="\033[01;32m";;
		WHITE)
			COLOR="\033[01;37m";;
		*)
			COLOR="\033[0m";;
	esac
	END="\033[0m"

	echo -e "$COLOR$2$END"
}

print YELLOW "Start post-config script"

print RED "[Kernel] Install gtp5g kernel module"
cd /root \
    && git clone https://github.com/PrinzOwO/gtp5g.git \
    && cd gtp5g \
    && make clean \
    && make \
    && make install

print WHITE "[Conf] Configure Go-related environment variable"

sudo -i -u vagrant bash << EOF
echo 'export GOPATH=\$HOME/go' >> ~/.bashrc
echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
echo 'export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin' >> ~/.bashrc
EOF

sudo -i -u vagrant bash << EOF
# Set environment variable since sudo won't load ~/.bashrc
export GOPATH=\$HOME/go
export GOROOT=/usr/local/go
export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin

echo "[Info] Install Go package"
go get -u github.com/sirupsen/logrus

echo "[Git] Cloning free5gc project from GitHub"
git clone https://github.com/free5gc/free5gc --depth 1

echo "[Git] Get the submodule from GitHub"
cd ~/free5gc
git checkout master
git submodule sync
git submodule update --init --jobs `nproc`
git submodule foreach git checkout master
git submodule foreach git pull --jobs `nproc`

echo "[Go] Building free5gc core"
go mod download
./build.sh
EOF

print GREEN "End post-config script"
