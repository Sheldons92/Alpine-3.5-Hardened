#!/usr/bin/env bash

source version.sh

case $1 in
	M ) index=0;;
	m ) index=1;;
	p ) index=2;;
esac

if [ ! "$index" ]; then
	echo "Usage $0 (M|m|p)"
	exit 1
fi

COMPONENTS=($(echo $VERSION | tr "." "\n"))
COMPONENTS[$index]=$[${COMPONENTS[$index]} + 1]

echo VERSION=${COMPONENTS[0]}.${COMPONENTS[1]}.${COMPONENTS[2]} > version.sh
