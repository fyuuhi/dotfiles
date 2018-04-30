#!/bin/sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cd ~/.vim
mkdir undo
mkdir tmp 
