#! /usr/bin/bash

### Orchestration script that calls other scripts

SESSIONID="$(date -Iminutes | cut -d"+" -f1)_$(head /dev/random | LC_ALL=C tr -dc A-Za-z0-9 | head -c8)"
VERBOSE=""

### Load variables from settings.conf

SETTINGSFILE="./settings.conf"
. $SETTINGSFILE

### FUNCTIONS

USAGE(){
	echo "$0 <option>"
	echo ""
	echo "	-v		verbose output"
	echo "	-u <url_list>		list of urls to grab screenshots from"
	echo "	-m <model>		specify Vision Language Model to use for analysis (default: gpt-4o"
	echo "	-p <promptfile>		prompt file to use"
	echo "	-S <screenshots_dir>	specify path of screenshots (default: SCREENSHOTS/<sessionid>)"
	echo ""
	echo "Example: $0 -u testurls -p prompt.conf"

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
	if [ "$VERBOSE" -eq "0" ]
	then
		$FETCHSCRIPT -u $URLLIST -S $SCREENSHOTDIR
	elif [ "$VERBOSE" -eq "1" ]
	then
		$FETCHSCRIPT -v -u $URLLIST -S $SCREENSHOTDIR
	fi
}

BUILDSCREENSHOTLIST(){
	SCLIST=$(find $SCREENSHOTDIR -type f -name "*.jpeg")
}

ANALYZE(){
	# Prep results directory
	mkdir -p "$WORKINGDIR/RESULTS/"
	for SCREENSHOT in $SCLIST
	do
		if [ "$VERBOSE" -eq "1"  ]
		then
			echo "Analyzing: $SCREENSHOT"
		fi
		$ANALYZESCRIPT -m gpt-4o -S $SCREENSHOT -P $PROMPTFILE >> $WORKINGDIR/RESULTS/$SESSIONID.csv
	done
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
    while getopts vm:S:u:p: OPTIONS
    do
    case $OPTIONS in
            v) VERBOSE="1";;
            m) MODEL="$OPTARG";;
            S) SCREENSHOTDIR="$OPTARG";;
            u) URLLIST="$OPTARG";;
            p) PROMPTFILE="$OPTARG";;
            *) echo "Uh oh, unrecognized option"; exit 1;;
        esac
   done
   shift $((OPTIND-1))
   ARGS="${ARGS} $1 "
   shift
done

if [ -z "$SCREENSHOTDIR" ]
then
	SCREENSHOTDIR="SCREENSHOTS/$SESSIONID"
fi

if [ -z "$PROMPTFILE" ]
then
	echo "Error: must specify -p promptfile"
	exit 1
fi

if [ -z "$MODEL" ]
then
	MODEL=$VLMDEFAULTMODEL
fi

if [ -z "$URLLIST" ]
then
	echo "Error: must specify -u url_list"
	exit 1
fi

CHECKDEPENDENCIES


### EXECUTION

FETCHSCREENSHOTS
BUILDSCREENSHOTLIST
ANALYZE

