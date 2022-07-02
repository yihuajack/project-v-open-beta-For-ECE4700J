#!/bin/zsh
setopt null_glob  # shopt -s nullglob for bash
for filepath in test_progs/*.(c|s); do
	echo $filepath
	make SRC=$(basename $filepath)
done

