#! /bin/sh

### Load variables from settings.conf

SETTINGSFILE="./settings.conf"
. $SETTINGSFILE

### FUNCTIONS

USAGE(){
	echo "$0 <option>"
	echo ""
	echo "	-n		NO-OP, just dump the query to stdout"
	echo "	-m <model_name>		specify model to use"
	echo "	-S <screenshot_path>	specify screenshot path"
	echo "	-P <prompt>		specify prompt"
	echo ""
	echo "Example: $0 -m gpt-4o -S http---www.example.com.jpeg -P prompt.conf"

	exit 1
}

CHECKDEPENDENCIES(){
	DEPENDENCIES="base64 basename jq curl tr"
	for DEPENDENCY in $DEPENDENCIES
	do
		if [ -z $(which $DEPENDENCY) ]
		then
			echo "Error: dependency missing: $DEPENDENCY"
			exit 1
		fi
	done
}

ANALYZE(){
	IMAGEBASE64="$(base64 $SCREENSHOT | tr -d '[:cntrl:]' )"
	FILENAME=$(basename $SCREENSHOT)
	PROMPT=$(cat $PROMPTFILE | grep -v "^####" | sed "s/!!!!/$FILENAME/g")
        DATA=$( echo '{"model": "'$MODEL'", "temperature": 0.0,
	"messages": [{"role": "system", "content": "'$PROMPT'"}, {"role": "user", "content": [ { "type": "image_url", "image_url": { "url": "data:image/jpeg;base64,'$IMAGEBASE64'"} }] }]
	}' | tr -d '[:cntrl:]' )

	# write DATA to JSON, later POSTs to API
	echo "$DATA" > singlequerydata.json
	
	curl -s -X POST $VLMAPIURL/v1/chat/completions  \
  	-H "Content-Type: application/json" \
  	-H "Authorization: Bearer $VLMAPIKEY" \
  	-d @singlequerydata.json  | tr -d '\n' | jq -r .  | sed 's/\\"//g'
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
    while getopts nlm:S:P: OPTIONS
    do
    case $OPTIONS in
            n) NOOP="1";;
            m) MODEL="$OPTARG";;
            S) SCREENSHOT="$OPTARG";;
            P) PROMPTFILE="$OPTARG";;
            *) echo "Uh oh, unrecognized option"; exit 1;;
        esac
   done
   shift $((OPTIND-1))
   ARGS="${ARGS} $1 "
   shift
done

if [ -z "$MODEL" ]
then
	MODEL="$VLMDEFAULTMODEL"
fi

if [ -z "$SCREENSHOT" ]
then
	echo "Error: must specify -S screenshot"
	exit 1
fi

if [ -z "$PROMPTFILE" ]
then
	echo "Error: must specify -P promptfile"
	exit 1
fi

CHECKDEPENDENCIES


### EXECUTION

if [ "$NOOP" -eq "1" ]
then
	echo "NOOP"
	exit 0
fi

ANALYZE
