# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f /nail/scripts/aliases.sh ]; then
    . /nail/scripts/aliases.sh
fi

export SRCBASE=~/pg
export SRCROOT=$SRCBASE/yelp-main

export CDPATH=.:$SRCROOT:$SRCROOT/yelp:$SRCROOT/yelp/logic


alias code="pushd ~/pg/yelp-main"
alias ipy="ipython $SRCROOT/tools/interactive.py"
alias remakeremake="make clean && make clean-config && make"
function ackpp()
{
	ack $* --type=puppet *
}

function ackpy()
{
	ack $* --type=python *
}
