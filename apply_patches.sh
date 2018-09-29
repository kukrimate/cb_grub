#!/bin/sh

if [ ! -d grub ]; then
	echo Please clone the grub submodule
	exit 1
fi

cd grub

for i in ../patches/*; do
	echo Appling $i
	patch -Np1 -i $i
done
