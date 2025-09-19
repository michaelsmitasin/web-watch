#! /usr/bin/bash

### This is a simple script to test gowitness

### Load variables from settings.conf

DOQUIET="-q"
SETTINGSFILE="./settings.conf"
. $SETTINGSFILE

### FUNCTIONS

USAGE(){
	echo "$0 <option>"
	echo ""
	echo "	-v		verbose output"
	echo "	-u <url_list>		list of urls to grab screenshots from"
	echo "	-S <screenshot_path>	specify path to write out screenshots"
	echo ""
	echo "Example: $0 -u testurls -S TESTSCREENSHOTS"

	exit 1
}

CHECKDEPENDENCIES(){
	DEPENDENCIES="$(cat dependency_list)"
	for DEPENDENCY in $DEPENDENCIES
	do
		if [ -z $(which $DEPENDENCY) ]
		then
			echo "Error: dependency missing: $DEPENDENCY"
			exit 1
		fi
	done
}

FETCHSCREENSHOTS(){
	$GOWITNESSCMD $DOQUIET scan file -f $URLLIST --screenshot-path $SCREENSHOTPATH --chrome-window-x $GOWITNESSXWINDOW --chrome-window-y $GOWITNESSYWINDOW --chrome-user-agent $GOWITNESSUSERAGENT -T $GOWITNESSTIMEOUT
}

### PRE-EXECUTION

# Check options

if [ -z "$1" ]
then
        USAGE
fi

while [ $# -gt 0 ]
do
    unset OPTIND
    unset OPTARG
    while getopts vS:u: OPTIONS
    do
    case $OPTIONS in
            v) DOQUIET="";;
            S) SCREENSHOTPATH="$OPTARG";;
            u) URLLIST="$OPTARG";;
            *) echo "Uh oh, unrecognized option"; exit 1;;
        esac
   done
   shift $((OPTIND-1))
   ARGS="${ARGS} $1 "
   shift
done

if [ -z "$SCREENSHOTPATH" ]
then
	echo "Error: must specify -S screenshot"
	exit 1
fi

if [ -z "$URLLIST" ]
then
	echo "Error: must specify -u url_list"
	exit 1
fi

CHECKDEPENDENCIES


### EXECUTION
FETCHSCREENSHOTS

