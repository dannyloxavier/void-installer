#!/bin/sh

#sh <(curl -s -L https://raw.githubusercontent.com/voidlinux-br/void-installer/master/install.sh)
#sh <(wget -q -O - https://raw.githubusercontent.com/voidlinux-br/void-installer/master/install.sh)
#source <(curl -s -L https://raw.githubusercontent.com/voidlinux-br/void-installer/master/install.sh)
#source <(wget -q -O - https://raw.githubusercontent.com/voidlinux-br/void-installer/master/install.sh)

#  install.sh
#  Created: 2023/01/10
#  Altered: 2023/04/05
#
#  Copyright (c) 2023-2023, Vilmar Catafesta <vcatafesta@gmail.com>
#                2023-2023, Felipe Nogueira <contato.fnog@gmail.com>
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
#  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

{
	oops() {
		echo "$0:" "$@" >&2
		exit 1
	}

	umask 0022
	url="https://raw.githubusercontent.com/voidlinux-br/void-installer/master"
	files=('void-install' 'void-gitclone' 'void-mirror' 'void-services'
			 'void-testmirror' 'void-wifi' 'void-remove-vg' 'void-clonedisk'
			 'ChangeLog.txt' 'INSTALL' 'LICENSE' 'MAINTAINERS' 'Makefile'
			 'README.md' 'bashrc.sh' '.dircolors' 'void-x86_64-base-custom-current.tar.xz')
	tmpDir=~/void-installer
	[[ ! -d "$tmpDir" ]] && { mkdir "$tmpDir" || oops "Não é possível criar diretório temporário para baixar arquivos";}

	require_util() {
		command -v "$1" > /dev/null 2>&1 ||
			oops "você não tem '$1' instalado, que é preciso para $2"
	}

	#require_util tar "descompatar o tarball"

	if command -v curl > /dev/null 2>&1; then
		cmdfetch() { curl --silent --continue-at - --insecure -L "$1" -o "$2"; }
	elif command -v wget > /dev/null 2>&1; then
		cmdfetch() { wget --quiet -c "$1" -O "$2"; }
	else
		oops "você não tem wget ou curl instalado, que é necessário para baixar os arquivos"
	fi

	for f in "${files[@]}"
	do
		echo "baixando $f from '$url' to '$tmpDir'..."
		cmdfetch "$url/$f" "$tmpDir/$f" || oops "falha no download '$url/$f'"
	done

	chmod +x $tmpDir/void-install
	chmod +x $tmpDir/void-gitclone
	chmod +x $tmpDir/void-mirror
	chmod +x $tmpDir/void-services
	chmod +x $tmpDir/void-testmirror
	chmod +x $tmpDir/void-remove-vg
	chmod +x $tmpDir/void-clonedisk
	chmod +x $tmpDir/void-wifi
	chmod +x $tmpDir/bashrc.sh
	ls -la --color=auto $tmpDir

	echo
	echo "Entre em: $tmpDir e digite:"
	echo "sudo ./void-install"
}
