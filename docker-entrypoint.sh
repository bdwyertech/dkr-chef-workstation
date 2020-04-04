#!/bin/sh -e
# Magical Entrypoint
# Brian Dwyer - Broadridge Financial Solutions

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
