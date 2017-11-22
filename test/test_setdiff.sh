#!/usr/bin/env bash
source $DOTFILES/source/00_dotfiles.sh

e_header "$(basename "$0" .sh)"

# Strings
function my_test() {
  setdiff "${desired[*]}" "${installed[*]}"
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

# Arrays
unset setdiff_new setdiff_cur setdiff_out
setdiff "a b c" "" >/dev/null
assert 0 echo "${#setdiff_out[@]}"

unset setdiff_new setdiff_cur setdiff_out
setdiff_new=(a b c); setdiff_cur=(); setdiff
assert 3 echo "${#setdiff_out[@]}"
assert "a" echo "${setdiff_out[0]}"
assert "b" echo "${setdiff_out[1]}"
assert "c" echo "${setdiff_out[2]}"

unset setdiff_new setdiff_cur setdiff_out
setdiff_new=(a b c); setdiff_cur=(a); setdiff
assert 2 echo "${#setdiff_out[@]}"
assert "b" echo "${setdiff_out[0]}"
assert "c" echo "${setdiff_out[1]}"

unset setdiff_new setdiff_cur setdiff_out
setdiff_new=(a b c); setdiff_cur=(c a); setdiff
assert 1 echo "${#setdiff_out[@]}"
assert "b" echo "${setdiff_out[0]}"

unset setdiff_new setdiff_cur setdiff_out
setdiff_new=("a b" c); setdiff_cur=(a b c); setdiff
assert 1 echo "${#setdiff_out[@]}"
assert "a b" echo "${setdiff_out[0]}"

unset setdiff_new setdiff_cur setdiff_out
setdiff_new=(a b "a b" c "c d"); setdiff_cur=(a c); setdiff
assert 3 echo "${#setdiff_out[@]}"
assert "b" echo "${setdiff_out[0]}"
assert "a b" echo "${setdiff_out[1]}"
assert "c d" echo "${setdiff_out[2]}"

unset setdiff_new setdiff_cur setdiff_out
setdiff_new=(a b "a b" c "c d"); setdiff_cur=(b "c d"); setdiff
assert 3 echo "${#setdiff_out[@]}"
assert "a" echo "${setdiff_out[0]}"
assert "a b" echo "${setdiff_out[1]}"
assert "c" echo "${setdiff_out[2]}"
