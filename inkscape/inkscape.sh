#!/usr/bin/bash
scour -i ./logo.svg -o ../images/logo.svg --enable-viewboxing --enable-id-stripping \
  --enable-comment-stripping --shorten-ids --indent=none
scour -i ./drawer.svg -o ../images/drawer.svg --enable-viewboxing --enable-id-stripping \
  --enable-comment-stripping --shorten-ids --indent=none

mkdir ./tmp

inkscape ./logo.svg -o ./tmp/favicon-32.png -w 32
inkscape ./logo.svg -o ./tmp/favicon-64.png -w 64
inkscape ./logo.svg -o ./tmp/favicon-128.png -w 128
inkscape ./logo.svg -o ./tmp/favicon-256.png -w 256

cd ./tmp

convert ./favicon-32.png ./favicon-64.png ./favicon-128.png ./favicon-256.png ./favicon.ico

mv ./favicon.ico ../../images/favicon.ico

cd ../
rm -rd ./tmp
