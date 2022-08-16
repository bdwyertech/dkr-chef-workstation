#!/bin/sh -e
# Magical Entrypoint
# Brian Dwyer - Broadridge Financial Solutions

if [ -n "$CHEFWKSTN_FIX_UID" ] && [ ! -f '/tmp/.fixed-chef-perms' ]; then
	if [ "$(whoami)" != "chef" ]; then
		fix-permissions id "$(id -u)"
	fi
	if [ -n "$PROJECT_SOURCE" ]; then
		git config --global --add safe.directory "$PROJECT_SOURCE"
	fi
	touch /tmp/.fixed-chef-perms
fi

# Kitchen Wrapper & Passthrough
case "$1" in
	console ) kitchen "$@";;
	converge ) kitchen "$@";;
	create ) kitchen "$@";;
	destroy ) kitchen "$@";;
	diagnose | doctor ) kitchen "$@";;
	exec ) kitchen "$@";;
	help ) kitchen "$@";;
	init ) kitchen "$@";;
	list ) kitchen "$@";;
	login ) kitchen "$@";;
	package ) kitchen "$@";;
	setup ) kitchen "$@";;
	test ) kitchen "$@";;
	verify ) kitchen "$@";;
	version ) kitchen "$@";;
	-* ) kitchen "$@";;
	* )	exec "$@";;
esac
