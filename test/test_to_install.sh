#!/usr/bin/env bash
source ~/.dotfiles/source/00_dotfiles.sh

e_header "$(basename "$0" .sh)"

function my_test() {
  to_install "${desired[*]}" "${installed[*]}"
}

desired=(a b c); installed=(); assert "a b c" my_test
desired=(a b c); installed=(a); assert "b c" my_test
desired=(a b c); installed=(b); assert "a c" my_test
desired=(a b c); installed=(c); assert "a b" my_test
desired=(a b c); installed=(a b); assert "c" my_test
desired=(a b c); installed=(c a); assert "b" my_test
desired=(a a-b); installed=(a); assert "a-b" my_test
desired=(a a-b); installed=(a-b); assert "a" my_test
desired=(a a-b c); installed=(a-b); assert "a c" my_test
desired=(a-b a); installed=(a); assert "a-b" my_test
desired=(a-b a); installed=(a-b); assert "a" my_test
desired=(a a-b); installed=(a-b a); assert "" my_test
desired=(a-b a); installed=(a-b a); assert "" my_test
desired=(a a-b); installed=(a a-b); assert "" my_test
desired=(a-b a); installed=(a a-b); assert "" my_test
