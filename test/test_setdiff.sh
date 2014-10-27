#!/usr/bin/env bash
source $DOTFILES/source/00_dotfiles.sh

e_header "$(basename "$0" .sh)"

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

unset setdiffA setdiffB setdiffC
setdiff "a b c" "" >/dev/null
assert "0" echo "${#setdiffC[@]}"

unset setdiffA setdiffB setdiffC; setdiffA=(a b c); setdiffB=(); setdiff
assert "3" echo "${#setdiffC[@]}"
assert "a b c" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=(a b c); setdiffB=(a); setdiff
assert "2" echo "${#setdiffC[@]}"
assert "b c" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=(a b c); setdiffB=(c a); setdiff
assert "1" echo "${#setdiffC[@]}"
assert "b" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=("a b" c); setdiffB=(a b c); setdiff
assert "1" echo "${#setdiffC[@]}"
assert "a b" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=(a b "a b" c "c d"); setdiffB=(a c); setdiff
assert "3" echo "${#setdiffC[@]}"
assert "b a b c d" echo "${setdiffC[*]}"
