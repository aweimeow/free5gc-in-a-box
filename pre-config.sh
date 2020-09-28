#!/bin/bash

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

VAGRANT_UID='1000'
SYNCED_FOLDER='/config'

print YELLOW "[Info] Start pre-config script"

print YELLOW "[Info] Install dependencies"
apt-get update -qq \
	&& apt-get install -qq \
		git \
		build-essential \
		vim \
		strace \
		net-tools \
		iputils-ping \
		iproute2 \
        mongodb \
        wget \
        gcc \
        cmake \
        autoconf \
        libtool \
        pkg-config \
        libmnl-dev \
        libyaml-dev \

print YELLOW "[Info] Install Go Language"
wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz
tar -C /usr/local -zxvf go1.14.4.linux-amd64.tar.gz
mkdir -p ~/go/{bin,pkg,src}

print RED "[Kernel] Update kernel version: 5.0.0-23-generic"
apt-get install -qq \
		linux-image-5.0.0-23-generic \
		linux-modules-5.0.0-23-generic \
		linux-headers-5.0.0-23-generic \
	&& grub-set-default 1 \
	&& update-grub

print YELLOW "[Network] Configure Networking"
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
systemctl stop ufw

print GREEN "End the pre-config script. Reload the box ..."
