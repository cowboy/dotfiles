#!/bin/bash
source ~/.dotfiles/source/00_dotfiles.sh

e_header to_install

function to_install_test() {
  assert_actual=($(to_install "${desired[*]}" "${installed[*]}"))
  assert_actual="${assert_actual[*]}"
}

desired=(a b c); installed=(); assert "a b c" to_install_test
desired=(a b c); installed=(a); assert "b c" to_install_test
desired=(a b c); installed=(b); assert "a c" to_install_test
desired=(a b c); installed=(c); assert "a b" to_install_test
desired=(a b c); installed=(a b); assert "c" to_install_test
desired=(a b c); installed=(c a); assert "b" to_install_test
desired=(a a-b); installed=(a); assert "a-b" to_install_test
desired=(a a-b); installed=(a-b); assert "a" to_install_test
desired=(a a-b c); installed=(a-b); assert "a c" to_install_test
desired=(a-b a); installed=(a); assert "a-b" to_install_test
desired=(a-b a); installed=(a-b); assert "a" to_install_test
desired=(a a-b); installed=(a-b a); assert "" to_install_test
desired=(a-b a); installed=(a-b a); assert "" to_install_test
desired=(a a-b); installed=(a a-b); assert "" to_install_test
desired=(a-b a); installed=(a a-b); assert "" to_install_test
