#!/usr/bin/env bash
source $DOTFILES/source/00_dotfiles.sh

e_header "$(basename "$0" .sh)"

function test_assert() { assert "$actual" "$expected"; }

# Fixtures
empty=()
fixture1=(a b "" "c d" " e " "  'f'  " " \"g'h\" " i "")

# Tests
e_header array_map

IFS= read -rd '' actual < <(array_map empty)
expected=$''
test_assert

IFS= read -rd '' actual < <(array_map fixture1)
expected=$'a\nb\n\nc d\n e \n  \'f\'  \n \"g\'h\" \ni\n\n'
test_assert

function map() { echo "<$2:${1:-X}>"; }
IFS= read -rd '' actual < <(array_map fixture1 map)
expected=$'<0:a>\n<1:b>\n<2:X>\n<3:c d>\n<4: e >\n<5:  \'f\'  >\n<6: \"g\'h\" >\n<7:i>\n<8:X>\n'
test_assert

e_header array_print

IFS= read -rd '' actual < <(array_print empty)
expected=$''
test_assert

IFS= read -rd '' actual < <(array_print fixture1)
expected=$'0 <a>\n1 <b>\n2 <>\n3 <c d>\n4 < e >\n5 <  \'f\'  >\n6 < \"g\'h\" >\n7 <i>\n8 <>\n'
test_assert


e_header array_filter

IFS= read -rd '' actual < <(array_filter empty)
expected=$''
test_assert

IFS= read -rd '' actual < <(array_filter fixture1)
expected=$'a\nb\nc d\n e \n  \'f\'  \n \"g\'h\" \ni\n'
test_assert

function filter() { [[ "$1" && ! "$1" =~ [[:space:]] ]]; }
IFS= read -rd '' actual < <(array_filter fixture1 filter)
expected=$'a\nb\ni\n'
test_assert

function filter() { [[ "$1" && "$1" =~ [[:space:]] ]]; }
IFS= read -rd '' actual < <(array_filter fixture1 filter)
expected=$'c d\n e \n  \'f\'  \n \"g\'h\" \n'
test_assert

function filter() { [[ $(($2 % 2)) == 0 ]]; }
IFS= read -rd '' actual < <(array_filter fixture1 filter)
expected=$'a\n\n e \n \"g\'h\" \n\n'
test_assert

function filter() { [[ $(($2 % 2)) == 1 ]]; }
IFS= read -rd '' actual < <(array_filter fixture1 filter)
expected=$'b\nc d\n  \'f\'  \ni\n'
test_assert


e_header array_filter_i

IFS= read -rd '' actual < <(array_filter_i empty)
expected=$''
test_assert

IFS= read -rd '' actual < <(array_filter_i fixture1)
expected=$'0\n1\n3\n4\n5\n6\n7\n'
test_assert

function filter() { [[ "$1" && ! "$1" =~ [[:space:]] ]]; }
IFS= read -rd '' actual < <(array_filter_i fixture1 filter)
expected=$'0\n1\n7\n'
test_assert

function filter() { [[ "$1" && "$1" =~ [[:space:]] ]]; }
IFS= read -rd '' actual < <(array_filter_i fixture1 filter)
expected=$'3\n4\n5\n6\n'
test_assert

function filter() { [[ $(($2 % 2)) == 0 ]]; }
IFS= read -rd '' actual < <(array_filter_i fixture1 filter)
expected=$'0\n2\n4\n6\n8\n'
test_assert

function filter() { [[ $(($2 % 2)) == 1 ]]; }
IFS= read -rd '' actual < <(array_filter_i fixture1 filter)
expected=$'1\n3\n5\n7\n'
test_assert


e_header array_join

IFS= read -rd '' actual < <(array_join empty ',')
expected=$''
test_assert

IFS= read -rd '' actual < <(array_join fixture1 ',')
expected=$'a,b,,c d, e ,  \'f\'  , \"g\'h\" ,i,\n'
test_assert

IFS= read -rd '' actual < <(array_join fixture1 ', ')
expected=$'a, b, , c d,  e ,   \'f\'  ,  \"g\'h\" , i, \n'
test_assert


e_header array_join_filter

IFS= read -rd '' actual < <(array_join_filter empty ',')
expected=$''
test_assert

IFS= read -rd '' actual < <(array_join_filter fixture1 ',')
expected=$'a,b,c d, e ,  \'f\'  , \"g\'h\" ,i\n'
test_assert

IFS= read -rd '' actual < <(array_join_filter fixture1 ', ')
expected=$'a, b, c d,  e ,   \'f\'  ,  \"g\'h\" , i\n'
test_assert
